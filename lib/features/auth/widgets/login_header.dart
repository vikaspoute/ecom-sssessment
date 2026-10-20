import 'package:ecom/core/constants/app_constants.dart';
import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

/// Top header banner for the login screen displaying brand label, title, and subtitle.
class LoginHeader extends StatelessWidget {
  /// Creates a [LoginHeader].
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSpacing.huge.verticalGap,
        Text(
          AppConstants.appName,
          style: AppTypography.labelLarge.copyWith(
            color: colorScheme.secondary,
            letterSpacing: 2,
          ),
        ),
        AppSpacing.md.verticalGap,
        Text('Welcome back', style: AppTypography.headlineLarge),
        AppSpacing.sm.verticalGap,
        Text(
          'Sign in to continue shopping the collection.',
          style: AppTypography.bodyMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
