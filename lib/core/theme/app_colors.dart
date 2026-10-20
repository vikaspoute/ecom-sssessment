import 'package:flutter/material.dart';

/// Single source of truth for the light e-commerce palette.
///
/// Premium minimalist fashion: charcoal primary, warm off-white canvas,
/// muted taupe accent. Widgets should use these tokens or [ColorScheme],
/// never raw color literals.
abstract final class AppColors {
  static const Color primary = Color(0xFF1C1917);
  static const Color onPrimary = Color(0xFFFAF7F2);

  static const Color background = Color(0xFFFAF7F2);
  static const Color onBackground = Color(0xFF1C1917);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF1C1917);
  static const Color surfaceVariant = Color(0xFFF1EBE4);

  static const Color outline = Color(0xFFE4DDD4);
  static const Color divider = Color(0xFFD9D1C7);

  /// Secondary copy; ≥ 4.5:1 on [background] and [surface].
  static const Color onSurfaceMuted = Color(0xFF6F6A64);

  static const Color accent = Color(0xFF8A7A6B);
  static const Color onAccent = Color(0xFFFAF7F2);

  static const Color error = Color(0xFFB42318);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF16794C);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color warning = Color(0xFFB45309);
  static const Color onWarning = Color(0xFFFFFFFF);

  static const Color disabled = Color(0xFFA8A29C);
  static const Color overlay = Color(0x73000000);
}
