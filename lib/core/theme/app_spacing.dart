/// 4-point spacing scale and semantic layout aliases.
///
/// Use the scale (`xs`–`giant`) for one-off offsets. Prefer semantic tokens
/// in common layouts:
/// - Scaffold / page body: [screenPadding]; nested lists: [screenPaddingCompact]
/// - Card interiors: [cardPadding]
/// - Between page sections: [sectionGap]
/// - Between list or grid items: [itemGap]
/// - Between form fields: [formFieldGap]
/// - Between sibling buttons: [buttonGap]
abstract final class AppSpacing {
  static const double none = 0;
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double huge = 40;
  static const double massive = 48;
  static const double giant = 64;

  static const double screenPadding = xl;
  static const double screenPaddingCompact = md;
  static const double cardPadding = lg;
  static const double sectionGap = xxl;
  static const double itemGap = md;
  static const double formFieldGap = lg;
  static const double buttonGap = sm;
}
