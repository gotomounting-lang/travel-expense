import 'package:intl/intl.dart';

import '../models/currency.dart';

final _krw = NumberFormat('#,##0', 'ko_KR');

String formatKrw(num value) => '${_krw.format(value)}원';

String formatForeign(double amount, String currencyCode) {
  final decimals = Currency.byCode(currencyCode).decimals;
  final f = NumberFormat.decimalPatternDigits(
    locale: 'en_US',
    decimalDigits: decimals,
  );
  return '${f.format(amount)} $currencyCode';
}
