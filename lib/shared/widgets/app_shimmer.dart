import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:flutter/material.dart';

/// Sweeping light shimmer animation used across skeleton screens and image loading.
class AppShimmer extends StatefulWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _isTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (!_isTest) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final base = widget.baseColor ?? colorScheme.surfaceContainerHighest;
    final highlight =
        widget.highlightColor ??
        (context.isDarkMode
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.6)
            : colorScheme.surface);

    if (_isTest) {
      return _InheritedShimmer(
        isShimmering: false,
        child: ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          child: widget.child,
        ),
      );
    }

    return _InheritedShimmer(
      isShimmering: true,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              final dx = _controller.value * 2 - 0.5;
              return LinearGradient(
                begin: Alignment(dx - 1.0, -0.3),
                end: Alignment(dx + 1.0, 0.3),
                colors: [base, highlight, base],
                stops: const [0.25, 0.5, 0.75],
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _InheritedShimmer extends InheritedWidget {
  const _InheritedShimmer({required this.isShimmering, required super.child});

  final bool isShimmering;

  @override
  bool updateShouldNotify(_InheritedShimmer oldWidget) =>
      isShimmering != oldWidget.isShimmering;
}

/// Standalone skeleton element box. If placed inside an [AppShimmer], it participates
/// in the unified gradient sweep. If used standalone, it wraps itself in [AppShimmer].
class AppShimmerBox extends StatelessWidget {
  const AppShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = AppRadii.borderMd,
    this.shape = BoxShape.rectangle,
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final hasAncestor =
        context.dependOnInheritedWidgetOfExactType<_InheritedShimmer>() != null;

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
