import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Circular quantity stepper control embedded within shopping bag item cards.
///
/// Features independent touch targets for increment, decrement, and item removal,
/// maintaining precise contrast and accessibility semantics.
class CartQuantityStepper extends StatelessWidget {
  /// Creates a [CartQuantityStepper].
  const CartQuantityStepper({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  /// The unique product ID for testing key bindings.
  final String productId;

  /// The product name used for tooltip and accessibility labels.
  final String productName;

  /// The current item quantity.
  final int quantity;

  /// Callback when user taps the increment (+) button.
  final VoidCallback? onIncrement;

  /// Callback when user taps the decrement (-) / delete button.
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppRadii.borderPill,
        border: Border.all(
          color: colorScheme.outline,
          width: AppSizes.borderWidthThin,
        ),
      ),
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            key: ValueKey('cart_decrement_$productId'),
            tooltip: 'Decrease quantity for $productName',
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surface,
              foregroundColor: colorScheme.primary,
              elevation: 0.5,
              shadowColor: Colors.black.withValues(alpha: 0.08),
              shape: const CircleBorder(),
              minimumSize: const Size(
                AppSizes.stepperButtonSize,
                AppSizes.stepperButtonSize,
              ),
              maximumSize: const Size(
                AppSizes.stepperButtonSize,
                AppSizes.stepperButtonSize,
              ),
              padding: EdgeInsets.zero,
            ),
            icon: Icon(
              quantity == 1
                  ? Icons.delete_outline_rounded
                  : Icons.remove_rounded,
              size: AppSizes.iconSm,
              color: quantity == 1 ? colorScheme.error : colorScheme.primary,
            ),
            onPressed: onDecrement,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Text(
              '$quantity',
              key: ValueKey('cart_qty_$productId'),
              style: AppTypography.labelLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          IconButton(
            key: ValueKey('cart_increment_$productId'),
            tooltip: 'Increase quantity for $productName',
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              elevation: 1,
              shadowColor: colorScheme.primary.withValues(alpha: 0.25),
              shape: const CircleBorder(),
              minimumSize: const Size(
                AppSizes.stepperButtonSize,
                AppSizes.stepperButtonSize,
              ),
              maximumSize: const Size(
                AppSizes.stepperButtonSize,
                AppSizes.stepperButtonSize,
              ),
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(
              Icons.add_rounded,
              size: AppSizes.iconSm,
            ),
            onPressed: onIncrement,
          ),
        ],
      ),
    );
  }
}
