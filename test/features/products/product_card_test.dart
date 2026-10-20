import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/features/products/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: Center(child: SizedBox(width: 240, height: 520, child: child)),
    ),
  );
}

void main() {
  const testProduct = Product(
    id: 'test_tee',
    name: 'Organic Cotton Crew',
    description: 'Soft combed organic cotton jersey tee.',
    price: 999.00,
    originalPrice: 1299.00,
    imageUrl: 'https://example.com/tee.jpg',
    category: ProductCategories.tShirts,
  );

  testWidgets('renders product details and INR formatted prices', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProductCard(product: testProduct)));

    expect(find.text('Organic Cotton Crew'), findsOneWidget);
    expect(find.text('Soft combed organic cotton jersey tee.'), findsOneWidget);
    expect(find.text(999.00.toInr()), findsOneWidget);
    expect(find.text(1299.00.toInr()), findsOneWidget);
    expect(find.text('23% OFF'), findsOneWidget);
  });

  testWidgets('renders in-card stepper when product is in cart', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const ProductCard(product: testProduct, cartQuantity: 3)),
    );

    expect(find.byKey(const ValueKey('quantity_test_tee')), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('invokes onAddToCart callback when button is tapped', (
    tester,
  ) async {
    var added = false;

    await tester.pumpWidget(
      _wrap(ProductCard(product: testProduct, onAddToCart: () => added = true)),
    );

    await tester.tap(find.byKey(const ValueKey('add_to_cart_test_tee')));
    expect(added, isTrue);
  });

  testWidgets('provides accessible semantics for screen readers', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProductCard(product: testProduct)));

    final expectedLabel = '${testProduct.name}, ${999.00.toInr()}';
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Semantics && widget.properties.label == expectedLabel,
      ),
      findsOneWidget,
    );
  });
}
