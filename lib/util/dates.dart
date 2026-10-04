import 'package:intl/intl.dart';

final _ymd = DateFormat('yyyy-MM-dd');

String formatYmd(DateTime d) => _ymd.format(d);

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
