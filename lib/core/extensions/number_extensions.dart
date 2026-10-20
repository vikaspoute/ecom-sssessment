import 'package:ecom/core/utils/formatters.dart';
import 'package:flutter/widgets.dart';

extension AppNumberX on num {
  /// Locale-aware Indian rupee string, e.g. `₹1,299.00`.
  String toInr() => AppFormatters.formatInr(this);

  SizedBox get verticalGap => SizedBox(height: toDouble());

  SizedBox get horizontalGap => SizedBox(width: toDouble());
}
