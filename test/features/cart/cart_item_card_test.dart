import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/cart/models/cart_item.dart';
import 'package:ecom/features/cart/widgets/cart_item_card.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: Center(child: SizedBox(width: 400, child: child)),
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

  testWidgets('renders cart item details and formatted price', (tester) async {
    const item = CartItem(product: testProduct, quantity: 2);

    await tester.pumpWidget(_wrap(const CartItemCard(item: item)));

    expect(find.text('Organic Cotton Crew'), findsOneWidget);
    expect(find.text(ProductCategories.tShirts.toUpperCase()), findsOneWidget);
    expect(find.text((999.00 * 2).toInr()), findsOneWidget);
    expect(find.text('${999.00.toInr()} each'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('triggers onIncrement callback when plus button is tapped', (
    tester,
  ) async {
    var incremented = false;
    const item = CartItem(product: testProduct, quantity: 1);

    await tester.pumpWidget(
      _wrap(CartItemCard(item: item, onIncrement: () => incremented = true)),
    );

    await tester.tap(find.byKey(const ValueKey('cart_increment_test_tee')));
    expect(incremented, isTrue);
  });

  testWidgets('triggers onDecrement callback when minus button is tapped', (
    tester,
  ) async {
    var decremented = false;
    const item = CartItem(product: testProduct, quantity: 2);

    await tester.pumpWidget(
      _wrap(CartItemCard(item: item, onDecrement: () => decremented = true)),
    );

    await tester.tap(find.byKey(const ValueKey('cart_decrement_test_tee')));
    expect(decremented, isTrue);
  });

  testWidgets('triggers onRemove callback when close button is tapped', (
    tester,
  ) async {
    var removed = false;
    const item = CartItem(product: testProduct, quantity: 1);

    await tester.pumpWidget(
      _wrap(CartItemCard(item: item, onRemove: () => removed = true)),
    );

    await tester.tap(find.byKey(const ValueKey('remove_item_test_tee')));
    expect(removed, isTrue);
  });
}
