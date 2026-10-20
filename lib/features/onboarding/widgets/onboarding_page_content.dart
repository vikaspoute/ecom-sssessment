import 'package:ecom/core/extensions/context_extensions.dart';
import 'package:ecom/core/extensions/number_extensions.dart';
import 'package:ecom/core/theme/app_radii.dart';
import 'package:ecom/core/theme/app_sizes.dart';
import 'package:ecom/core/theme/app_spacing.dart';
import 'package:ecom/core/theme/app_typography.dart';
import 'package:ecom/features/onboarding/models/onboarding_item.dart';
import 'package:ecom/shared/widgets/app_network_image.dart';
import 'package:flutter/material.dart';

/// Single page layout mirroring a luxury product details screen:
/// - Upper 36% full-bleed editorial imagery (no card border, no radius).
/// - Lower section with structured metadata, editorial copy, and feature tags.
class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({super.key, required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = (screenHeight * 0.48).clamp(240.0, 520.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Upper full-width immersive hero image (no card boundary, no border radius)
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(
                imageUrl: item.imageUrl,
                semanticLabel: item.title,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.zero,
              ),
              // Subtle gradient overlay at bottom of photo for visual transition
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 48,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.18),
                      ],
                    ),
                  ),
                ),
              ),
              // Floating luxury badge at bottom-left of hero image
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.screenPadding,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: AppRadii.borderPill,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.20),
                      width: AppSizes.borderWidthThin,
                    ),
                  ),
                  child: Text(
                    item.badge,
                    style: AppTypography.labelSmall.copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Lower product-details-style data section
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.tag,
                        style: AppTypography.caption.copyWith(
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.secondary,
                        ),
                      ),
                      AppSpacing.xs.verticalGap,
                      Text(
                        item.title,
                        style: AppTypography.headlineSmall.copyWith(
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      AppSpacing.sm.verticalGap,
                      Text(
                        item.description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                      if (item.highlights.isNotEmpty) ...[
                        AppSpacing.md.verticalGap,
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.xs,
                          children: item.highlights.map((highlight) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: AppRadii.borderPill,
                                border: Border.all(
                                  color: colorScheme.outline,
                                  width: AppSizes.borderWidthThin,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: AppSizes.iconXs,
                                    color: colorScheme.secondary,
                                  ),
                                  AppSpacing.xs.horizontalGap,
                                  Text(
                                    highlight,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
