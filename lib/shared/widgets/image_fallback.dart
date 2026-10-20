import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

/// Fallback placeholder displayed when an image fails to load or the URL is empty.
class ImageFallback extends StatelessWidget {
  /// Creates an [ImageFallback] widget.
  const ImageFallback({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: AppSizes.iconLg,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
