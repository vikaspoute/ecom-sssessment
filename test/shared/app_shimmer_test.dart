import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/screens/cart_screen.dart';
import 'package:ecom/features/cart/widgets/cart_item_skeleton.dart';
import 'package:ecom/features/products/widgets/product_card_skeleton.dart';
import 'package:ecom/shared/widgets/app_network_image.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets(
    'AppShimmer and AppShimmerBox render without errors in test mode',
    (tester) async {
      await tester.pumpWidget(
        _wrap(const AppShimmer(child: AppShimmerBox(width: 100, height: 20))),
      );

      expect(find.byType(AppShimmer), findsOneWidget);
      expect(find.byType(AppShimmerBox), findsOneWidget);
    },
  );

  testWidgets('ProductCardSkeleton and ProductGridSkeleton render properly', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const ProductGridSkeleton(itemCount: 4)));

    expect(find.byType(ProductGridSkeleton), findsOneWidget);
    expect(find.byType(ProductCardSkeleton), findsWidgets);
  });

  testWidgets('CartScreen renders CartScreenSkeleton when isLoading is true', (
    tester,
  ) async {
    final cubit = CartCubit(isLoading: true);

    await tester.pumpWidget(
      BlocProvider<CartCubit>.value(
        value: cubit,
        child: MaterialApp(theme: AppTheme.light(), home: const CartScreen()),
      ),
    );

    expect(find.byType(CartScreenSkeleton), findsOneWidget);
    expect(find.byType(CartItemSkeleton), findsWidgets);
  });

  testWidgets(
    'AppNetworkImage renders AppShimmerBox placeholder when url is loading',
    (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppNetworkImage(
            imageUrl: 'https://example.com/item.jpg',
            width: 80,
            height: 80,
          ),
        ),
      );

      expect(find.byType(AppShimmerBox), findsOneWidget);
    },
  );
}
