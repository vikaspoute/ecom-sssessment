import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/models/cart_item.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sampleProduct1 = Product(
    id: 'prod_1',
    name: 'Sample Tee',
    description: 'Cotton crewneck tee',
    price: 999.00,
    imageUrl: 'https://example.com/tee.jpg',
    category: ProductCategories.tShirts,
  );

  const sampleProduct2 = Product(
    id: 'prod_2',
    name: 'Sample Denim',
    description: 'Indigo slim denim',
    price: 2499.00,
    imageUrl: 'https://example.com/denim.jpg',
    category: ProductCategories.bottoms,
  );

  group('CartItem', () {
    test('calculates total price correctly', () {
      const item = CartItem(product: sampleProduct1, quantity: 3);
      expect(item.totalPrice, equals(2997.00));
    });

    test('supports equality and copyWith', () {
      const item1 = CartItem(product: sampleProduct1, quantity: 1);
      final item2 = item1.copyWith(quantity: 2);

      expect(item1.quantity, equals(1));
      expect(item2.quantity, equals(2));
      expect(item1 == item2, isFalse);
      expect(
        item1,
        equals(const CartItem(product: sampleProduct1, quantity: 1)),
      );
    });
  });

  group('CartCubit', () {
    late CartCubit cartCubit;

    setUp(() {
      cartCubit = CartCubit();
    });

    tearDown(() {
      cartCubit.close();
    });

    test('starts with an empty cart state', () {
      expect(cartCubit.state.items, isEmpty);
      expect(cartCubit.state.totalItemCount, equals(0));
      expect(cartCubit.state.subtotal, equals(0.0));
      expect(cartCubit.state.isEmpty, isTrue);
    });

    test('adding a product adds it with quantity 1', () {
      cartCubit.addProduct(sampleProduct1);

      expect(cartCubit.state.items.length, equals(1));
      expect(cartCubit.state.items.first.product, equals(sampleProduct1));
      expect(cartCubit.state.items.first.quantity, equals(1));
      expect(cartCubit.state.totalItemCount, equals(1));
      expect(cartCubit.state.subtotal, equals(999.00));
    });

    test(
      'adding the same product twice updates quantity instead of adding row',
      () {
        cartCubit.addProduct(sampleProduct1);
        cartCubit.addProduct(sampleProduct1);

        expect(cartCubit.state.items.length, equals(1));
        expect(cartCubit.state.items.first.quantity, equals(2));
        expect(cartCubit.state.totalItemCount, equals(2));
        expect(cartCubit.state.subtotal, equals(1998.00));
      },
    );

    test('adding different products adds multiple cart items', () {
      cartCubit.addProduct(sampleProduct1, quantity: 2);
      cartCubit.addProduct(sampleProduct2, quantity: 1);

      expect(cartCubit.state.items.length, equals(2));
      expect(cartCubit.state.totalItemCount, equals(3));
      expect(cartCubit.state.subtotal, equals((999.00 * 2) + 2499.00));
      expect(cartCubit.state.quantityForProduct('prod_1'), equals(2));
      expect(cartCubit.state.quantityForProduct('prod_2'), equals(1));
      expect(cartCubit.state.quantityForProduct('prod_nonexistent'), equals(0));
    });

    test(
      'updateQuantity modifies quantity or removes item when quantity <= 0',
      () {
        cartCubit.addProduct(sampleProduct1, quantity: 2);
        cartCubit.updateQuantity('prod_1', 5);

        expect(cartCubit.state.items.first.quantity, equals(5));
        expect(cartCubit.state.totalItemCount, equals(5));

        cartCubit.updateQuantity('prod_1', 0);
        expect(cartCubit.state.items, isEmpty);
        expect(cartCubit.state.totalItemCount, equals(0));
      },
    );

    test('removeProduct removes the product from the cart', () {
      cartCubit.addProduct(sampleProduct1);
      cartCubit.addProduct(sampleProduct2);

      expect(cartCubit.state.items.length, equals(2));

      cartCubit.removeProduct('prod_1');
      expect(cartCubit.state.items.length, equals(1));
      expect(cartCubit.state.items.first.product.id, equals('prod_2'));
    });

    test('decrementProduct decreases quantity when quantity > 1', () {
      cartCubit.addProduct(sampleProduct1, quantity: 3);
      expect(cartCubit.state.quantityForProduct('prod_1'), equals(3));

      cartCubit.decrementProduct('prod_1');
      expect(cartCubit.state.quantityForProduct('prod_1'), equals(2));
      expect(cartCubit.state.totalItemCount, equals(2));
    });

    test('decrementProduct removes item when quantity reaches 1', () {
      cartCubit.addProduct(sampleProduct1, quantity: 1);
      expect(cartCubit.state.hasProduct('prod_1'), isTrue);

      cartCubit.decrementProduct('prod_1');
      expect(cartCubit.state.hasProduct('prod_1'), isFalse);
      expect(cartCubit.state.isEmpty, isTrue);
    });

    test(
      'hasProduct returns true when product is in cart and false otherwise',
      () {
        expect(cartCubit.state.hasProduct('prod_1'), isFalse);
        cartCubit.addProduct(sampleProduct1);
        expect(cartCubit.state.hasProduct('prod_1'), isTrue);
        expect(cartCubit.state.hasProduct('prod_2'), isFalse);
      },
    );

    test(
      'minor currency units prevent floating-point rounding errors in totals',
      () {
        const fractionalProduct = Product(
          id: 'prod_fractional',
          name: 'Fractional Item',
          description: 'Item with decimal price',
          price: 19.99,
          imageUrl: 'https://example.com/item.jpg',
          category: ProductCategories.tShirts,
        );

        // In pure double addition, 19.99 * 3 could yield 59.970000000000006
        cartCubit.addProduct(fractionalProduct, quantity: 3);
        expect(cartCubit.state.items.first.unitPriceInPaise, equals(1999));
        expect(cartCubit.state.items.first.totalPriceInPaise, equals(5997));
        expect(cartCubit.state.subtotalInPaise, equals(5997));
        expect(cartCubit.state.subtotal, equals(59.97));
      },
    );

    test('clearCart empties the cart', () {
      cartCubit.addProduct(sampleProduct1);
      cartCubit.addProduct(sampleProduct2);
      expect(cartCubit.state.isNotEmpty, isTrue);

      cartCubit.clearCart();
      expect(cartCubit.state.isEmpty, isTrue);
      expect(cartCubit.state.totalItemCount, equals(0));
    });
  });
}
