import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/features/products/widgets/product_quantity_stepper.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:ecom/shared/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

/// Reusable fashion product card displaying imagery, metadata, price, and
/// dynamic Add to Cart / quantity stepper (+ / -).
class ProductCard extends StatelessWidget {
  /// Creates a [ProductCard] representing an item in the fashion catalog.
  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCart,
    this.onIncrement,
    this.onDecrement,
    this.cartQuantity = 0,
    this.isLoading = false,
  });

  /// The product data entity.
  final Product product;

  /// Callback when user taps initial 'Add to Cart' button.
  final VoidCallback? onAddToCart;

  /// Callback when user increments quantity in stepper.
  final VoidCallback? onIncrement;

  /// Callback when user decrements quantity in stepper.
  final VoidCallback? onDecrement;

  /// Current quantity of this item present in the user's shopping bag.
  final int cartQuantity;

  /// Whether the card or action is in a pending loading state.
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
                          : ProductQuantityStepper(
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
