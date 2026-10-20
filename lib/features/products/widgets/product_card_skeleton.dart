import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Skeleton placeholder mirroring the geometry of [ProductCard].
class ProductCardSkeleton extends StatelessWidget {
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

/// Full product listing screen skeleton including top search bar, category chips,
/// and responsive grid of [ProductCardSkeleton] items with zero layout shift.
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return AppShimmer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;

          final int crossAxisCount;
          if (availableWidth < 360) {
            crossAxisCount = 1;
          } else if (availableWidth < 720) {
            crossAxisCount = 2;
          } else if (availableWidth < 1080) {
            crossAxisCount = 3;
          } else {
            crossAxisCount = 4;
          }

          const horizontalPadding = AppSpacing.screenPadding * 2;
          final totalGaps = (crossAxisCount - 1) * AppSpacing.itemGap;
          final columnWidth =
              (availableWidth - horizontalPadding - totalGaps) / crossAxisCount;

          const imageAspectRatio = 1.0;
          const contentHeight = AppSizes.cardContentHeight;
          final cardHeight = (columnWidth / imageAspectRatio) + contentHeight;
          final childAspectRatio = (columnWidth / cardHeight).clamp(0.40, 0.85);

          return Column(
            children: [
              // Top search and category chips skeleton
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.xs,
                  AppSpacing.screenPadding,
                  AppSpacing.sm,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppShimmerBox(
                      height: AppSizes.inputHeight,
                      width: double.infinity,
                      borderRadius: AppRadii.borderMd,
                    ),
                    AppSpacing.sm.verticalGap,
                    SizedBox(
                      height: AppSizes.categoryFilterHeight,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 5,
                        separatorBuilder: (context, index) =>
                            AppSpacing.sm.horizontalGap,
                        itemBuilder: (context, index) {
                          final widths = [56.0, 72.0, 64.0, 78.0, 60.0];
                          return AppShimmerBox(
                            height: AppSizes.categoryFilterHeight,
                            width: widths[index % widths.length],
                            borderRadius: AppRadii.borderPill,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: AppSizes.borderWidthThin,
                thickness: AppSizes.borderWidthThin,
                color: colorScheme.outline,
              ),
              // Catalog header skeleton
              Expanded(
                child: CustomScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          AppSpacing.md,
                          AppSpacing.screenPadding,
                          AppSpacing.xs,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppShimmerBox(
                              width: 120,
                              height: 12,
                              borderRadius: AppRadii.borderXs,
                            ),
                            AppSpacing.xs.verticalGap,
                            const AppShimmerBox(
                              width: 180,
                              height: 24,
                              borderRadius: AppRadii.borderXs,
                            ),
                            AppSpacing.xs.verticalGap,
                            const AppShimmerBox(
                              width: 220,
                              height: 14,
                              borderRadius: AppRadii.borderXs,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        AppSpacing.sm,
                        AppSpacing.screenPadding,
                        AppSpacing.screenPadding,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: AppSpacing.itemGap,
                          mainAxisSpacing: AppSpacing.itemGap,
                          childAspectRatio: childAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => const ProductCardSkeleton(),
                          childCount: itemCount,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
