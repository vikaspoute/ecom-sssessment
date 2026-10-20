import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/shared/widgets/app_button_content.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, outlined, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.leading,
    this.trailing,
    this.isLoading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool isLoading;
  final bool expand;

  bool get _enabled => onPressed != null && !isLoading;

  double get _height => switch (size) {
    AppButtonSize.small => AppSizes.buttonHeightSm,
    AppButtonSize.medium => AppSizes.buttonHeightMd,
    AppButtonSize.large => AppSizes.buttonHeightLg,
  };

  double get _horizontalPadding => switch (size) {
    AppButtonSize.small => AppSpacing.md,
    AppButtonSize.medium => AppSpacing.lg,
    AppButtonSize.large => AppSpacing.xl,
  };

  double get _iconSize => switch (size) {
    AppButtonSize.small => AppSizes.iconSm,
    AppButtonSize.medium => AppSizes.iconMd,
    AppButtonSize.large => AppSizes.iconLg,
  };

  double get _verticalPadding => switch (size) {
    AppButtonSize.small => AppSpacing.xs,
    AppButtonSize.medium => AppSpacing.sm,
    AppButtonSize.large => AppSpacing.md,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final theme = context.theme;

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(expand ? double.infinity : AppSizes.minTouchTarget, _height),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
      ),
      shape: const WidgetStatePropertyAll(StadiumBorder()),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(
        AppTypography.button.copyWith(
          letterSpacing: 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    final child = AppButtonContent(
      label: label,
      leading: leading,
      trailing: trailing,
      isLoading: isLoading,
      iconSize: _iconSize,
      expand: expand,
    );

    final handlePress = _enabled ? onPressed : null;

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: handlePress,
        style: style,
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: handlePress,
        style: style.merge(
          FilledButton.styleFrom(
            backgroundColor: colorScheme.surfaceContainerHighest,
            foregroundColor: colorScheme.primary,
            disabledBackgroundColor: theme.disabledColor,
            disabledForegroundColor: colorScheme.onPrimary,
          ),
        ),
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(
        onPressed: handlePress,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: handlePress,
        style: style,
        child: child,
      ),
    };

    if (!expand) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
