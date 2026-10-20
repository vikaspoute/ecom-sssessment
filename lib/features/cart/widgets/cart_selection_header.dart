import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Section header displaying the bag title and total item count badge.
class CartSelectionHeader extends StatelessWidget {
  /// Creates a [CartSelectionHeader].
  const CartSelectionHeader({super.key, required this.totalItemCount});

  /// The total count of items in the shopping bag.
  final int totalItemCount;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'YOUR SELECTION',
            style: AppTypography.caption.copyWith(
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
              color: colorScheme.secondary,
            ),
          ),
          Text(
            'Total items: $totalItemCount',
            style: AppTypography.labelMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
