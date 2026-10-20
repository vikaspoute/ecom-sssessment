import 'package:ecom/app.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:ecom/features/products/screens/product_listing_screen.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:ecom/shared/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Finder get _emailField => find.byType(TextFormField).first;
Finder get _passwordField => find.byType(TextFormField).last;
Finder get _loginButton => find.widgetWithText(FilledButton, 'Log in');

Future<void> _pumpLogin(WidgetTester tester) async {
  await tester.pumpWidget(
    const EcomApp(
      initialLocation: AppRoutes.login,
      authRepository: AuthRepository(delay: Duration.zero),
    ),
  );
  await tester.pumpAndSettle();
}

FilledButton _button(WidgetTester tester) {
  return tester.widget<FilledButton>(_loginButton);
}

void main() {
  testWidgets('keeps Log in disabled when email and password are empty', (
    tester,
  ) async {
    await _pumpLogin(tester);

    expect(_button(tester).onPressed, isNull);
  });

  testWidgets('shows an error for an invalid email format', (tester) async {
    await _pumpLogin(tester);

    await tester.enterText(_emailField, 'not-an-email');
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password cannot be empty'), findsNothing);
    expect(find.text('Password must be at least 8 characters'), findsNothing);
    expect(_button(tester).onPressed, isNull);
  });

  testWidgets('shows an error when password is too short', (tester) async {
    await _pumpLogin(tester);

    await tester.enterText(_passwordField, 'short');
    await tester.pump();

    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
    expect(find.text('Email cannot be empty'), findsNothing);
    expect(find.text('Enter a valid email address'), findsNothing);
    expect(_button(tester).onPressed, isNull);
  });

  testWidgets('enables Log in when both fields are valid', (tester) async {
    await _pumpLogin(tester);

    await tester.enterText(_emailField, AuthRepository.demoEmail);
    await tester.enterText(_passwordField, AuthRepository.demoPassword);
    await tester.pump();

    expect(_button(tester).onPressed, isNotNull);
  });

  testWidgets('toggles password visibility', (tester) async {
    await _pumpLogin(tester);

    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isTrue,
    );

    await tester.tap(find.byKey(const ValueKey('password_visibility')));
    await tester.pump();

    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isFalse,
    );
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('navigates to products after a successful login', (tester) async {
    await _pumpLogin(tester);

    await tester.enterText(_emailField, AuthRepository.demoEmail);
    await tester.enterText(_passwordField, AuthRepository.demoPassword);
    await tester.pump();

    await tester.tap(_loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(ProductListingScreen), findsOneWidget);
  });

  testWidgets('stays on login and shows an error after a failed login', (
    tester,
  ) async {
    await _pumpLogin(tester);

    await tester.enterText(_emailField, 'wrong@ecom.app');
    await tester.enterText(_passwordField, 'WrongPass123');
    await tester.pump();

    await tester.tap(_loginButton);
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text(AuthRepository.invalidCredentialsMessage), findsOneWidget);
  });

  testWidgets('shows a loading state while authenticating', (tester) async {
    await tester.pumpWidget(
      const EcomApp(
        initialLocation: AppRoutes.login,
        authRepository: AuthRepository(delay: Duration(milliseconds: 200)),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(_emailField, AuthRepository.demoEmail);
    await tester.enterText(_passwordField, AuthRepository.demoPassword);
    await tester.pump();

    await tester.tap(_loginButton);
    await tester.pump();

    expect(find.byType(AppLoader), findsOneWidget);
    expect(tester.widget<AppButton>(find.byType(AppButton)).isLoading, isTrue);

    await tester.pumpAndSettle();
    expect(find.byType(ProductListingScreen), findsOneWidget);
  });
}
