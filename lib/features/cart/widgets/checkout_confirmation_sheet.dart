import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/cart/cubit/cart_state.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Modal bottom sheet content summarizing readiness for the order checkout pipeline.
class CheckoutConfirmationSheet extends StatelessWidget {
  /// Creates a [CheckoutConfirmationSheet].
  const CheckoutConfirmationSheet({
    super.key,
    required this.cartState,
  });

  /// The active cart state holding subtotal and count details.
  final CartState cartState;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

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
                        '${cartState.totalItemCount} items • Total: ${cartState.subtotal.toInr()}',
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
                Navigator.of(context).pop();
                context.go(AppRoutes.products);
              },
            ),
          ],
        ),
      ),
    );
  }
}
