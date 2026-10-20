import 'package:ecom/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Plus Jakarta Sans type scale. [height] is a line-height multiplier so
/// Flutter text scaling is not clipped by fixed containers.
abstract final class AppTypography {
  static String get fontFamily => GoogleFonts.plusJakartaSans().fontFamily!;

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    double letterSpacing = 0,
    Color color = AppColors.onSurface,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  static TextStyle get displayLarge => _base(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.8,
  );

  static TextStyle get displayMedium => _base(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.6,
  );

  static TextStyle get displaySmall => _base(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.4,
  );

  static TextStyle get headlineLarge => _base(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle get headlineMedium =>
      _base(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3);

  static TextStyle get headlineSmall =>
      _base(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);

  static TextStyle get titleLarge =>
      _base(fontSize: 22, fontWeight: FontWeight.w600, height: 1.3);

  static TextStyle get titleMedium =>
      _base(fontSize: 18, fontWeight: FontWeight.w600, height: 1.35);

  static TextStyle get titleSmall =>
      _base(fontSize: 16, fontWeight: FontWeight.w600, height: 1.4);

  static TextStyle get bodyLarge =>
      _base(fontSize: 18, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get bodyMedium =>
      _base(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get bodySmall => _base(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
    color: AppColors.onSurfaceMuted,
  );

  static TextStyle get labelLarge => _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => _base(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => _base(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.3,
  );

  static TextStyle get caption => _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.onSurfaceMuted,
  );

  static TextStyle get button => _base(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.2,
  );

  static TextStyle get productTitle => titleSmall;

  static TextStyle get productPrice =>
      _base(fontSize: 16, fontWeight: FontWeight.w700, height: 1.3);

  static TextStyle get productDescription => bodySmall;

  static TextStyle get sectionHeading => headlineSmall;

  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
