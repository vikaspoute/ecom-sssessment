import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.error_outline,
    this.retryLabel = 'Try again',
    this.onRetry,
  });

  final String title;
  final String message;
  final IconData? icon;
  final String retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppSizes.iconXl, color: colorScheme.error),
                AppSpacing.sectionGap.verticalGap,
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium,
              ),
              AppSpacing.itemGap.verticalGap,
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onRetry != null) ...[
                AppSpacing.sectionGap.verticalGap,
                AppButton(label: retryLabel, onPressed: onRetry, expand: true),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
