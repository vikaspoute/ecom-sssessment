import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/shared/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

/// Standalone skeleton element box.
///
/// If placed inside an [AppShimmer], it participates in the unified gradient sweep.
/// If used standalone, it wraps itself in [AppShimmer].
class AppShimmerBox extends StatelessWidget {
  /// Creates an [AppShimmerBox] skeleton element.
  const AppShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadii.borderMd,
    this.shape = BoxShape.rectangle,
  });

  /// The width of the placeholder box.
  final double? width;

  /// The height of the placeholder box.
  final double? height;

  /// The border radius for rectangular placeholders.
  final BorderRadiusGeometry borderRadius;

  /// The shape of the placeholder box.
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final hasAncestor =
        context.dependOnInheritedWidgetOfExactType<InheritedShimmer>() != null;

    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        shape: shape,
      ),
    );

    if (hasAncestor) {
      return box;
    }

    return AppShimmer(child: box);
  }
}
