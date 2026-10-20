import 'package:ecom/features/products/data/product_repository.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product model', () {
    test('supports value equality', () {
      const product1 = Product(
        id: 'test_1',
        name: 'Item',
        description: 'Desc',
        price: 999,
        imageUrl: 'https://example.com/item.jpg',
        category: ProductCategories.tShirts,
      );

      const product2 = Product(
        id: 'test_1',
        name: 'Item',
        description: 'Desc',
        price: 999,
        imageUrl: 'https://example.com/item.jpg',
        category: ProductCategories.tShirts,
      );

      expect(product1, equals(product2));
    });

    test('computes discount percentage correctly', () {
      const discountedProduct = Product(
        id: 'disc_1',
        name: 'Discounted Shirt',
        description: 'Desc',
        price: 800,
        originalPrice: 1000,
        imageUrl: 'https://example.com/shirt.jpg',
        category: ProductCategories.shirts,
      );

      expect(discountedProduct.hasDiscount, isTrue);
      expect(discountedProduct.discountPercentage, equals(20));

      const regularProduct = Product(
        id: 'reg_1',
        name: 'Regular Shirt',
        description: 'Desc',
        price: 1000,
        imageUrl: 'https://example.com/shirt.jpg',
        category: ProductCategories.shirts,
      );

      expect(regularProduct.hasDiscount, isFalse);
      expect(regularProduct.discountPercentage, isNull);
    });
  });

  group('LocalProductRepository', () {
    const repository = LocalProductRepository(delay: Duration.zero);

    test('returns at least five products', () async {
      final products = await repository.getProducts();

      expect(products.length, greaterThanOrEqualTo(5));
      expect(products.length, equals(8));
    });

    test('product IDs are unique', () async {
      final products = await repository.getProducts();

      final ids = products.map((p) => p.id).toSet();
      expect(ids.length, equals(products.length));
    });

    test(
      'products contain valid non-empty fields and non-negative prices',
      () async {
        final products = await repository.getProducts();

        for (final product in products) {
          expect(product.id.trim().isNotEmpty, isTrue);
          expect(product.name.trim().isNotEmpty, isTrue);
          expect(product.description.trim().isNotEmpty, isTrue);
          expect(product.price, greaterThan(0));
          expect(product.imageUrl.trim().isNotEmpty, isTrue);
          expect(product.category.trim().isNotEmpty, isTrue);
        }
      },
    );

    test('catalog includes requested realistic clothing items', () async {
      final products = await repository.getProducts();
      final names = products.map((p) => p.name.toLowerCase()).toList();

      expect(names.any((n) => n.contains('classic cotton t-shirt')), isTrue);
      expect(names.any((n) => n.contains('oversized')), isTrue);
      expect(names.any((n) => n.contains('linen shirt')), isTrue);
      expect(names.any((n) => n.contains('denim jeans')), isTrue);
      expect(names.any((n) => n.contains('chinos')), isTrue);
      expect(names.any((n) => n.contains('hoodie')), isTrue);
      expect(names.any((n) => n.contains('jacket')), isTrue);
      expect(names.any((n) => n.contains('sneakers')), isTrue);
    });
  });
}
