import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'data/expense_repository.dart';
import 'services/exchange_rate_service.dart';
import 'services/google_account_service.dart';
import 'services/sheets_sync_service.dart';
import 'state/app_state.dart';
import 'ui/screens/trip_list_screen.dart';

/// Google Cloud 콘솔에서 만든 "웹 애플리케이션" OAuth 클라이언트 ID.
/// `flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=...` 로 넣는다. (README 참고)
const _serverClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');

  final repository = await ExpenseRepository.open();
  final account = GoogleAccountService(
    serverClientId: _serverClientId.isEmpty ? null : _serverClientId,
  );
  final state = AppState(
    repository: repository,
    rates: ExchangeRateService(client: http.Client(), cache: repository),
    account: account,
    sync: SheetsSyncService(account),
  );
  await state.load();
  // 로그인 확인은 화면을 띄운 뒤 백그라운드에서 한다.
  account.init();

  runApp(TravelExpenseApp(state: state));
}

class TravelExpenseApp extends StatelessWidget {
  const TravelExpenseApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: state),
        ChangeNotifierProvider.value(value: state.account),
      ],
      child: MaterialApp(
        title: '여행 경비',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ko', 'KR'),
        supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
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
    );
  }
}
