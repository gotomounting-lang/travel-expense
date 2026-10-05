import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/l10n/app_localizations.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/models/expense.dart';
import 'package:travel_expense/models/trip.dart';
import 'package:travel_expense/services/sheet_rows.dart';

void main() {
  final ko = lookupAppLocalizations(const Locale('ko'));
  final en = lookupAppLocalizations(const Locale('en'));
  final trip = Trip(
    id: 't1',
    title: '=도쿄 여행',
    country: '일본',
    currency: 'JPY',
    startDate: DateTime(2026, 10, 1),
    endDate: DateTime(2026, 10, 5),
  );
  Expense exp(
    String id,
    DateTime at,
    ExpenseCategory c,
    double amount, {
    double? rate,
  }) => Expense(
    id: id,
    tripId: 't1',
    spentAt: at,
    category: c,
    currency: 'JPY',
    amount: amount,
    homeRate: rate,
    rateDate: rate == null ? null : DateTime(2026, 10, 2),
    rateSource: rate == null ? null : 'ECB(frankfurter)',
  );

  final expenses = [
    exp(
      'b',
      DateTime(2026, 10, 3, 19, 5),
      ExpenseCategory.food,
      1200,
      rate: 9.4,
    ),
    exp(
      'a',
      DateTime(2026, 10, 2, 9, 30),
      ExpenseCategory.souvenir,
      3000,
      rate: 9.4,
    ),
    exp('c', DateTime(2026, 10, 4, 12), ExpenseCategory.food, 800),
  ];

  test('내역 탭: 헤더, 시간순 정렬, 원화 계산, 환율 없는 행은 빈칸', () {
    final rows = buildExpenseRows(ko, 'KRW', [trip], expenses);
    expect(rows.first, expenseHeader(ko, 'KRW'));
    expect(rows.first.first, '여행');
    expect(rows.skip(1).map((r) => r.last), ['a', 'b', 'c']);
    final a = rows[1];
    expect(a[0], "'=도쿄 여행", reason: '수식으로 해석되지 않게 escape');
    expect(a.sublist(1, 4), ['2026-10-02', '09:30', '기념품']);
    expect(a[9], 28200);
    final c = rows[3];
    expect(c[7], '');
    expect(c[9], '');
  });

  test('여행 탭: 원화 합계와 건수', () {
    final rows = buildTripRows(ko, 'KRW', [trip], expenses);
    expect(rows.first, isNot(contains('통화')), reason: '여행 통화는 쓰지 않는다');
    expect(rows[1][4], 28200 + 11280);
    expect(rows[1][5], 3);
  });

  test('요약 탭: 카테고리별 합계는 큰 순서, 비율은 소수 첫째 자리', () {
    final rows = buildSummaryRows(ko, 'KRW', [trip], expenses);
    expect(rows.length, 4);
    expect(rows[1].sublist(1, 4), ['기념품', 28200, 71.4]);
    expect(rows[2].sublist(1, 4), ['음식', 11280, 28.6]);
    expect(rows[1][4], '기념품  28,200원', reason: '차트 범례에 금액이 보이게');
    expect(rows[3].sublist(1), ['총 지출', 28200 + 11280, 100, '']);
  });

  test('시트 머리글과 카테고리는 고른 언어로 쓴다', () {
    final rows = buildExpenseRows(en, 'KRW', [trip], expenses);
    expect(rows.first.take(4), ['Trip', 'Date', 'Time', 'Category']);
    expect(rows[1][3], 'Souvenirs');
    expect(rows.first, contains('Rate (KRW)'));
    expect(SheetTab.expenses.title(en), 'Expenses');
    expect(
      SheetTab.values.map((t) => t.sheetId).toSet(),
      hasLength(3),
      reason: '언어가 바뀌어도 탭은 sheetId 로 찾는다',
    );
  });

  test('다른 통화로 환산된 지출은 지금 환산 통화 합계에 섞지 않는다', () {
    final usd = expenses.first.copyWith(homeCurrency: 'USD');
    final rows = buildSummaryRows(
      ko,
      'KRW',
      [trip],
      [usd, ...expenses.skip(1)],
    );
    expect(rows.length, 3);
    expect(rows[1].sublist(1, 4), ['기념품', 28200.0, 100.0]);
    expect(rows[2].sublist(1), ['총 지출', 28200.0, 100, '']);
  });

  test('요약 블록: 시트 파이차트가 쓸 여행별 행 범위', () {
    final other = Trip(
      id: 't2',
      title: '빈 여행',
      currency: 'USD',
      startDate: DateTime(2026, 11, 1),
      endDate: DateTime(2026, 11, 2),
    );
    final s = buildSummary(ko, 'KRW', [trip, other], expenses);
    expect(s.blocks, hasLength(1), reason: '원화 지출이 없는 여행은 차트를 만들지 않는다');
    expect(s.blocks.single.startRow, 1);
    expect(s.blocks.single.endRow, 3, reason: '총 지출 줄은 차트에 넣지 않는다');
    expect(s.rows[3][1], '총 지출');
    expect(s.blocks.single.total, 28200 + 11280);
    expect(s.blocks.single.categories, [
      ExpenseCategory.souvenir,
      ExpenseCategory.food,
    ]);
  });
}
