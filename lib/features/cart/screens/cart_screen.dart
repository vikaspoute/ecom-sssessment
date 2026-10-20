import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/cart/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/cubit/cart_state.dart';
import 'package:ecom/features/cart/widgets/cart_item_card.dart';
import 'package:ecom/features/cart/widgets/cart_item_skeleton.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:ecom/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Full-featured shopping bag screen displaying selected fashion items,
/// interactive quantity editing, swipe-to-delete, order summary, and checkout flow.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.isLoading = false});

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
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: AppSizes.indicatorBarWidth,
                    height: AppSizes.indicatorBarHeight,
                    decoration: BoxDecoration(
                      color: colorScheme.outline,
                      borderRadius: AppRadii.borderPill,
                    ),
                  ),
                ),
                AppSpacing.lg.verticalGap,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: colorScheme.secondary,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    AppSpacing.md.horizontalGap,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ready for Checkout',
                            style: AppTypography.titleLarge,
                          ),
                          Text(
                            '${state.totalItemCount} items • Total: ${state.subtotal.toInr()}',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.lg.verticalGap,
                Text(
                  'Payment and shipping integrations will be enabled in the upcoming checkout task. Thank you for testing ECOM!',
                  style: AppTypography.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                AppSpacing.xl.verticalGap,
                AppButton(
                  label: 'Back to Catalog',
                  expand: true,
                  onPressed: () {
                    Navigator.of(bottomSheetContext).pop();
                    if (context.mounted) {
                      context.go(AppRoutes.products);
                    }
                  },
                ),
              ],
            ),
          ),
        );
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
    final colorScheme = context.colorScheme;
    final cubit = context.read<CartCubit>();

    return Column(
      children: [
        // Complimentary shipping banner
        Container(
          width: double.infinity,
          color: colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_shipping_outlined,
                size: AppSizes.iconSm,
                color: colorScheme.secondary,
              ),
              AppSpacing.sm.horizontalGap,
              Expanded(
                child: Text(
                  'Complimentary express shipping applied to your bag',
                  style: AppTypography.caption.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Item count / header line
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'YOUR SELECTION',
                style: AppTypography.caption.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.secondary,
                ),
              ),
              // Kept for backward compatibility with existing tests
              Text(
                'Total items: ${state.totalItemCount}',
                style: AppTypography.labelMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Scrollable item list
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
        // Pinned Bottom Order Summary & Checkout Card
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.outline,
                width: AppSizes.borderWidthThin,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, -4),
                blurRadius: 16,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.lg,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      state.subtotal.toInr(),
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                AppSpacing.xs.verticalGap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shipping',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      'FREE',
                      style: AppTypography.labelMedium.copyWith(
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: Divider(
                    height: AppSizes.borderWidthThin,
                    thickness: AppSizes.borderWidthThin,
                    color: colorScheme.outline,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Total',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      state.subtotal.toInr(),
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                AppSpacing.md.verticalGap,
                AppButton(
                  key: const ValueKey('checkout_button'),
                  label: 'Proceed to Checkout (${state.totalItemCount})',
                  leading: const Icon(
                    Icons.lock_outline,
                    size: AppSizes.iconSm,
                  ),
                  expand: true,
                  onPressed: () => _onCheckout(context, state),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
