import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Skeleton placeholder mirroring the geometry of [CartItemCard].
class CartItemSkeleton extends StatelessWidget {
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

/// Full screen skeleton placeholder mirroring [CartScreen].
class CartScreenSkeleton extends StatelessWidget {
  const CartScreenSkeleton({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppShimmer(
      child: Column(
        children: [
          // Shipping banner skeleton
          Container(
            width: double.infinity,
            color: colorScheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                const AppShimmerBox(
                  width: AppSizes.iconSm,
                  height: AppSizes.iconSm,
                  shape: BoxShape.circle,
                ),
                AppSpacing.sm.horizontalGap,
                const Expanded(
                  child: AppShimmerBox(
                    height: 12,
                    borderRadius: AppRadii.borderXs,
                  ),
                ),
              ],
            ),
          ),
          // Selection header skeleton
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmerBox(
                  width: 100,
                  height: 12,
                  borderRadius: AppRadii.borderXs,
                ),
                AppShimmerBox(
                  width: 70,
                  height: 12,
                  borderRadius: AppRadii.borderXs,
                ),
              ],
            ),
          ),
          // Scrollable item skeletons
          Expanded(
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: itemCount,
              separatorBuilder: (context, index) => AppSpacing.md.verticalGap,
              itemBuilder: (context, index) => const CartItemSkeleton(),
            ),
          ),
          // Pinned bottom order summary card skeleton
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline,
                  width: AppSizes.borderWidthThin,
                ),
              ),
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppShimmerBox(
                        width: 60,
                        height: 14,
                        borderRadius: AppRadii.borderXs,
                      ),
                      AppShimmerBox(
                        width: 70,
                        height: 14,
                        borderRadius: AppRadii.borderXs,
                      ),
                    ],
                  ),
                  AppSpacing.xs.verticalGap,
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppShimmerBox(
                        width: 60,
                        height: 14,
                        borderRadius: AppRadii.borderXs,
                      ),
                      AppShimmerBox(
                        width: 40,
                        height: 14,
                        borderRadius: AppRadii.borderXs,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Divider(
                      height: AppSizes.borderWidthThin,
                      thickness: AppSizes.borderWidthThin,
                      color: colorScheme.outline,
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppShimmerBox(
                        width: 100,
                        height: 16,
                        borderRadius: AppRadii.borderXs,
                      ),
                      AppShimmerBox(
                        width: 90,
                        height: 20,
                        borderRadius: AppRadii.borderXs,
                      ),
                    ],
                  ),
                  AppSpacing.md.verticalGap,
                  const AppShimmerBox(
                    width: double.infinity,
                    height: AppSizes.buttonHeightMd,
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
