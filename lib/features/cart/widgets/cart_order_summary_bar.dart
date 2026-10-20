import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/cart/cubit/cart_state.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

/// Pinned bottom summary panel showing calculated subtotal, shipping status, and checkout action.
class CartOrderSummaryBar extends StatelessWidget {
  /// Creates a [CartOrderSummaryBar].
  const CartOrderSummaryBar({
    super.key,
    required this.cartState,
    required this.onCheckout,
  });

  /// The active cart state holding subtotal and itemCount calculations.
  final CartState cartState;

  /// Callback when user taps the proceed to checkout button.
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
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
                  cartState.subtotal.toInr(),
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
                  cartState.subtotal.toInr(),
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
              label: 'Proceed to Checkout (${cartState.totalItemCount})',
              leading: const Icon(Icons.lock_outline, size: AppSizes.iconSm),
              expand: true,
              onPressed: onCheckout,
            ),
          ],
        ),
      ),
    );
  }
}
