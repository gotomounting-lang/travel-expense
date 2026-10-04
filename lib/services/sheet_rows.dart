import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../util/dates.dart';

/// 구글 시트에 쓰는 표 내용을 만든다. 순수 함수라 테스트하기 쉽다.
/// 머리글·카테고리 이름은 앱에서 고른 언어로 쓴다.
///
/// 탭은 이름이 아니라 고정된 sheetId 로 찾는다. 그래서 언어를 바꾸면
/// 다음 동기화 때 같은 탭의 이름만 바뀐다.
enum SheetTab {
  expenses(1001),
  trips(1002),
  summary(1003);

  const SheetTab(this.sheetId);

  final int sheetId;

  String title(AppLocalizations l) => switch (this) {
    expenses => l.tabExpenses,
    trips => l.tabTrips,
    summary => l.tabSummary,
  };
}

List<Object> expenseHeader(AppLocalizations l, String home) => [
  l.colTrip,
  l.colDate,
  l.colTime,
  l.colCategory,
  l.colMerchant,
  l.colCurrency,
  l.colLocalAmount,
  l.colHomeRate(home),
  l.colRateDate,
  l.colHomeAmount(home),
  l.colPayment,
  l.colSource,
  l.colMemo,
  l.colRateSource,
  'ID',
];

List<Object> tripHeader(AppLocalizations l, String home) => [
  l.colTrip,
  l.colCountry,
  l.colCurrency,
  l.colStartDate,
  l.colEndDate,
  l.colHomeTotal(home),
  l.colCount,
  'ID',
];

List<Object> summaryHeader(AppLocalizations l, String home) => [
  l.colTrip,
  l.colCategory,
  l.colHomeTotal(home),
  l.colShare,
];

final _hm = DateFormat('HH:mm');

/// USER_ENTERED 로 쓸 때 사용자가 입력한 글자가 수식으로 해석되지 않게 막는다.
Object _text(String s) => s.isNotEmpty && '=+-@'.contains(s[0]) ? "'$s" : s;

List<List<Object>> buildExpenseRows(
  AppLocalizations l,
  String home,
  List<Trip> trips,
  List<Expense> expenses,
) {
  final titles = {for (final t in trips) t.id: t.title};
  final sorted = [...expenses]..sort((a, b) => a.spentAt.compareTo(b.spentAt));
  return [
    expenseHeader(l, home),
    for (final e in sorted)
      [
        _text(titles[e.tripId] ?? ''),
        formatYmd(e.spentAt),
        _hm.format(e.spentAt),
        e.category.label(l),
        _text(e.merchant),
        e.currency,
        e.amount,
        e.homeCurrency == home ? e.homeRate ?? '' : '',
        e.rateDate == null ? '' : formatYmd(e.rateDate!),
        e.homeCurrency == home ? e.homeAmount ?? '' : '',
        _text(e.paymentMethod),
        e.source.label(l),
        _text(e.memo),
        e.rateSource ?? '',
        e.id,
      ],
  ];
}

List<List<Object>> buildTripRows(
  AppLocalizations l,
  String home,
  List<Trip> trips,
  List<Expense> expenses,
) {
  return [
    tripHeader(l, home),
    for (final t in trips)
      () {
        final mine = expenses.where((e) => e.tripId == t.id);
        return <Object>[
          _text(t.title),
          _text(t.country),
          t.currency,
          formatYmd(t.startDate),
          formatYmd(t.endDate),
          categoryTotals(mine, home).values.fold<double>(0, (s, v) => s + v),
          mine.length,
          t.id,
        ];
      }(),
  ];
}

/// 여행별 카테고리 원화 합계. 앱 파이차트와 같은 계산을 쓴다.
/// [home] 통화로 환산이 끝난 지출만 더한다 (국적을 바꾼 직후 다시 환산 중인 것은 뺀다).
Map<ExpenseCategory, double> categoryTotals(
  Iterable<Expense> expenses,
  String home,
) {
  final totals = <ExpenseCategory, double>{};
  final decimals = Currency.byCode(home).decimals;
  for (final e in expenses) {
    final v = e.homeAmount;
    if (v == null || e.homeCurrency != home) continue;
    totals[e.category] = Expense.roundTo(
      (totals[e.category] ?? 0) + v,
      decimals,
    );
  }
  return Map.fromEntries(
    totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
  );
}

/// 요약 탭에서 한 여행이 차지하는 행 범위 (0부터, 머리글 포함 기준).
/// 시트 파이차트의 데이터 범위로 쓴다.
class SummaryBlock {
  const SummaryBlock(this.title, this.total, this.startRow, this.endRow);

  final String title;
  final double total;
  final int startRow;

  /// 마지막 행 다음 (끝 미포함).
  final int endRow;
}

List<List<Object>> buildSummaryRows(
  AppLocalizations l,
  String home,
  List<Trip> trips,
  List<Expense> expenses,
) => buildSummary(l, home, trips, expenses).rows;

({List<List<Object>> rows, List<SummaryBlock> blocks}) buildSummary(
  AppLocalizations l,
  String home,
  List<Trip> trips,
  List<Expense> expenses,
) {
  final rows = <List<Object>>[summaryHeader(l, home)];
  final blocks = <SummaryBlock>[];
  for (final t in trips) {
    final totals = categoryTotals(
      expenses.where((e) => e.tripId == t.id),
      home,
    );
    final sum = totals.values.fold<double>(0, (s, v) => s + v);
    if (totals.isNotEmpty) {
      blocks.add(
        SummaryBlock(t.title, sum, rows.length, rows.length + totals.length),
      );
    }
    for (final entry in totals.entries) {
      rows.add([
        _text(t.title),
        entry.key.label(l),
        entry.value,
        sum == 0 ? 0 : (entry.value * 1000 / sum).round() / 10,
      ]);
    }
  }
  return (rows: rows, blocks: blocks);
}
