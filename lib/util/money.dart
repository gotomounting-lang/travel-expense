import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/currency.dart';

final _krw = NumberFormat('#,##0', 'en_US');

String formatKrw(AppLocalizations l, num value) => l.krw(_krw.format(value));

String formatForeign(double amount, String currencyCode) {
  final decimals = Currency.byCode(currencyCode).decimals;
  final f = NumberFormat.decimalPatternDigits(
    locale: 'en_US',
    decimalDigits: decimals,
  );
  return '${f.format(amount)} $currencyCode';
}
