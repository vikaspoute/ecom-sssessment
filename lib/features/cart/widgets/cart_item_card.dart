import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/cart/models/cart_item.dart';
import 'package:ecom/features/cart/widgets/cart_quantity_stepper.dart';
import 'package:ecom/shared/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

/// Interactive cart item row card displaying thumbnail imagery, product
/// details, unit/total pricing, and in-place quantity controls.
class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrement,
    this.onDecrement,
    this.onRemove,
  });

  final CartItem item;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final product = item.product;
    final originalPrice = product.originalPrice;

    return Dismissible(
      key: ValueKey('dismiss_${product.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: AppRadii.borderLg,
        ),
        child: Icon(
          Icons.delete_outline,
          color: colorScheme.onError,
          size: AppSizes.iconMd,
        ),
      ),
      onDismissed: (_) => onRemove?.call(),
      child: Semantics(
        container: true,
        label:
            '${product.name}, quantity ${item.quantity}, ${item.totalPrice.toInr()}',
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppRadii.borderLg,
            border: Border.all(
              color: colorScheme.outline,
              width: AppSizes.borderWidthThin,
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product thumbnail image
              ClipRRect(
                borderRadius: AppRadii.borderMd,
                child: SizedBox(
                  width: AppSizes.cartThumbnailSize,
                  height: AppSizes.cartThumbnailSize,
                  child: AppNetworkImage(
                    imageUrl: product.imageUrl,
                    semanticLabel: product.name,
                    fit: BoxFit.cover,
                    borderRadius: AppRadii.borderMd,
                  ),
                ),
              ),
              AppSpacing.md.horizontalGap,
              // Details and controls
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.category.toUpperCase(),
                                style: AppTypography.labelSmall.copyWith(
                                  letterSpacing: 1.2,
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              AppSpacing.xs.verticalGap,
                              Text(
                                product.name,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          key: ValueKey('remove_item_${product.id}'),
                          icon: Icon(
                            Icons.close,
                            size: AppSizes.iconSm,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: AppSizes.closeButtonSize,
                            minHeight: AppSizes.closeButtonSize,
                          ),
                          tooltip: 'Remove ${product.name}',
                          onPressed: onRemove,
                        ),
                      ],
                    ),
                    AppSpacing.xs.verticalGap,
                    // Price row and quantity stepper
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: AppSpacing.xs,
                                children: [
                                  Text(
                                    item.totalPrice.toInr(),
                                    style: AppTypography.productPrice,
                                  ),
                                  if (originalPrice != null)
                                    Text(
                                      (originalPrice * item.quantity).toInr(),
                                      style: AppTypography.caption.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                              if (item.quantity > 1)
                                Text(
                                  '${product.price.toInr()} each',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AppSpacing.sm.horizontalGap,
                        CartQuantityStepper(
                          productId: product.id,
                          productName: product.name,
                          quantity: item.quantity,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
