import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Shimmer placeholder displayed while an image is downloading.
class ImagePlaceholder extends StatelessWidget {
  /// Creates an [ImagePlaceholder] widget.
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShimmerBox(
      width: double.infinity,
      height: double.infinity,
      borderRadius: BorderRadius.zero,
    );
  }
}
