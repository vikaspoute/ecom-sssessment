import 'package:ecom/core/constants/app_constants.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/screens/cart_screen.dart';
import 'package:ecom/features/products/data/product_repository.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/features/products/screens/product_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const List<Product> _mockCatalog = [
  Product(
    id: 'mock_tee_classic',
    name: 'Classic Cotton T-Shirt',
    description: 'Everyday crew neck tee.',
    price: 899.00,
    imageUrl: 'https://example.com/tee1.jpg',
    category: ProductCategories.tShirts,
  ),
  Product(
    id: 'mock_tee_oversized',
    name: 'Oversized Heavyweight T-Shirt',
    description: 'Streetwear heavyweight tee.',
    price: 1299.00,
    imageUrl: 'https://example.com/tee2.jpg',
    category: ProductCategories.tShirts,
  ),
  Product(
    id: 'mock_shirt_linen',
    name: 'Casual Linen Shirt',
    description: 'Breezy linen button-down.',
    price: 2499.00,
    imageUrl: 'https://example.com/shirt.jpg',
    category: ProductCategories.shirts,
  ),
  Product(
    id: 'mock_bottoms_jeans',
    name: 'Selvedge Denim Jeans',
    description: 'Straight raw denim.',
    price: 3999.00,
    imageUrl: 'https://example.com/jeans.jpg',
    category: ProductCategories.bottoms,
  ),
  Product(
    id: 'mock_shoes_sneakers',
    name: 'Low-Top Leather Sneakers',
    description: 'Nappa leather court sneakers.',
    price: 3499.00,
    imageUrl: 'https://example.com/sneakers.jpg',
    category: ProductCategories.shoes,
  ),
];

class _MockProductRepo implements ProductRepository {
  const _MockProductRepo() : products = _mockCatalog;
  final List<Product> products;

  @override
  Future<List<Product>> getProducts() async => products;
}

