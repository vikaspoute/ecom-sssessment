import 'package:ecom/app.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:ecom/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'launches on the onboarding screen by default and navigates to login on skip',
    (tester) async {
      await tester.pumpWidget(
        const EcomApp(authRepository: AuthRepository(delay: Duration.zero)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(
        find.byKey(const ValueKey('onboarding_skip_button')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('onboarding_skip_button')));
      await tester.pumpAndSettle();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    },
  );
}
