import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/features/products/widgets/product_grid_skeleton.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

export 'package:ecom/features/products/widgets/product_grid_skeleton.dart';

/// Skeleton placeholder mirroring the geometry of [ProductCard].
class ProductCardSkeleton extends StatelessWidget {
  /// Creates a [ProductCardSkeleton].
  const ProductCardSkeleton({super.key});

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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: 1.0,
            child: AppShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
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
                  const AppShimmerBox(
                    height: 14,
                    width: double.infinity,
                    borderRadius: AppRadii.borderXs,
                  ),
                  AppSpacing.xs.verticalGap,
                  const AppShimmerBox(
                    height: 12,
                    width: 110,
                    borderRadius: AppRadii.borderXs,
                  ),
                  const Spacer(),
                  const AppShimmerBox(
                    height: 16,
                    width: 70,
                    borderRadius: AppRadii.borderXs,
                  ),
                  AppSpacing.xs.verticalGap,
                  const AppShimmerBox(
                    height: AppSizes.buttonHeightSm,
                    width: double.infinity,
                    borderRadius: AppRadii.borderMd,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

