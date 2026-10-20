import 'package:flutter/material.dart';

/// Component dimensions. Do not use these for general padding — see AppSpacing.
///
/// Product imagery is a 3:4 fashion crop, not a full-bleed device width.
/// Wide layouts should still wrap content with [maxContentWidth] via
/// LayoutBuilder / ConstrainedBox rather than assuming a phone width.
abstract final class AppSizes {
  static const double iconXs = 12;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  static const double buttonHeightSm = 40;
  static const double buttonHeightMd = 48;
  static const double buttonHeightLg = 56;

  static const double inputHeight = 52;
  static const double appBarHeight = 56;
  static const double bottomNavHeight = 64;

  static const double avatarSm = 32;
  static const double avatarMd = 40;
  static const double avatarLg = 56;

  static const Size productCardImage = Size(164, 220);

  static const double loaderSm = 16;
  static const double loaderMd = 24;
  static const double loaderLg = 40;

  static const double maxContentWidth = 600;
  static const double minTouchTarget = 48;

  static const double cartThumbnailSize = 84;
  static const double stepperButtonSize = 32;
  static const double closeButtonSize = 28;
  static const double indicatorBarWidth = 40;
  static const double indicatorBarHeight = 4;
  static const double categoryFilterHeight = 38;
  static const double cardContentHeight = 156;
  static const double badgeDotSize = 6;
  static const double borderWidthThin = 1.0;
  static const double borderWidthRegular = 1.2;
  static const double borderWidthMedium = 1.5;
  static const double strokeWidthThin = 2.0;
  static const double strokeWidthRegular = 3.0;
}
