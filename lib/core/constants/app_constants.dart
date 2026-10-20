import 'package:flutter/material.dart';

/// Application-wide configuration. Design tokens live in `lib/core/theme`.
abstract final class AppConstants {
  static const String appName = 'ecom';
  static const String defaultLocaleLanguageCode = 'en';
  static const String defaultLocaleCountryCode = 'IN';
  static const Locale defaultLocale = Locale(
    defaultLocaleLanguageCode,
    defaultLocaleCountryCode,
  );
  static const String currencyCode = 'INR';
  static const String currencySymbol = '₹';
}
