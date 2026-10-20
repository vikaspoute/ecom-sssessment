import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

export 'package:ecom/features/cart/widgets/cart_screen_skeleton.dart';

/// Skeleton placeholder mirroring the geometry of [CartItemCard].
class CartItemSkeleton extends StatelessWidget {
  /// Creates a [CartItemSkeleton].
  const CartItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
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
          const AppShimmerBox(
            width: AppSizes.cartThumbnailSize,
            height: AppSizes.cartThumbnailSize,
            borderRadius: AppRadii.borderMd,
          ),
          AppSpacing.md.horizontalGap,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmerBox(
                      width: 55,
                      height: 10,
                      borderRadius: AppRadii.borderXs,
                    ),
                    AppShimmerBox(
                      width: AppSizes.closeButtonSize,
                      height: AppSizes.closeButtonSize,
                      shape: BoxShape.circle,
                    ),
                  ],
                ),
                AppSpacing.xs.verticalGap,
                const AppShimmerBox(
                  width: 140,
                  height: 15,
                  borderRadius: AppRadii.borderXs,
                ),
                AppSpacing.md.verticalGap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppShimmerBox(
                      width: 65,
                      height: 16,
                      borderRadius: AppRadii.borderXs,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppShimmerBox(
                          width: AppSizes.stepperButtonSize,
                          height: AppSizes.stepperButtonSize,
                          shape: BoxShape.circle,
                        ),
                        AppSpacing.sm.horizontalGap,
                        const AppShimmerBox(
                          width: 18,
                          height: 14,
                          borderRadius: AppRadii.borderXs,
                        ),
                        AppSpacing.sm.horizontalGap,
                        const AppShimmerBox(
                          width: AppSizes.stepperButtonSize,
                          height: AppSizes.stepperButtonSize,
                          shape: BoxShape.circle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
