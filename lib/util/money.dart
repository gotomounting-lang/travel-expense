import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/currency.dart';

/// 환산 금액 표시. 한국어 화면의 원화는 "12,345원", 그 밖에는 "\$12.50" 처럼.
String formatMoney(AppLocalizations l, num value, String currency) {
  final decimals = Currency.byCode(currency).decimals;
  if (currency == 'KRW' && l.localeName == 'ko') {
    return l.krw(NumberFormat('#,##0', 'en_US').format(value));
  }
  return NumberFormat.simpleCurrency(
    locale: l.localeName,
    name: currency,
    decimalDigits: decimals,
  ).format(value);
}

String formatForeign(double amount, String currencyCode) {
  final decimals = Currency.byCode(currencyCode).decimals;
  final f = NumberFormat.decimalPatternDigits(
    locale: 'en_US',
    decimalDigits: decimals,
  );
  return '${f.format(amount)} $currencyCode';
}
