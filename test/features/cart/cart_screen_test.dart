import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/models/cart_item.dart';
import 'package:ecom/features/cart/screens/cart_screen.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, CartCubit cartCubit) {
  return BlocProvider<CartCubit>.value(
    value: cartCubit,
    child: MaterialApp(theme: AppTheme.light(), home: child),
  );
}

void main() {
  const sampleProduct = Product(
    id: 'prod_tee',
    name: 'Classic White Tee',
    description: '100% combed cotton tee.',
    price: 899.00,
    imageUrl: 'https://example.com/tee.jpg',
    category: ProductCategories.tShirts,
  );

  testWidgets('renders EmptyState when cart has no items', (tester) async {
    final cubit = CartCubit();

    await tester.pumpWidget(_wrap(const CartScreen(), cubit));

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Your shopping bag is empty'), findsOneWidget);
    expect(find.text('Explore Curated Catalog'), findsOneWidget);
  });

  testWidgets(
    'renders item list, totals, and checkout button when cart has items',
    (tester) async {
      final cubit = CartCubit(
        initialItems: [const CartItem(product: sampleProduct, quantity: 2)],
      );

      await tester.pumpWidget(_wrap(const CartScreen(), cubit));

      // Header and selection count
      expect(find.text('Shopping Bag'), findsOneWidget);
      expect(find.text('YOUR SELECTION'), findsOneWidget);
      expect(find.text('Total items: 2'), findsOneWidget);

      // Item card
      expect(find.text('Classic White Tee'), findsOneWidget);
      expect(find.text((899.00 * 2).toInr()), findsWidgets);

      // Order summary and checkout
      expect(find.text('Subtotal'), findsOneWidget);
      expect(find.text('Shipping'), findsOneWidget);
      expect(find.text('FREE'), findsOneWidget);
      expect(find.text('Estimated Total'), findsOneWidget);
      expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);
    },
  );

  testWidgets('increment and decrement buttons update item quantity', (
    tester,
  ) async {
    final cubit = CartCubit(
      initialItems: [const CartItem(product: sampleProduct, quantity: 1)],
    );

    await tester.pumpWidget(_wrap(const CartScreen(), cubit));

    // Tap increment
    await tester.tap(find.byKey(const ValueKey('cart_increment_prod_tee')));
    await tester.pump();

    expect(cubit.state.quantityForProduct('prod_tee'), equals(2));
    expect(find.text('Total items: 2'), findsOneWidget);

    // Tap decrement
    await tester.tap(find.byKey(const ValueKey('cart_decrement_prod_tee')));
    await tester.pump();

    expect(cubit.state.quantityForProduct('prod_tee'), equals(1));
    expect(find.text('Total items: 1'), findsOneWidget);
  });

  testWidgets('remove button removes product from cart', (tester) async {
    final cubit = CartCubit(
      initialItems: [const CartItem(product: sampleProduct, quantity: 1)],
    );

    await tester.pumpWidget(_wrap(const CartScreen(), cubit));

    await tester.tap(find.byKey(const ValueKey('remove_item_prod_tee')));
    await tester.pump();

    expect(cubit.state.isEmpty, isTrue);
    expect(find.byType(EmptyState), findsOneWidget);
  });

  testWidgets('checkout button opens checkout preview bottom sheet', (
    tester,
  ) async {
    final cubit = CartCubit(
      initialItems: [const CartItem(product: sampleProduct, quantity: 1)],
    );

    await tester.pumpWidget(_wrap(const CartScreen(), cubit));

    await tester.tap(find.byKey(const ValueKey('checkout_button')));
    await tester.pumpAndSettle();

    expect(find.text('Ready for Checkout'), findsOneWidget);
    expect(find.text('Back to Catalog'), findsOneWidget);
  });
}
