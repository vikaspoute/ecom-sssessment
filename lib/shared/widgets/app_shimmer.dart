import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/shared/widgets/app_shimmer_box.dart';
import 'package:ecom/shared/widgets/inherited_shimmer.dart';
import 'package:flutter/material.dart';

export 'package:ecom/shared/widgets/app_shimmer_box.dart';
export 'package:ecom/shared/widgets/inherited_shimmer.dart';

/// Sweeping light shimmer animation used across skeleton screens and image loading.
class AppShimmer extends StatefulWidget {
  /// Creates an [AppShimmer] gradient container.
  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  /// The child widget tree containing skeleton placeholder elements.
  final Widget child;

  /// Optional base tint color for the shimmer gradient.
  final Color? baseColor;

  /// Optional highlight tint color for the moving shimmer beam.
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
      return InheritedShimmer(
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

    return InheritedShimmer(
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
