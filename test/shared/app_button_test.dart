import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/shared/widgets/app_button.dart';
import 'package:ecom/shared/widgets/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('invokes onPressed for a primary button', (tester) async {
    var pressed = 0;

    await tester.pumpWidget(
      _wrap(AppButton(label: 'Add to cart', onPressed: () => pressed++)),
    );

    await tester.tap(find.text('Add to cart'));
    await tester.pump();

    expect(pressed, 1);
    expect(find.byType(FilledButton), findsOneWidget);
  });

  testWidgets('does not invoke onPressed while loading', (tester) async {
    var pressed = 0;

    await tester.pumpWidget(
      _wrap(
        AppButton(
          label: 'Checkout',
          isLoading: true,
          onPressed: () => pressed++,
        ),
      ),
    );

    expect(find.byType(AppLoader), findsOneWidget);

    await tester.tap(find.byType(AppButton));
    await tester.pump();

    expect(pressed, 0);
  });

  testWidgets('is disabled when onPressed is null', (tester) async {
    await tester.pumpWidget(_wrap(const AppButton(label: 'Save')));

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('renders outlined variant', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppButton(
          label: 'Cancel',
          variant: AppButtonVariant.outlined,
          onPressed: () {},
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
  });
}
