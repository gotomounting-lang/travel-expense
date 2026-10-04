import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/models/expense.dart';
import 'package:travel_expense/models/trip.dart';
import 'package:travel_expense/services/sheet_rows.dart';

void main() {
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
    krwRate: rate,
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
    final rows = buildExpenseRows([trip], expenses);
    expect(rows.first, expenseHeader);
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
    final rows = buildTripRows([trip], expenses);
    expect(rows[1][5], 28200 + 11280);
    expect(rows[1][6], 3);
  });

  test('요약 탭: 카테고리별 합계는 큰 순서, 비율은 소수 첫째 자리', () {
    final rows = buildSummaryRows([trip], expenses);
    expect(rows.length, 3);
    expect(rows[1].sublist(1), ['기념품', 28200, 71.4]);
    expect(rows[2].sublist(1), ['음식', 11280, 28.6]);
  });
}
