import 'package:ecom/app.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:ecom/features/cart/screens/cart_screen.dart';
import 'package:ecom/features/products/data/product_repository.dart';
import 'package:ecom/features/products/screens/product_listing_screen.dart';
import 'package:ecom/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'End-to-End User Flow: Login -> Products -> Add to Cart -> Open Cart -> Change Quantity -> Remove Product',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // 1. Launch App
      await tester.pumpWidget(
        const EcomApp(
          initialLocation: AppRoutes.login,
          authRepository: AuthRepository(delay: Duration.zero),
          productRepository: LocalProductRepository(delay: Duration.zero),
        ),
      );
      await tester.pumpAndSettle();

      // Verify on Login Screen
      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);

      // 2. Perform Login with demo credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;
      final loginButton = find.widgetWithText(FilledButton, 'Log in');

      await tester.enterText(emailField, AuthRepository.demoEmail);
      await tester.enterText(passwordField, AuthRepository.demoPassword);
      await tester.pump();

      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // 3. Verify Product Listing Screen is loaded
      expect(find.byType(ProductListingScreen), findsOneWidget);
      expect(find.text('Curated Collection'), findsOneWidget);

      // 4. Add first product to cart
      final addBtnFinder = find.byKey(
        const ValueKey('add_to_cart_prod_classic_cotton_tee'),
      );
      await tester.ensureVisible(addBtnFinder);
      await tester.tap(addBtnFinder);
      await tester.pump();

      // Verify in-card stepper appears with quantity 1
      final qtyFinder = find.byKey(
        const ValueKey('quantity_prod_classic_cotton_tee'),
      );
      expect(qtyFinder, findsOneWidget);
      expect(tester.widget<Text>(qtyFinder).data, equals('1'));

      // 5. Increment quantity on product card
      final incBtnFinder = find.byKey(
        const ValueKey('increment_prod_classic_cotton_tee'),
      );
      await tester.tap(incBtnFinder);
      await tester.pump();

      expect(tester.widget<Text>(qtyFinder).data, equals('2'));

      // 6. Navigate to Cart Screen via AppBar icon
      final cartIconFinder = find.byKey(const ValueKey('cart_icon_button'));
      await tester.ensureVisible(cartIconFinder);
      await tester.tap(cartIconFinder);
      await tester.pumpAndSettle();

      // Verify Cart Screen is loaded with items
      expect(find.byType(CartScreen), findsOneWidget);
      expect(find.text('Classic Cotton T-Shirt'), findsOneWidget);
      expect(find.text('Total items: 2'), findsOneWidget);
      expect(find.byKey(const ValueKey('checkout_button')), findsOneWidget);

      // 7. Change quantity on Cart Screen (decrement from 2 to 1)
      final cartDecFinder = find.byKey(
        const ValueKey('cart_decrement_prod_classic_cotton_tee'),
      );
      await tester.tap(cartDecFinder);
      await tester.pump();

      expect(find.text('Total items: 1'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('cart_qty_prod_classic_cotton_tee')),
        findsOneWidget,
      );

      // 8. Remove product from Cart Screen
      final removeBtnFinder = find.byKey(
        const ValueKey('remove_item_prod_classic_cotton_tee'),
      );
      await tester.tap(removeBtnFinder);
      await tester.pump();

      // 9. Verify Empty Cart State is displayed
      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('Your shopping bag is empty'), findsOneWidget);

      // 10. Tap Explore Curated Catalog to navigate back to products
      await tester.tap(find.text('Explore Curated Catalog'));
      await tester.pumpAndSettle();

      expect(find.byType(ProductListingScreen), findsOneWidget);
    },
  );
}
