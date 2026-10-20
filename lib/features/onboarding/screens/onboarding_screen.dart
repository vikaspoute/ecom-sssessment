import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/features/onboarding/models/onboarding_item.dart';
import 'package:ecom/features/onboarding/widgets/onboarding_bottom_bar.dart';
import 'package:ecom/features/onboarding/widgets/onboarding_page_content.dart';
import 'package:ecom/features/onboarding/widgets/onboarding_skip_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Full-screen editorial onboarding walkthrough introducing brand ethos,
/// interactive wardrobe curation, and express dispatch.
class OnboardingScreen extends StatefulWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({
    super.key,
    this.items = OnboardingItem.items,
    this.onFinish,
  });

  /// The list of onboarding slides to display.
  final List<OnboardingItem> items;

  /// Optional completion callback for navigation customization in widget tests.
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
    return Scaffold(
      body: Stack(
        children: [
          // Main layout: upper carousel and bottom navigation bar
          Column(
            children: [
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
              OnboardingBottomBar(
                itemCount: widget.items.length,
                currentIndex: _currentIndex,
                onNext: _nextPage,
                onPrevious: _previousPage,
                onComplete: _complete,
              ),
            ],
          ),
          // Floating Skip chip positioned above editorial imagery
          Positioned(
            top: MediaQuery.paddingOf(context).top + AppSpacing.sm,
            right: AppSpacing.screenPadding,
            child: OnboardingSkipButton(onSkip: _complete),
          ),
        ],
      ),
    );
  }
}
