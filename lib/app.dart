import 'package:ecom/core/constants/app_constants.dart';
import 'package:ecom/core/router/app_router.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/products/data/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EcomApp extends StatefulWidget {
  const EcomApp({
    super.key,
    this.authRepository,
    this.productRepository,
    this.cartCubit,
    this.initialLocation,
  });

  final AuthRepository? authRepository;
  final ProductRepository? productRepository;
  final CartCubit? cartCubit;
  final String? initialLocation;

  @override
  State<EcomApp> createState() => _EcomAppState();
}

class _EcomAppState extends State<EcomApp> {
  late final CartCubit _cartCubit;
  late final bool _ownsCartCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    if (widget.cartCubit != null) {
      _cartCubit = widget.cartCubit!;
      _ownsCartCubit = false;
    } else {
      _cartCubit = CartCubit();
      _ownsCartCubit = true;
    }

    _router = AppRouter.create(
      authRepository: widget.authRepository ?? const AuthRepository(),
      productRepository:
          widget.productRepository ?? const LocalProductRepository(),
      initialLocation: widget.initialLocation ?? AppRoutes.onboarding,
    );
  }

  @override
  void dispose() {
    if (_ownsCartCubit) {
      _cartCubit.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>.value(
      value: _cartCubit,
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        locale: AppConstants.defaultLocale,
        routerConfig: _router,
      ),
    );
  }
}