Future<void> _pumpListingScreen(
  WidgetTester tester, {
  CartCubit? cartCubit,
  ProductRepository? productRepository,
}) async {
  tester.view.physicalSize = const Size(1080, 1920);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  final effectiveCubit = cartCubit ?? CartCubit();
  final effectiveRepo = productRepository ?? const _MockProductRepo();

  final router = GoRouter(
    initialLocation: AppRoutes.products,
    routes: [
      GoRoute(
        path: AppRoutes.products,
        builder: (context, state) =>
            ProductListingScreen(productRepository: effectiveRepo),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),
    ],
  );

  await tester.pumpWidget(
    BlocProvider<CartCubit>.value(
      value: effectiveCubit,
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('product listing renders without errors', (tester) async {
    await _pumpListingScreen(tester);

    // App branding and heading
    expect(find.text(AppConstants.appName.toUpperCase()), findsOneWidget);
    expect(find.text('Curated Collection'), findsOneWidget);
    expect(find.byKey(const ValueKey('search_field')), findsOneWidget);

    // Initial products displayed
    expect(find.text('Classic Cotton T-Shirt'), findsOneWidget);
    expect(find.text('Oversized Heavyweight T-Shirt'), findsOneWidget);
    expect(find.text('Casual Linen Shirt'), findsOneWidget);
  });

  testWidgets('search filters product names case-insensitively', (
    tester,
  ) async {
    await _pumpListingScreen(tester);

    // Search for "linen" in lowercase
    await tester.enterText(find.byKey(const ValueKey('search_field')), 'linen');
    await tester.pumpAndSettle();

    expect(find.text('Casual Linen Shirt'), findsOneWidget);
    expect(find.text('Classic Cotton T-Shirt'), findsNothing);
    expect(find.text('Selvedge Denim Jeans'), findsNothing);

    // Search for "LINEN" in uppercase
    await tester.enterText(find.byKey(const ValueKey('search_field')), 'LINEN');
    await tester.pumpAndSettle();

    expect(find.text('Casual Linen Shirt'), findsOneWidget);
    expect(find.text('Classic Cotton T-Shirt'), findsNothing);
  });

  testWidgets('displays empty state when search finds no matches', (
    tester,
  ) async {
    await _pumpListingScreen(tester);

    await tester.enterText(
      find.byKey(const ValueKey('search_field')),
      'unmatched query string xyz',
    );
    await tester.pumpAndSettle();

    expect(find.text('No products found'), findsOneWidget);
    expect(find.text('Reset filters'), findsOneWidget);

    // Tapping reset filters restores catalog
    await tester.tap(find.text('Reset filters'));
    await tester.pumpAndSettle();

    expect(find.text('Classic Cotton T-Shirt'), findsOneWidget);
  });

  testWidgets('category chip filters products by category and All resets', (
    tester,
  ) async {
    await _pumpListingScreen(tester);

    // Filter by T-shirts
    await tester.tap(find.byKey(const ValueKey('category_chip_T-shirts')));
    await tester.pumpAndSettle();

    expect(find.text('Classic Cotton T-Shirt'), findsOneWidget);
    expect(find.text('Oversized Heavyweight T-Shirt'), findsOneWidget);
    expect(find.text('Casual Linen Shirt'), findsNothing);
    expect(find.text('Selvedge Denim Jeans'), findsNothing);

    // Reset via All chip
    await tester.tap(find.byKey(const ValueKey('category_chip_All')));
    await tester.pumpAndSettle();

    expect(find.text('Classic Cotton T-Shirt'), findsOneWidget);
    expect(find.text('Casual Linen Shirt'), findsOneWidget);
    expect(find.text('Selvedge Denim Jeans'), findsOneWidget);
  });

  testWidgets('search and category filtering work together', (tester) async {
    await _pumpListingScreen(tester);

    // Filter by T-shirts
    await tester.tap(find.byKey(const ValueKey('category_chip_T-shirts')));
    await tester.pumpAndSettle();

    // Search for "oversized" within T-shirts
    await tester.enterText(
      find.byKey(const ValueKey('search_field')),
      'oversized',
    );
    await tester.pumpAndSettle();

    expect(find.text('Oversized Heavyweight T-Shirt'), findsOneWidget);
    expect(find.text('Classic Cotton T-Shirt'), findsNothing);

    // Search for "linen" while T-shirts category is active (should find none)
    await tester.enterText(find.byKey(const ValueKey('search_field')), 'linen');
    await tester.pumpAndSettle();

    expect(find.text('No products found'), findsOneWidget);
  });

  testWidgets(
    'adding a product to the cart dynamically shows quantity stepper',
    (tester) async {
      final cartCubit = CartCubit();

      await _pumpListingScreen(tester, cartCubit: cartCubit);

      final buttonFinder = find.byKey(
        const ValueKey('add_to_cart_mock_tee_classic'),
      );
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pump();

      // Verify dynamic in-card quantity stepper appears
      expect(
        find.byKey(const ValueKey('quantity_mock_tee_classic')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('increment_mock_tee_classic')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('decrement_mock_tee_classic')),
        findsOneWidget,
      );

      // Verify CartCubit updated
      expect(cartCubit.state.totalItemCount, equals(1));
      expect(
        cartCubit.state.items.first.product.id,
        equals('mock_tee_classic'),
      );

      // Verify in-card stepper appears with quantity 1
      final qtyFinder1 = find.byKey(
        const ValueKey('quantity_mock_tee_classic'),
      );
      expect(qtyFinder1, findsOneWidget);
      expect(tester.widget<Text>(qtyFinder1).data, equals('1'));
    },
  );

  testWidgets(
    'dynamically increment and decrement quantity via in-card controls',
    (tester) async {
      final cartCubit = CartCubit();

      await _pumpListingScreen(tester, cartCubit: cartCubit);

      final buttonFinder = find.byKey(
        const ValueKey('add_to_cart_mock_tee_classic'),
      );
      await tester.ensureVisible(buttonFinder);

      // Tap Add to Cart first time
      await tester.tap(buttonFinder);
      await tester.pump();

      // Tap + increment button on the dynamic stepper
      final incrementFinder = find.byKey(
        const ValueKey('increment_mock_tee_classic'),
      );
      await tester.tap(incrementFinder);
      await tester.pump();

      expect(cartCubit.state.items.length, equals(1));
      expect(cartCubit.state.totalItemCount, equals(2));
      expect(cartCubit.state.items.first.quantity, equals(2));
      final qtyFinder2 = find.byKey(
        const ValueKey('quantity_mock_tee_classic'),
      );
      expect(qtyFinder2, findsOneWidget);
      expect(tester.widget<Text>(qtyFinder2).data, equals('2'));

      // Tap - decrement button on the dynamic stepper
      final decrementFinder = find.byKey(
        const ValueKey('decrement_mock_tee_classic'),
      );
      await tester.tap(decrementFinder);
      await tester.pump();

      expect(cartCubit.state.items.first.quantity, equals(1));
      expect(qtyFinder2, findsOneWidget);
      expect(tester.widget<Text>(qtyFinder2).data, equals('1'));

      // Tap - again to remove from cart
      await tester.tap(decrementFinder);
      await tester.pump();

      expect(cartCubit.state.items, isEmpty);
      expect(
        find.byKey(const ValueKey('add_to_cart_mock_tee_classic')),
        findsOneWidget,
      );
    },
  );

  testWidgets('cart badge in app bar reflects total quantity', (tester) async {
    final cartCubit = CartCubit();

    await _pumpListingScreen(tester, cartCubit: cartCubit);

    final firstButton = find.byKey(
      const ValueKey('add_to_cart_mock_tee_classic'),
    );
    await tester.ensureVisible(firstButton);
    await tester.tap(firstButton);
    await tester.pump();

    final secondButton = find.byKey(
      const ValueKey('add_to_cart_mock_tee_oversized'),
    );
    await tester.ensureVisible(secondButton);
    await tester.tap(secondButton);
    await tester.pump();

    // Badge label should show total quantity 2
    expect(find.text('2'), findsWidgets);
    expect(cartCubit.state.totalItemCount, equals(2));
  });

  testWidgets('cart icon navigates to /cart and preserves cart items', (
    tester,
  ) async {
    final cartCubit = CartCubit();

    await _pumpListingScreen(tester, cartCubit: cartCubit);

    // Add an item
    final buttonFinder = find.byKey(
      const ValueKey('add_to_cart_mock_tee_classic'),
    );
    await tester.ensureVisible(buttonFinder);
    await tester.tap(buttonFinder);
    await tester.pump();

    // Tap cart icon in app bar
    final cartIconFinder = find.byKey(const ValueKey('cart_icon_button'));
    await tester.ensureVisible(cartIconFinder);
    await tester.tap(cartIconFinder);
    await tester.pumpAndSettle();

    // Cart screen placeholder should be displayed
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text('Total items: 1'), findsOneWidget);
  });
}
