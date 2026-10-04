import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'data/expense_repository.dart';
import 'l10n/app_localizations.dart';
import 'services/card_notification_source.dart';
import 'services/exchange_rate_service.dart';
import 'services/google_account_service.dart';
import 'services/receipt_scanner.dart';
import 'services/sheets_sync_service.dart';
import 'state/app_state.dart';
import 'state/locale_controller.dart';
import 'ui/screens/trip_list_screen.dart';

/// Google Cloud 콘솔에서 만든 "웹 애플리케이션" OAuth 클라이언트 ID.
/// `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=...` 로 넣는다. (README 참고)
const _serverClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final locale = LocaleController();
  await locale.load();

  final repository = await ExpenseRepository.open();
  final account = GoogleAccountService(
    serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
  );
  final state = AppState(
    repository: repository,
    rates: ExchangeRateService(client: http.Client(), cache: repository),
    account: account,
    sync: SheetsSyncService(account),
    strings: () => locale.strings,
    cardNotifications: CardNotificationSource(),
  );
  await state.load();
  // 언어를 바꾸면 시트 머리글·탭 이름도 그 언어로 다시 쓴다.
  locale.addListener(state.syncNow);
  // 로그인 확인은 화면을 띄운 뒤 백그라운드에서 한다.
  account.init();

  // 카드 결제 알림: 앱을 열 때, 다시 돌아올 때, 켜져 있는 동안 새로 올 때 기록한다.
  state.importCardNotifications();
  AppLifecycleListener(onResume: state.importCardNotifications);
  state.cardNotifications.onNew.listen((_) => state.importCardNotifications());

  runApp(TravelExpenseApp(state: state, locale: locale));
}

class TravelExpenseApp extends StatelessWidget {
  const TravelExpenseApp({
    super.key,
    required this.state,
    required this.locale,
    this.scanner,
  });

  final AppState state;
  final LocaleController locale;
  final ReceiptScanner? scanner;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        ChangeNotifierProvider.value(value: state.account),
        ChangeNotifierProvider.value(value: locale),
        Provider<ReceiptScanner>(create: (_) => scanner ?? ReceiptScanner()),
      ],
      child: Consumer<LocaleController>(
        builder: (context, locale, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          // null 이면 기기 언어를 따르고, 지원하지 않는 언어면 한국어.
          locale: locale.selected,
          localeListResolutionCallback: (deviceLocales, _) =>
              LocaleController.resolve(deviceLocales),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFF2E86AB),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorSchemeSeed: const Color(0xFF2E86AB),
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          home: const TripListScreen(),
        ),
      ),
    );
  }
}
