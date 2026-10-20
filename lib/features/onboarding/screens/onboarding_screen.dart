import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/onboarding/models/onboarding_item.dart';
import 'package:ecom/features/onboarding/widgets/onboarding_indicator.dart';
import 'package:ecom/features/onboarding/widgets/onboarding_page_content.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen editorial onboarding walkthrough introducing brand ethos,
/// interactive wardrobe curation, and express dispatch.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    this.items = OnboardingItem.items,
    this.onFinish,
  });

  final List<OnboardingItem> items;
  final VoidCallback? onFinish;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _nextPage() {
    if (_currentIndex < widget.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _complete();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _complete() {
    if (widget.onFinish != null) {
      widget.onFinish!();
      return;
    }

    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final isLastPage = _currentIndex == widget.items.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Main content: upper full-bleed image + lower product details section + bottom controls
          Column(
            children: [
              // Middle PageView carousel with full-bleed top image and details
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.items.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    return OnboardingPageContent(item: widget.items[index]);
                  },
                ),
              ),
              // Bottom navigation & indicator bar
              SafeArea(
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
                        // Animated pill indicators
                        OnboardingIndicator(
                          itemCount: widget.items.length,
                          currentIndex: _currentIndex,
                        ),
                        AppSpacing.md.verticalGap,
                        // Dynamic action buttons
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: isLastPage
                              ? AppButton(
                                  key: const ValueKey(
                                    'onboarding_start_button',
                                  ),
                                  label: 'Start Shopping',
                                  size: AppButtonSize.large,
                                  variant: AppButtonVariant.primary,
                                  expand: true,
                                  leading: Icon(
                                    Icons.shopping_bag_outlined,
                                    size: AppSizes.iconSm,
                                    color: colorScheme.onPrimary,
                                  ),
                                  onPressed: _complete,
                                )
                              : Row(
                                  key: const ValueKey('onboarding_nav_row'),
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (_currentIndex > 0)
                                      IconButton(
                                        key: const ValueKey(
                                          'onboarding_prev_button',
                                        ),
                                        tooltip: 'Previous',
                                        style: IconButton.styleFrom(
                                          backgroundColor: colorScheme
                                              .surfaceContainerHighest,
                                          foregroundColor: colorScheme.primary,
                                          shape: const CircleBorder(),
                                        ),
                                        icon: const Icon(
                                          Icons.arrow_back_rounded,
                                          size: AppSizes.iconSm,
                                        ),
                                        onPressed: _previousPage,
                                      )
                                    else
                                      const SizedBox(
                                        width: AppSizes.buttonHeightSm,
                                      ),
                                    AppButton(
                                      key: const ValueKey(
                                        'onboarding_next_button',
                                      ),
                                      label: 'Next',
                                      size: AppButtonSize.medium,
                                      variant: AppButtonVariant.primary,
                                      trailing: Icon(
                                        Icons.arrow_forward_rounded,
                                        size: AppSizes.iconSm,
                                        color: colorScheme.onPrimary,
                                      ),
                                      onPressed: _nextPage,
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Floating Skip chip on top (no app bar)
          Positioned(
            top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
            right: AppSpacing.screenPadding,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const ValueKey('onboarding_skip_button'),
                onTap: _complete,
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
            ),
          ),
        ],
      ),
    );
  }
}
