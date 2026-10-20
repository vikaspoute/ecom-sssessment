import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/cubit/cart_state.dart';
import 'package:ecom/features/cart/widgets/cart_item_card.dart';
import 'package:ecom/features/cart/widgets/cart_order_summary_bar.dart';
import 'package:ecom/features/cart/widgets/cart_screen_skeleton.dart';
import 'package:ecom/features/cart/widgets/cart_selection_header.dart';
import 'package:ecom/features/cart/widgets/cart_shipping_banner.dart';
import 'package:ecom/features/cart/widgets/checkout_confirmation_sheet.dart';
import 'package:ecom/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Full-featured shopping bag screen displaying selected fashion items,
/// interactive quantity editing, swipe-to-delete, order summary, and checkout flow.
class CartScreen extends StatelessWidget {
  /// Creates a [CartScreen].
  const CartScreen({super.key, this.isLoading = false});

  /// Forces skeleton loading view for widget testing.
  final bool isLoading;

  void _onClearCart(BuildContext context) {
    final colorScheme = context.colorScheme;
    showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Shopping Bag?'),
          content: const Text(
            'Are you sure you want to remove all items from your bag? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: colorScheme.error),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<CartCubit>().clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shopping bag cleared'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  void _onCheckout(BuildContext context, CartState state) {
    final colorScheme = context.colorScheme;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xl)),
      ),
      builder: (bottomSheetContext) {
        return CheckoutConfirmationSheet(cartState: state);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final itemCount = state.totalItemCount;

        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shopping Bag'),
                if (state.isNotEmpty)
                  Text(
                    '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                    style: AppTypography.caption.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            actions: [
              if (state.isNotEmpty)
                IconButton(
                  key: const ValueKey('clear_cart_button'),
                  tooltip: 'Clear shopping bag',
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _onClearCart(context),
                ),
              AppSpacing.xs.horizontalGap,
            ],
          ),
          body: (isLoading || state.isLoading)
              ? const CartScreenSkeleton()
              : state.isEmpty
              ? _buildEmptyState(context)
              : _buildCartContent(context, state),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'Your shopping bag is empty',
      description: 'Discover timeless essentials crafted with premium natural fabrics and add pieces to your bag.',
      actionLabel: 'Explore Curated Catalog',
      onAction: () {
        if (Navigator.of(context).canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.products);
        }
      },
    );
  }

  Widget _buildCartContent(BuildContext context, CartState state) {
    final cubit = context.read<CartCubit>();

    return Column(
      children: [
        const CartShippingBanner(),
        CartSelectionHeader(totalItemCount: state.totalItemCount),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: state.items.length,
            separatorBuilder: (context, index) => AppSpacing.md.verticalGap,
            itemBuilder: (context, index) {
              final item = state.items[index];

              return CartItemCard(
                key: ValueKey('cart_item_${item.product.id}'),
                item: item,
                onIncrement: () => cubit.addProduct(item.product),
                onDecrement: () => cubit.decrementProduct(item.product.id),
                onRemove: () => cubit.removeProduct(item.product.id),
              );
            },
          ),
        ),
        CartOrderSummaryBar(
          cartState: state,
          onCheckout: () => _onCheckout(context, state),
        ),
      ],
    );
  }
}
