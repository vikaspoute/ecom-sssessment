import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/features/auth/cubit/auth_cubit.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:ecom/features/auth/screens/login_screen.dart';
import 'package:ecom/features/cart/screens/cart_screen.dart';
import 'package:ecom/features/onboarding/screens/onboarding_screen.dart';
import 'package:ecom/features/products/data/product_repository.dart';
import 'package:ecom/features/products/screens/product_listing_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRouter {
  static GoRouter create({
    AuthRepository? authRepository,
    ProductRepository? productRepository,
    String initialLocation = AppRoutes.onboarding,
  }) {
    final repository = authRepository ?? const AuthRepository();
    final productRepo = productRepository ?? const LocalProductRepository();

    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) {
            return BlocProvider(
              create: (_) => AuthCubit(repository),
              child: const LoginScreen(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.products,
          builder: (context, state) =>
              ProductListingScreen(productRepository: productRepo),
        ),
        GoRoute(
          path: AppRoutes.cart,
          builder: (context, state) => const CartScreen(),
        ),
      ],
    );
  }
}
