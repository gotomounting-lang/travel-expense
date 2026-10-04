import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:travel_expense/data/expense_repository.dart';
import 'package:travel_expense/main.dart';
import 'package:travel_expense/services/exchange_rate_service.dart';
import 'package:travel_expense/services/google_account_service.dart';
import 'package:travel_expense/services/sheets_sync_service.dart';
import 'package:travel_expense/state/app_state.dart';

void main() {
  sqfliteFfiInit();

  testWidgets('여행을 만들면 상세 화면으로 이동한다', (tester) async {
    late AppState state;
    await tester.runAsync(() async {
      await initializeDateFormatting('ko_KR');
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
      );
      await state.load();
    });

    await tester.pumpWidget(TravelExpenseApp(state: state));
    expect(find.text('첫 여행을 만들어 보세요'), findsOneWidget);

    await tester.tap(find.text('새 여행'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '오사카');
    await tester.runAsync(() async {
      await tester.tap(find.text('저장'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();

    expect(find.text('총 지출'), findsOneWidget);
    expect(find.text('오사카'), findsOneWidget);
    expect(find.text('지출 추가'), findsOneWidget);
  });
}
