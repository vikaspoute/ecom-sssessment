import 'package:ecom/core/constants/app_constants.dart';
import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/cubit/cart_state.dart';
import 'package:ecom/features/products/data/product_repository.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/features/products/widgets/product_card.dart';
import 'package:ecom/features/products/widgets/product_catalog_header.dart';
import 'package:ecom/features/products/widgets/product_grid_skeleton.dart';
import 'package:ecom/features/products/widgets/product_search_filter_bar.dart';
import 'package:ecom/shared/widgets/app_error_view.dart';
import 'package:ecom/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Screen displaying the curated fashion catalog with dynamic top search,
/// category filters, live cart integration, and in-card quantity management.
class ProductListingScreen extends StatefulWidget {
  /// Creates a [ProductListingScreen].
  const ProductListingScreen({
    super.key,
    this.productRepository,
    this.cartCubit,
  });

  /// Optional product repository for testing dependency injection.
  final ProductRepository? productRepository;

  /// Optional cart cubit for testing dependency injection.
  final CartCubit? cartCubit;

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = const [];
  bool _isLoading = true;
  String? _errorMessage;

  String _searchQuery = '';
  String _selectedCategory = ProductCategories.all;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalog() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository =
          widget.productRepository ?? const LocalProductRepository();
      final products = await repository.getProducts();

      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load products: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedCategory = ProductCategories.all;
    });
  }

  List<Product> get _filteredProducts {
    final query = _searchQuery.trim().toLowerCase();

    return _allProducts.where((product) {
      final matchesCategory =
          _selectedCategory == ProductCategories.all ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery =
          query.isEmpty || product.name.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _onAddToCart(BuildContext context, Product product) {
    context.read<CartCubit>().addProduct(product);
  }

  void _onIncrement(BuildContext context, Product product) {
    context.read<CartCubit>().addProduct(product);
  }

  void _onDecrement(BuildContext context, Product product) {
    context.read<CartCubit>().decrementProduct(product.id);
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = _buildScaffold(context);

    if (widget.cartCubit != null) {
      return BlocProvider<CartCubit>.value(
        value: widget.cartCubit!,
        child: scaffold,
      );
    }

    return scaffold;
  }

  Widget _buildScaffold(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppConstants.appName.toUpperCase(),
              style: AppTypography.titleLarge.copyWith(
                letterSpacing: 2.5,
                fontWeight: FontWeight.w800,
              ),
            ),
            AppSpacing.xs.horizontalGap,
            Container(
              width: AppSizes.badgeDotSize,
              height: AppSizes.badgeDotSize,
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              final count = cartState.totalItemCount;

              return IconButton(
                key: const ValueKey('cart_icon_button'),
                tooltip: 'Shopping Cart ($count)',
                onPressed: () => context.push(AppRoutes.cart),
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text(
                    '$count',
                    style: AppTypography.labelSmall.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  backgroundColor: colorScheme.primary,
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: AppSizes.iconLg,
                  ),
                ),
              );
            },
          ),
          AppSpacing.sm.horizontalGap,
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const ProductGridSkeleton();
    }

    if (_errorMessage != null) {
      return AppErrorView(
        title: 'Unable to load catalog',
        message: _errorMessage!,
        onRetry: _loadCatalog,
      );
    }

    final filtered = _filteredProducts;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        // Adaptive column count:
        // Narrow phones (< 360) get 1 column for readability.
        // Standard phones get 2 columns. Tablets get 3. Desktops get 4.
        final int crossAxisCount;
        if (availableWidth < 360) {
          crossAxisCount = 1;
        } else if (availableWidth < 720) {
          crossAxisCount = 2;
        } else if (availableWidth < 1080) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 4;
        }

        const horizontalPadding = AppSpacing.screenPadding * 2;
        final totalGaps = (crossAxisCount - 1) * AppSpacing.itemGap;
        final columnWidth =
            (availableWidth - horizontalPadding - totalGaps) / crossAxisCount;

        // Modern square image ratio (1.0) with calibrated content height
        const imageAspectRatio = 1.0;
        const contentHeight = AppSizes.cardContentHeight;
        final cardHeight = (columnWidth / imageAspectRatio) + contentHeight;
        final childAspectRatio = (columnWidth / cardHeight).clamp(0.40, 0.85);

        return BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            final colorScheme = context.colorScheme;

            return Column(
              children: [
                ProductSearchFilterBar(
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  onSearchChanged: _onSearchChanged,
                  onClearSearch: _clearSearch,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _onCategorySelected,
                ),
                Divider(
                  height: AppSizes.borderWidthThin,
                  thickness: AppSizes.borderWidthThin,
                  color: colorScheme.outline,
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ProductCatalogHeader(
                          selectedCategory: _selectedCategory,
                          searchQuery: _searchQuery,
                          itemCount: filtered.length,
                        ),
                      ),
                      if (filtered.isEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xxl,
                            ),
                            child: EmptyState(
                              icon: Icons.search_off_outlined,
                              title: 'No products found',
                              description: _searchQuery.isNotEmpty
                                  ? 'No products matched "$_searchQuery". Try adjusting your search query or selecting another category.'
                                  : 'No products found in "$_selectedCategory".',
                              actionLabel: 'Reset filters',
                              onAction: _resetFilters,
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            AppSpacing.sm,
                            AppSpacing.screenPadding,
                            AppSpacing.screenPadding,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: AppSpacing.itemGap,
                                  mainAxisSpacing: AppSpacing.itemGap,
                                  childAspectRatio: childAspectRatio,
                                ),
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final product = filtered[index];
                              final inCart = cartState.quantityForProduct(
                                product.id,
                              );

                              return ProductCard(
                                key: ValueKey('product_card_${product.id}'),
                                product: product,
                                cartQuantity: inCart,
                                onAddToCart: () =>
                                    _onAddToCart(context, product),
                                onIncrement: () =>
                                    _onIncrement(context, product),
                                onDecrement: () =>
                                    _onDecrement(context, product),
                              );
                            }, childCount: filtered.length),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
