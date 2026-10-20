import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/router/app_routes.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Supporting footer widget displaying evaluation credentials and a link to the onboarding walkthrough.
class LoginDemoFooter extends StatelessWidget {
  /// Creates a [LoginDemoFooter].
  const LoginDemoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Column(
      children: [
        AppSpacing.lg.verticalGap,
        Text(
          'Demo: ${AuthRepository.demoEmail} / ${AuthRepository.demoPassword}',
          style: AppTypography.caption,
          textAlign: TextAlign.center,
        ),
        AppSpacing.sm.verticalGap,
        Center(
          child: TextButton.icon(
            key: const ValueKey('explore_onboarding_button'),
            icon: Icon(
              Icons.auto_awesome_outlined,
              size: AppSizes.iconSm,
              color: colorScheme.secondary,
            ),
            label: Text(
              'Explore Brand Experience',
              style: AppTypography.labelMedium.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () => context.push(AppRoutes.onboarding),
          ),
        ),
      ],
    );
  }
}
