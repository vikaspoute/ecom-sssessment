import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(theme: AppTheme.light(), home: child);
}

void main() {
  testWidgets('renders first onboarding slide and controls', (tester) async {
    await tester.pumpWidget(_wrap(const OnboardingScreen()));

    // Skip chip
    expect(
      find.byKey(const ValueKey('onboarding_skip_button')),
      findsOneWidget,
    );
    expect(find.text('Skip'), findsOneWidget);

    // Slide 1 content
    expect(find.text('SPRING / SUMMER 2026'), findsOneWidget);
    expect(find.text('TIMELESS LUXURY'), findsOneWidget);
    expect(find.text('Curated Elegance,\nCrafted to Endure'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('onboarding_next_button')),
      findsOneWidget,
    );
  });

  testWidgets('advances to next slide and shows previous button', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const OnboardingScreen()));

    // Tap Next
    await tester.tap(find.byKey(const ValueKey('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Slide 2 content
    expect(find.text('DYNAMIC SELECTION'), findsOneWidget);
    expect(find.text('LIVE WARDROBE'), findsOneWidget);
    expect(find.text('Effortless Styling,\nSeamless Bag Sync'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('onboarding_prev_button')),
      findsOneWidget,
    );

    // Tap Previous
    await tester.tap(find.byKey(const ValueKey('onboarding_prev_button')));
    await tester.pumpAndSettle();

    // Back to Slide 1
    expect(find.text('SPRING / SUMMER 2026'), findsOneWidget);
  });

  testWidgets('reaches last slide and triggers onFinish callback', (
    tester,
  ) async {
    var finished = false;

    await tester.pumpWidget(
      _wrap(OnboardingScreen(onFinish: () => finished = true)),
    );

    // Advance to slide 2
    await tester.tap(find.byKey(const ValueKey('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Advance to slide 3
    await tester.tap(find.byKey(const ValueKey('onboarding_next_button')));
    await tester.pumpAndSettle();

    // Slide 3 content and Start Shopping button
    expect(find.text('COMPLIMENTARY SHIPPING'), findsOneWidget);
    expect(find.text('EXPRESS DISPATCH'), findsOneWidget);
    final startButton = find.byKey(const ValueKey('onboarding_start_button'));
    expect(startButton, findsOneWidget);

    await tester.tap(startButton);
    await tester.pump();

    expect(finished, isTrue);
  });

  testWidgets('Skip button invokes onFinish callback immediately', (
    tester,
  ) async {
    var finished = false;

    await tester.pumpWidget(
      _wrap(OnboardingScreen(onFinish: () => finished = true)),
    );

    await tester.tap(find.byKey(const ValueKey('onboarding_skip_button')));
    await tester.pump();

    expect(finished, isTrue);
  });
}
