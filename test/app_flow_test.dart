import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:travel_expense/data/expense_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_expense/main.dart';
import 'package:travel_expense/models/country.dart';
import 'package:travel_expense/services/exchange_rate_service.dart';
import 'package:travel_expense/services/google_account_service.dart';
import 'package:travel_expense/services/sheets_sync_service.dart';
import 'package:travel_expense/state/app_state.dart';
import 'package:travel_expense/state/locale_controller.dart';
import 'package:travel_expense/state/user_profile.dart';

void main() {
  sqfliteFfiInit();

  testWidgets('여행을 만들면 상세 화면으로 이동한다', (tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ko', 'KR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    late AppState state;
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
    });

    final profile = UserProfile(initial: Country.byCode('KR'));
    await tester.pumpWidget(
      TravelExpenseApp(
        state: state,
        profile: profile,
        locale: LocaleController(
          deviceLocales: () => const [Locale('ko')],
          profile: profile,
        ),
      ),
    );
    expect(find.text('첫 여행을 만들어 보세요'), findsOneWidget);

    await tester.tap(find.text('새 여행'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, '오사카');
    // 여행 통화는 묻지 않는다 (지출마다 영수증 통화로 정한다).
    expect(find.byType(DropdownButtonFormField<String>), findsNothing);
    await tester.runAsync(() async {
      await tester.tap(find.text('저장'));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();

    expect(find.text('총 지출'), findsOneWidget);
    expect(find.text('오사카'), findsOneWidget);
    expect(find.text('지출 추가'), findsOneWidget);
  });

  testWidgets('국적을 고르기 전 첫 화면: 기기(플레이스토어) 언어를 따르고, 지원하지 않는 언어면 한국어', (
    tester,
  ) async {
    late AppState state;
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
    });
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    tester.platformDispatcher.localesTestValue = const [Locale('ja', 'JP')];
    final profile = UserProfile();
    await tester.pumpWidget(
      TravelExpenseApp(
        state: state,
        profile: profile,
        locale: LocaleController(profile: profile),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('旅行経費へようこそ'), findsOneWidget);

    tester.platformDispatcher.localesTestValue = const [Locale('vi', 'VN')];
    await tester.pumpAndSettle();
    expect(find.text('Chào mừng đến với Travel Expense'), findsOneWidget);

    tester.platformDispatcher.localesTestValue = const [Locale('th', 'TH')];
    await tester.pumpAndSettle();
    expect(find.text('여행 경비에 오신 것을 환영합니다'), findsOneWidget);
  });

  testWidgets('로그인 다음에 국적을 고르면 그 나라 언어로 바뀐다 (앱이 지원하지 않는 나라 말이면 기기 언어)', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.platformDispatcher.localesTestValue = const [Locale('ko', 'KR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    late AppState state;
    final profile = UserProfile();
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
        homeCurrency: () => profile.homeCurrency,
      );
      await state.load();
    });
    final locale = LocaleController(profile: profile);
    await tester.pumpWidget(
      TravelExpenseApp(state: state, profile: profile, locale: locale),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('나중에 하기'));
    await tester.pumpAndSettle();
    expect(find.text('국적을 선택하세요'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '프랑스');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, '프랑스'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(profile.homeCurrency, 'EUR');
    expect(locale.current, const Locale('fr'));
    expect(find.text('Nouveau voyage'), findsOneWidget);

    // 앱이 말을 지원하지 않는 나라(태국)면 기기 언어(한국어)를 쓴다.
    await tester.runAsync(() => profile.setCountry(Country.byCode('TH')!));
    await tester.pumpAndSettle();
    expect(find.text('새 여행'), findsOneWidget);

    await tester.runAsync(() => profile.setCountry(Country.byCode('GB')!));
    await tester.pumpAndSettle();
    expect(find.text('New trip'), findsOneWidget);

    await tester.runAsync(() => profile.setCountry(Country.byCode('TW')!));
    await tester.pumpAndSettle();
    expect(find.text('新建旅行'), findsOneWidget);

    await tester.runAsync(() => profile.setCountry(Country.byCode('JP')!));
    await tester.pumpAndSettle();
    expect(find.text('新しい旅行'), findsOneWidget);
  });
}
