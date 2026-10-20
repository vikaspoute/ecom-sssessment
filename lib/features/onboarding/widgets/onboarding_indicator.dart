import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// Smooth expanding pill page indicator for carousel walkthroughs.
class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
  });

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
          width: isActive ? 28.0 : 6.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.outline,
            borderRadius: AppRadii.borderPill,
          ),
        );
      }),
    );
  }
}
