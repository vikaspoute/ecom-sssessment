import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/shared/widgets/image_fallback.dart';
import 'package:ecom/shared/widgets/image_placeholder.dart';
import 'package:flutter/material.dart';

/// Reusable network image component wrapped with cached loading, shimmer placeholder,
/// and graceful fallback states.
class AppNetworkImage extends StatelessWidget {
  /// Creates an [AppNetworkImage].
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadii.borderMd,
    this.semanticLabel,
  });

  /// The remote image URL.
  final String? imageUrl;

  /// Optional fixed width for the image.
  final double? width;

  /// Optional fixed height for the image.
  final double? height;

  /// How the image should be inscribed into the box.
  final BoxFit fit;

  /// Corner radius for clipping the image.
  final BorderRadius borderRadius;

  /// Accessibility label describing image content.
  final String? semanticLabel;

  bool get _hasValidUrl {
    final value = imageUrl?.trim() ?? '';
    if (value.isEmpty) {
      return false;
    }
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: SizedBox(
          width: width,
          height: height,
          child: _hasValidUrl
              ? CachedNetworkImage(
                  imageUrl: imageUrl!.trim(),
                  width: width,
                  height: height,
                  fit: fit,
                  placeholder: (context, url) => const ImagePlaceholder(),
                  errorWidget: (context, url, error) => const ImageFallback(),
                )
              : const ImageFallback(),
        ),
      ),
    );
  }
}
