import 'package:ecom/core/theme/app_sizes.dart';
import 'package:flutter/material.dart';

enum AppLoaderSize { small, medium, large }

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = AppLoaderSize.medium,
    this.label = 'Loading',
    this.centered = false,
  });

  /// Compact spinner for buttons and inline rows.
  const AppLoader.inline({
    super.key,
    this.size = AppLoaderSize.small,
    this.label = 'Loading',
  }) : centered = false;

  /// Centered spinner for full-page placeholders.
  const AppLoader.page({
    super.key,
    this.size = AppLoaderSize.large,
    this.label = 'Loading',
  }) : centered = true;

  final AppLoaderSize size;
  final String label;
  final bool centered;

  double get _dimension => switch (size) {
    AppLoaderSize.small => AppSizes.loaderSm,
    AppLoaderSize.medium => AppSizes.loaderMd,
    AppLoaderSize.large => AppSizes.loaderLg,
  };

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: _dimension,
      child: CircularProgressIndicator(
        strokeWidth: size == AppLoaderSize.small
            ? AppSizes.strokeWidthThin
            : AppSizes.strokeWidthRegular,
      ),
    );

    final labeled = Semantics(label: label, liveRegion: true, child: indicator);

    if (!centered) {
      return labeled;
    }

    return Center(child: labeled);
  }
}
