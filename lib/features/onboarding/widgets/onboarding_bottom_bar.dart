import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/features/onboarding/widgets/onboarding_indicator.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';

/// Bottom bar for onboarding walkthrough including page indicators and navigation controls.
class OnboardingBottomBar extends StatelessWidget {
  /// Creates an [OnboardingBottomBar].
  const OnboardingBottomBar({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.onNext,
    required this.onPrevious,
    required this.onComplete,
  });

  /// Total number of onboarding slides.
  final int itemCount;

  /// Current active slide index (0-indexed).
  final int currentIndex;

  /// Callback to navigate to next slide.
  final VoidCallback onNext;

  /// Callback to navigate to previous slide.
  final VoidCallback onPrevious;

  /// Callback invoked on final page tap to complete onboarding.
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isLastPage = currentIndex == itemCount - 1;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.xs,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.maxContentWidth,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OnboardingIndicator(
                itemCount: itemCount,
                currentIndex: currentIndex,
              ),
              AppSpacing.md.verticalGap,
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: isLastPage
                    ? AppButton(
                        key: const ValueKey('onboarding_start_button'),
                        label: 'Start Shopping',
                        size: AppButtonSize.large,
                        variant: AppButtonVariant.primary,
                        expand: true,
                        leading: Icon(
                          Icons.shopping_bag_outlined,
                          size: AppSizes.iconSm,
                          color: colorScheme.onPrimary,
                        ),
                        onPressed: onComplete,
                      )
                    : Row(
                        key: const ValueKey('onboarding_nav_row'),
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (currentIndex > 0)
                            IconButton(
                              key: const ValueKey('onboarding_prev_button'),
                              tooltip: 'Previous',
                              style: IconButton.styleFrom(
                                backgroundColor:
                                    colorScheme.surfaceContainerHighest,
                                foregroundColor: colorScheme.primary,
                                shape: const CircleBorder(),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                size: AppSizes.iconSm,
                              ),
                              onPressed: onPrevious,
                            )
                          else
                            const SizedBox(width: AppSizes.buttonHeightSm),
                          AppButton(
                            key: const ValueKey('onboarding_next_button'),
                            label: 'Next',
                            size: AppButtonSize.medium,
                            variant: AppButtonVariant.primary,
                            trailing: Icon(
                              Icons.arrow_forward_rounded,
                              size: AppSizes.iconSm,
                              color: colorScheme.onPrimary,
                            ),
                            onPressed: onNext,
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
