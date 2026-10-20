import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppRadii.borderMd,
    this.semanticLabel,
  });

  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
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
                  placeholder: (context, url) => const _ImagePlaceholder(),
                  errorWidget: (context, url, error) => const _ImageFallback(),
                )
              : const _ImageFallback(),
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const AppShimmerBox(
      width: double.infinity,
      height: double.infinity,
      borderRadius: BorderRadius.zero,
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

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
