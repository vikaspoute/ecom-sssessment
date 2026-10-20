import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/shared/widgets/app_loader.dart';
import 'package:flutter/material.dart';

/// Supporting widget that renders internal layout for [AppButton].
///
/// Handles loader state with accessibility semantics, leading/trailing icon sizing,
/// and responsive text truncation.
class AppButtonContent extends StatelessWidget {
  /// Creates an [AppButtonContent] widget.
  const AppButtonContent({
    super.key,
    required this.label,
    required this.leading,
    required this.trailing,
    required this.isLoading,
    required this.iconSize,
    required this.expand,
  });

  /// The button display text.
  final String label;

  /// Optional leading icon or widget.
  final Widget? leading;

  /// Optional trailing icon or widget.
  final Widget? trailing;

  /// Whether the button is in a progress/loading state.
  final bool isLoading;

  /// Sizing for leading and trailing icons.
  final double iconSize;

  /// Whether the content should fill available horizontal width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Semantics(
        label: label,
        liveRegion: true,
        child: const AppLoader(size: AppLoaderSize.small, label: 'Loading'),
      );
    }

    return Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leading != null) ...[
          IconTheme(
            data: IconThemeData(size: iconSize),
            child: leading!,
          ),
          AppSpacing.buttonGap.horizontalGap,
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        if (trailing != null) ...[
          AppSpacing.buttonGap.horizontalGap,
          IconTheme(
            data: IconThemeData(size: iconSize),
            child: trailing!,
          ),
        ],
      ],
    );
  }
}
