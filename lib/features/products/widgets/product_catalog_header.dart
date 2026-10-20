import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:flutter/material.dart';

/// Editorial season banner and collection header displaying category title and active item count.
class ProductCatalogHeader extends StatelessWidget {
  /// Creates a [ProductCatalogHeader].
  const ProductCatalogHeader({
    super.key,
    required this.selectedCategory,
    required this.searchQuery,
    required this.itemCount,
  });

  /// The active category filter name.
  final String selectedCategory;

  /// The active text search query, if any.
  final String searchQuery;

  /// Total count of matching products rendered in the grid.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPRING / SUMMER 2026',
            style: AppTypography.caption.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
              color: colorScheme.secondary,
            ),
          ),
          AppSpacing.xs.verticalGap,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                selectedCategory == ProductCategories.all
                    ? 'Curated Collection'
                    : selectedCategory,
                style: AppTypography.headlineMedium,
              ),
              Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: AppTypography.labelMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.xs.verticalGap,
          Text(
            searchQuery.isNotEmpty
                ? 'Matching "$searchQuery"'
                : 'Timeless essentials crafted with premium natural fabrics.',
            style: AppTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
