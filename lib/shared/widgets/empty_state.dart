import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.illustration,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String description;
  final IconData? icon;
  final Widget? illustration;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    final visual =
        illustration ??
        (icon != null
            ? Icon(
                icon,
                size: AppSizes.iconXl,
                color: colorScheme.onSurfaceVariant,
              )
            : null);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : AppSizes.maxContentWidth;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth.clamp(0, AppSizes.maxContentWidth).toDouble(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (visual != null) ...[
                    visual,
                    AppSpacing.sectionGap.verticalGap,
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTypography.titleMedium,
                  ),
                  AppSpacing.itemGap.verticalGap,
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (actionLabel != null && onAction != null) ...[
                    AppSpacing.sectionGap.verticalGap,
                    AppButton(
                      label: actionLabel!,
                      onPressed: onAction,
                      expand: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
