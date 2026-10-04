import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:travel_expense/data/expense_repository.dart';
import 'package:travel_expense/l10n/app_localizations.dart';
import 'package:travel_expense/models/trip.dart';
import 'package:travel_expense/services/exchange_rate_service.dart';
import 'package:travel_expense/services/google_account_service.dart';
import 'package:travel_expense/services/receipt_parser.dart';
import 'package:travel_expense/services/sheets_sync_service.dart';
import 'package:travel_expense/state/app_state.dart';
import 'package:travel_expense/ui/screens/batch_review_screen.dart';

void main() {
  sqfliteFfiInit();

  testWidgets('여러 건을 확인하고 기간 안의 건만 한 번에 저장한다', (tester) async {
    late AppState state;
    late Trip trip;
    await tester.runAsync(() async {
      await initializeDateFormatting();
      final repo = await ExpenseRepository.open(
        factory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      );
      final account = GoogleAccountService();
      state = AppState(
        repository: repo,
        rates: ExchangeRateService(
          client: MockClient((_) async => http.Response('', 503)),
        ),
        account: account,
        sync: SheetsSyncService(account),
        strings: () => lookupAppLocalizations(const Locale('ko')),
      );
      await state.load();
      trip = await state.saveTrip(
        title: '서울',
        country: 'KR',
        currency: 'KRW',
        startDate: DateTime(2026, 10, 1),
        endDate: DateTime(2026, 10, 4),
      );
    });

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp(
          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BatchReviewScreen(
            trip: trip,
            unreadable: 1,
            drafts: [
              ReceiptDraft(
                amount: 1700,
                currency: 'KRW',
                date: DateTime(2026, 10, 4, 17, 46),
                merchant: 'GS25길동오네뜨점',
              ),
              ReceiptDraft(
                amount: 7900,
                currency: 'KRW',
                date: DateTime(2026, 10, 4, 17, 36),
                merchant: '압구정샌드위치',
              ),
              ReceiptDraft(
                amount: 1000,
                currency: 'KRW',
                date: DateTime(2026, 9, 20, 9),
                merchant: '지난달 가게',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('결제 3건 읽음'), findsOneWidget);
    expect(find.textContaining('사진 1장에서 결제 건을 읽지 못했어요'), findsOneWidget);
    expect(find.textContaining('여행 기간 밖'), findsOneWidget);
    expect(find.text('선택한 2건 저장'), findsOneWidget);

    await tester.runAsync(() async {
      await tester.tap(find.text('선택한 2건 저장'));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pumpAndSettle();
    expect(state.expensesFor(trip.id).map((e) => e.amount).toList()..sort(), [
      1700,
      7900,
    ]);
  });
}
