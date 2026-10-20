import 'package:flutter/material.dart';

/// Shared corner radii. Theme mapping: fields/buttons [sm], product images
/// [md], cards [lg], dialogs [xl], chips [pill].
abstract final class AppRadii {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double pill = 999;
  static const double circle = 9999;

  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius borderXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius borderPill = BorderRadius.all(
    Radius.circular(pill),
  );
  static const BorderRadius borderCircle = BorderRadius.all(
    Radius.circular(circle),
  );
}
