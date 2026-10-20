import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/products/models/product.dart';
import 'package:ecom/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

/// Top pinned search field and horizontal category choice chips bar.
class ProductSearchFilterBar extends StatelessWidget {
  /// Creates a [ProductSearchFilterBar] with search and filtering callbacks.
  const ProductSearchFilterBar({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  /// The text controller controlling the search input.
  final TextEditingController searchController;

  /// The current active search query text.
  final String searchQuery;

  /// Callback when search input text changes.
  final ValueChanged<String> onSearchChanged;

  /// Callback when user clears the search input.
  final VoidCallback onClearSearch;

  /// Currently selected category chip identifier.
  final String selectedCategory;

  /// Callback when user taps a different category chip.
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
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
          AppTextField(
            key: const ValueKey('search_field'),
            controller: searchController,
            hintText: 'Search products by name...',
            prefixIcon: const Icon(
              Icons.search,
              size: AppSizes.iconMd,
            ),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
                    key: const ValueKey('clear_search_button'),
                    icon: const Icon(
                      Icons.clear,
                      size: AppSizes.iconSm,
                    ),
                    onPressed: onClearSearch,
                  )
                : null,
            onChanged: onSearchChanged,
          ),
          AppSpacing.sm.verticalGap,
          SizedBox(
            height: AppSizes.categoryFilterHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: ProductCategories.categories.length,
              separatorBuilder: (context, index) => AppSpacing.sm.horizontalGap,
              itemBuilder: (context, index) {
                final category = ProductCategories.categories[index];
                final isSelected = selectedCategory == category;

                return ChoiceChip(
                  key: ValueKey('category_chip_$category'),
                  label: Text(category),
                  selected: isSelected,
                  showCheckmark: false,
                  selectedColor: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  labelStyle: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: AppSizes.borderWidthThin,
                  ),
                  shape: const StadiumBorder(),
                  onSelected: (_) => onCategorySelected(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
