import 'package:ecom/core/theme/app_theme.dart';
import 'package:ecom/shared/widgets/app_error_view.dart';
import 'package:ecom/shared/widgets/app_loader.dart';
import 'package:ecom/shared/widgets/app_network_image.dart';
import 'package:ecom/shared/widgets/app_text_field.dart';
import 'package:ecom/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('AppTextField updates the controller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      _wrap(
        AppTextField(
          controller: controller,
          labelText: 'Email',
          hintText: 'you@example.com',
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'ada@ecom.test');
    expect(controller.text, 'ada@ecom.test');
  });

  testWidgets('AppErrorView retry is tappable', (tester) async {
    var retries = 0;

    await tester.pumpWidget(
      _wrap(
        AppErrorView(
          title: 'Could not load products',
          message: 'Check your connection and try again.',
          onRetry: () => retries++,
        ),
      ),
    );

    await tester.tap(find.text('Try again'));
    await tester.pump();

    expect(retries, 1);
  });

  testWidgets('EmptyState action is tappable', (tester) async {
    var shopped = 0;

    await tester.pumpWidget(
      _wrap(
        EmptyState(
          icon: Icons.shopping_bag_outlined,
          title: 'Your cart is empty',
          description: 'Browse the collection to add pieces.',
          actionLabel: 'Start shopping',
          onAction: () => shopped++,
        ),
      ),
    );

    await tester.tap(find.text('Start shopping'));
    await tester.pump();

    expect(shopped, 1);
  });

  testWidgets('AppLoader.page exposes a loading label', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppLoader.page(label: 'Loading products')),
    );

    expect(find.bySemanticsLabel('Loading products'), findsOneWidget);
  });

  testWidgets('AppNetworkImage shows fallback for an invalid URL', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        const AppNetworkImage(
          imageUrl: 'not-a-url',
          width: 80,
          height: 80,
          semanticLabel: 'Product photo',
        ),
      ),
    );

    expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
  });
}
