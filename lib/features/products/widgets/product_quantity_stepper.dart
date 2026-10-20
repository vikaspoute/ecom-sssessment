import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Interactive circular stepper control embedded within fashion product cards.
///
/// Features tactile circular buttons for decrement/increment, an active item count,
/// and instant bidirectional synchronization with the shared cart state.
class ProductQuantityStepper extends StatelessWidget {
  /// Creates a [ProductQuantityStepper] for a product card.
  const ProductQuantityStepper({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  /// The unique product identifier used for semantic test keys.
  final String productId;

  /// The human-readable product name for accessibility labels.
  final String productName;

  /// The current quantity of this product in the user's shopping bag.
  final int quantity;

  /// Callback invoked when the user taps the add (+) circular button.
  final VoidCallback? onIncrement;

  /// Callback invoked when the user taps the minus (-) or remove circular button.
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      height: AppSizes.buttonHeightSm,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: AppRadii.borderPill,
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.18),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.white.withValues(alpha: 0.16),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('decrement_$productId'),
              onTap: onDecrement,
              child: SizedBox(
                width: 34,
                height: 34,
                child: Icon(
                  quantity == 1
                      ? Icons.delete_outline_rounded
                      : Icons.remove_rounded,
                  size: AppSizes.iconSm,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$quantity',
                  key: ValueKey('quantity_$productId'),
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onPrimary,
                  ),
                ),
                AppSpacing.xs.horizontalGap,
                Text(
                  'in bag',
                  style: AppTypography.labelSmall.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white.withValues(alpha: 0.24),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: ValueKey('increment_$productId'),
              onTap: onIncrement,
              child: SizedBox(
                width: 34,
                height: 34,
                child: Icon(
                  Icons.add_rounded,
                  size: AppSizes.iconSm,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
