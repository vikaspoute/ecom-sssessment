import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Floating semi-translucent glassmorphic skip chip positioned over hero imagery.
class OnboardingSkipButton extends StatelessWidget {
  /// Creates an [OnboardingSkipButton].
  const OnboardingSkipButton({
    super.key,
    required this.onSkip,
  });

  /// Callback when user taps the skip chip.
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const ValueKey('onboarding_skip_button'),
        onTap: onSkip,
        borderRadius: AppRadii.borderPill,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.50),
            borderRadius: AppRadii.borderPill,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.35),
              width: AppSizes.borderWidthThin,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.20),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Skip',
                style: AppTypography.labelMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              AppSpacing.xxs.horizontalGap,
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 10,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
