import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../util/dates.dart';

/// 구글 시트에 쓰는 표 내용을 만든다. 순수 함수라 테스트하기 쉽다.
class SheetTabs {
  static const expenses = '내역';
  static const trips = '여행';
  static const summary = '요약';
  static const all = [expenses, trips, summary];
}

const expenseHeader = [
  '여행',
  '날짜',
  '시간',
  '카테고리',
  '가맹점',
  '통화',
  '현지금액',
  '적용환율(원)',
  '환율기준일',
  '원화금액',
  '결제수단',
  '입력방식',
  '메모',
  '환율출처',
  'ID',
];

const tripHeader = ['여행', '국가', '통화', '시작일', '종료일', '원화합계', '건수', 'ID'];

const summaryHeader = ['여행', '카테고리', '원화합계', '비율(%)'];

final _hm = DateFormat('HH:mm');

/// USER_ENTERED 로 쓸 때 사용자가 입력한 글자가 수식으로 해석되지 않게 막는다.
Object _text(String s) => s.isNotEmpty && '=+-@'.contains(s[0]) ? "'$s" : s;

List<List<Object>> buildExpenseRows(List<Trip> trips, List<Expense> expenses) {
  final titles = {for (final t in trips) t.id: t.title};
  final sorted = [...expenses]..sort((a, b) => a.spentAt.compareTo(b.spentAt));
  return [
    expenseHeader,
    for (final e in sorted)
      [
        _text(titles[e.tripId] ?? ''),
        formatYmd(e.spentAt),
        _hm.format(e.spentAt),
        e.category.label,
        _text(e.merchant),
        e.currency,
        e.amount,
        e.krwRate ?? '',
        e.rateDate == null ? '' : formatYmd(e.rateDate!),
        e.krwAmount ?? '',
        _text(e.paymentMethod),
        e.source.label,
        _text(e.memo),
        e.rateSource ?? '',
        e.id,
      ],
  ];
}

List<List<Object>> buildTripRows(List<Trip> trips, List<Expense> expenses) {
  return [
    tripHeader,
    for (final t in trips)
      () {
        final mine = expenses.where((e) => e.tripId == t.id);
        return <Object>[
          _text(t.title),
          _text(t.country),
          t.currency,
          formatYmd(t.startDate),
          formatYmd(t.endDate),
          mine.fold<int>(0, (s, e) => s + (e.krwAmount ?? 0)),
          mine.length,
          t.id,
        ];
      }(),
  ];
}

/// 여행별 카테고리 원화 합계. 앱 파이차트와 같은 계산을 쓴다.
Map<ExpenseCategory, int> categoryTotals(Iterable<Expense> expenses) {
  final totals = <ExpenseCategory, int>{};
  for (final e in expenses) {
    final krw = e.krwAmount;
    if (krw == null) continue;
    totals[e.category] = (totals[e.category] ?? 0) + krw;
  }
  return Map.fromEntries(
    totals.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
  );
}

List<List<Object>> buildSummaryRows(List<Trip> trips, List<Expense> expenses) {
  final rows = <List<Object>>[summaryHeader];
  for (final t in trips) {
    final totals = categoryTotals(expenses.where((e) => e.tripId == t.id));
    final sum = totals.values.fold<int>(0, (s, v) => s + v);
    for (final entry in totals.entries) {
      rows.add([
        _text(t.title),
        entry.key.label,
        entry.value,
        sum == 0 ? 0 : (entry.value * 1000 / sum).round() / 10,
      ]);
    }
  }
  return rows;
}
