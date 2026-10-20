import 'package:ecom/core/constants/app_constants.dart';
import 'package:intl/intl.dart';

/// Formatter utilities for currency and text presentation.
abstract final class AppFormatters {
  static final NumberFormat inrCurrency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 2,
  );

  /// Format an amount into an Indian rupee string, e.g. `₹1,299.00`.
  static String formatInr(num amount) => inrCurrency.format(amount);
}
