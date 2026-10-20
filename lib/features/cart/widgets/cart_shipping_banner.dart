import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Top banner informing the customer of complimentary express shipping applied to their bag.
class CartShippingBanner extends StatelessWidget {
  /// Creates a [CartShippingBanner].
  const CartShippingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Container(
      width: double.infinity,
      color: colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping_outlined,
            size: AppSizes.iconSm,
            color: colorScheme.secondary,
          ),
          AppSpacing.sm.horizontalGap,
          Expanded(
            child: Text(
              'Complimentary express shipping applied to your bag',
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
