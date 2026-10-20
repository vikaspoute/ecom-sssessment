import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:ecom/shared/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable fashion product card displaying imagery, metadata, price, and
/// dynamic Add to Cart / quantity stepper (+ / -).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onIncrement,
    this.onDecrement,
    this.cartQuantity = 0,
    this.isLoading = false,
  });

  final Product product;
  final VoidCallback? onAddToCart;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int cartQuantity;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final originalPrice = product.originalPrice;

    return Semantics(
      container: true,
      label: '${product.name}, ${product.price.toInr()}',
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppRadii.borderLg,
          border: Border.all(
            color: colorScheme.outline,
            width: AppSizes.borderWidthThin,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: AppNetworkImage(
                    imageUrl: product.imageUrl,
                    semanticLabel: product.name,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                if (product.hasDiscount)
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: AppRadii.borderXs,
                      ),
                      child: Text(
                        '${product.discountPercentage}% OFF',
                        style: AppTypography.labelSmall.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTypography.productTitle.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.xs.verticalGap,
                    Text(
                      product.description,
                      style: AppTypography.productDescription.copyWith(
                        height: 1.25,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          product.price.toInr(),
                          style: AppTypography.productPrice,
                        ),
                        if (originalPrice != null) ...[
                          AppSpacing.xs.horizontalGap,
                          Flexible(
                            child: Text(
                              originalPrice.toInr(),
                              style: AppTypography.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.xs.verticalGap,
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: cartQuantity == 0
                          ? AppButton(
                              key: ValueKey('add_to_cart_${product.id}'),
                              label: 'Add to Cart',
                              size: AppButtonSize.small,
                              variant: AppButtonVariant.primary,
                              expand: true,
                              isLoading: isLoading,
                              leading: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: AppSizes.iconSm,
                                color: colorScheme.onPrimary,
                              ),
                              onPressed: onAddToCart,
                            )
                          : _QuantityStepper(
                              key: ValueKey('stepper_${product.id}'),
                              productId: product.id,
                              productName: product.name,
                              quantity: cartQuantity,
                              onIncrement: onIncrement ?? onAddToCart,
                              onDecrement: onDecrement,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    super.key,
    required this.productId,
    required this.productName,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  final String productId;
  final String productName;
  final int quantity;
  final VoidCallback? onIncrement;
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
