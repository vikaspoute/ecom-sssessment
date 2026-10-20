import 'package:flutter/material.dart';

/// Internal inherited widget that coordinates shimmer sweep across nested skeleton elements.
class InheritedShimmer extends InheritedWidget {
  /// Creates an [InheritedShimmer].
  const InheritedShimmer({
    super.key,
    required this.isShimmering,
    required super.child,
  });

  /// Whether active shimmer animation is running in ancestor.
  final bool isShimmering;

  @override
  bool updateShouldNotify(InheritedShimmer oldWidget) =>
      isShimmering != oldWidget.isShimmering;
}
