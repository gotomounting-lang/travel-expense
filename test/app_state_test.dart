import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:travel_expense/data/expense_repository.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/models/expense.dart';
import 'package:travel_expense/services/card_notification_parser.dart';
import 'package:travel_expense/services/card_notification_source.dart';
import 'package:travel_expense/services/exchange_rate_service.dart';
import 'package:travel_expense/services/google_account_service.dart';
import 'package:travel_expense/services/sheets_sync_service.dart';
import 'package:travel_expense/state/app_state.dart';

class FakeCardSource extends CardNotificationSource {
  FakeCardSource() : super(supported: true);

  final items = <CardNotification>[];

  @override
  Future<List<CardNotification>> pending() async => List.of(items);

  @override
  Future<void> remove(Iterable<String> ids) async {
    final set = ids.toSet();
    items.removeWhere((n) => set.contains(n.id));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  late ExpenseRepository repo;
  late bool online;
  late AppState state;
  late FakeCardSource cards;

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
    cards = FakeCardSource();
    state = AppState(
      cardNotifications: cards,
      repository: repo,
      rates: ExchangeRateService(client: client, cache: repo),
      account: account,
      sync: SheetsSyncService(account),
      strings: () => lookupAppLocalizations(const Locale('ko')),
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

  test('카드 알림: 결제일의 여행에 기록하고, 중복·비결제 알림은 버리고, 여행이 없으면 기다린다', () async {
    final trip = await state.saveTrip(
      title: '뉴욕',
      country: '',
      currency: 'USD',
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2026, 9, 7),
    );
    CardNotification n(String id, String text, DateTime at) =>
        CardNotification(id: id, text: text, postedAt: at);
    cards.items.addAll([
      n(
        'a',
        '신한카드(1234)승인 홍*동 12.50USD 09/02 STARBUCKS',
        DateTime(2026, 9, 2, 9),
      ),
      // 같은 결제가 알림톡으로 한 번 더 온 경우
      n('b', '[신한카드] 해외승인 USD 12.50 STARBUCKS', DateTime(2026, 9, 2, 9, 1)),
      n('c', '단체방: 오늘 승인 났어요 ㅎㅎ', DateTime(2026, 9, 2, 10)),
      // 여행 기간 밖
      n('d', 'KB국민카드1234승인 EUR 30.00 LOUVRE', DateTime(2026, 10, 20, 11)),
    ]);

    await state.importCardNotifications();
    final saved = state.expensesFor(trip.id);
    expect(saved, hasLength(1));
    expect(saved.single.source, ExpenseSource.cardNotification);
    expect(saved.single.paymentMethod, '신한카드(1234)');
    expect(saved.single.krwAmount, 17500);
    expect(cards.items.map((i) => i.id), ['d']);
    expect(state.waitingCardPayments, 1);

    // 그 기간의 여행을 만들면 기다리던 결제가 들어간다.
    final paris = await state.saveTrip(
      title: '파리',
      country: '',
      currency: 'EUR',
      startDate: DateTime(2026, 10, 18),
      endDate: DateTime(2026, 10, 25),
    );
    await state.importCardNotifications();
    expect(state.expensesFor(paris.id).single.merchant, 'LOUVRE');
    expect(cards.items, isEmpty);
    expect(state.waitingCardPayments, 0);
  });
}
