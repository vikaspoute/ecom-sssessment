import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/features/cart/widgets/cart_item_skeleton.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Full screen skeleton placeholder mirroring the geometry of [CartScreen].
class CartScreenSkeleton extends StatelessWidget {
  /// Creates a [CartScreenSkeleton].
  const CartScreenSkeleton({super.key, this.itemCount = 3});

  /// The count of mock cart items rendered in the skeleton.
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
