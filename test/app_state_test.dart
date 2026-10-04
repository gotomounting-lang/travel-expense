import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:travel_expense/data/expense_repository.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/services/exchange_rate_service.dart';
import 'package:travel_expense/services/google_account_service.dart';
import 'package:travel_expense/services/sheets_sync_service.dart';
import 'package:travel_expense/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  late ExpenseRepository repo;
  late bool online;
  late AppState state;

  setUp(() async {
    repo = await ExpenseRepository.open(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    online = true;
    final client = MockClient((req) async {
      if (!online) throw http.ClientException('offline');
      return http.Response(
        jsonEncode({
          'base': 'USD',
          'date': req.url.pathSegments.last,
          'rates': {'KRW': 1400.0},
        }),
        200,
      );
    });
    final account = GoogleAccountService();
    state = AppState(
      repository: repo,
      rates: ExchangeRateService(client: client, cache: repo),
      account: account,
      sync: SheetsSyncService(account),
    );
    await state.load();
  });
  tearDown(() => repo.close());

  test('여행과 지출을 저장하면 결제일 환율로 원화가 계산된다', () async {
    final trip = await state.saveTrip(
      title: ' 뉴욕 ',
      country: '미국',
      currency: 'usd',
      startDate: DateTime(2026, 9, 1, 15),
      endDate: DateTime(2026, 9, 7),
    );
    expect(trip.title, '뉴욕');
    expect(trip.currency, 'USD');
    expect(trip.startDate, DateTime(2026, 9, 1));

    final e = await state.saveExpense(
      tripId: trip.id,
      spentAt: DateTime(2026, 9, 2, 13),
      category: ExpenseCategory.food,
      currency: 'USD',
      amount: 12.5,
    );
    expect(e.krwAmount, 17500);
    expect(state.expensesFor(trip.id).single.krwRate, 1400);
  });

  test('오프라인에서도 저장되고, 연결되면 환율을 채운다', () async {
    final trip = await state.saveTrip(
      title: '뉴욕',
      country: '',
      currency: 'USD',
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2026, 9, 7),
    );
    online = false;
    final e = await state.saveExpense(
      tripId: trip.id,
      spentAt: DateTime(2026, 9, 3, 10),
      category: ExpenseCategory.transport,
      currency: 'USD',
      amount: 3,
    );
    expect(e.hasRate, isFalse);
    expect(state.expensesFor(trip.id).single.krwAmount, isNull);

    online = true;
    await state.refreshMissingRates();
    expect(state.expensesFor(trip.id).single.krwAmount, 4200);
  });

  test('여행을 지우면 지출도 함께 지워진다', () async {
    final trip = await state.saveTrip(
      title: '뉴욕',
      country: '',
      currency: 'USD',
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2026, 9, 7),
    );
    await state.saveExpense(
      tripId: trip.id,
      spentAt: DateTime(2026, 9, 3),
      category: ExpenseCategory.other,
      currency: 'USD',
      amount: 1,
    );
    await state.deleteTrip(trip.id);
    expect(state.trips, isEmpty);
    expect(await repo.expenses(), isEmpty);
  });
}
