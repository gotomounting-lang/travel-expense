// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Settings';

  @override
  String get newTrip => 'Bagong biyahe';

  @override
  String get editTrip => 'I-edit ang biyahe';

  @override
  String get deleteTrip => 'Burahin ang biyahe';

  @override
  String get tripTitle => 'Pangalan ng biyahe';

  @override
  String get tripTitleHint => 'hal. Tokyo family trip 2026';

  @override
  String get tripTitleRequired => 'Ilagay ang pangalan ng biyahe';

  @override
  String get countryOptional => 'Bansa/lungsod (opsyonal)';

  @override
  String get countryHint => 'hal. Tokyo, Japan';

  @override
  String get localCurrency => 'Lokal na pera';

  @override
  String get currency => 'Pera';

  @override
  String get tripPeriod => 'Petsa ng biyahe';

  @override
  String get save => 'I-save';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get delete => 'Burahin';

  @override
  String get deleteTripConfirmTitle => 'Burahin ang biyaheng ito?';

  @override
  String get deleteTripConfirmBody =>
      'Mabubura ang lahat ng gastos sa biyaheng ito at aalisin din sa iyong sheet sa susunod na sync.';

  @override
  String get totalSpent => 'Kabuuang gastos';

  @override
  String pendingRates(int count) {
    return '$count ang naghihintay ng exchange rate (hilahin pababa para i-refresh kapag online)';
  }

  @override
  String get firstExpenseHint => 'I-tap ang + para itala ang una mong gastos';

  @override
  String get addExpense => 'Magdagdag ng gastos';

  @override
  String get editExpense => 'I-edit ang gastos';

  @override
  String get ratePending => 'Hinihintay ang rate';

  @override
  String get amount => 'Halaga';

  @override
  String get amountRequired => 'Ilagay ang halaga';

  @override
  String get category => 'Kategorya';

  @override
  String get merchantOptional => 'Tindahan (opsyonal)';

  @override
  String get merchantHint => 'hal. Ichiran Ramen';

  @override
  String get paymentOptional => 'Paraan ng bayad (opsyonal)';

  @override
  String get paymentHint => 'hal. Visa card, cash';

  @override
  String get memoOptional => 'Tala (opsyonal)';

  @override
  String get checkingRate => 'Tinitingnan ang exchange rate…';

  @override
  String get rateUnavailable =>
      'Hindi makuha ang exchange rate ngayon. I-save muna, at iko-convert namin ito kapag online ka na.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (noong $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gastos',
      one: '1 gastos',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Gawin ang una mong biyahe';

  @override
  String get emptyBody =>
      'Kino-convert namin ang ginastos mo sa ibang bansa sa pera ng iyong bansa gamit ang rate sa araw ng bayad\nat itinatabi ito sa sarili mong Google Sheet.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Mag-sign in gamit ang iyong Google account at gagawa ng sheet na \"$fileName\" sa sarili mong Google Drive, na ina-update tuwing magtatala ka ng gastos. Ang sheet lang na ginawa ng app ang maa-access nito, at hindi kailanman ipinapadala ang iyong data sa aming mga server.';
  }

  @override
  String get connectGoogle => 'Ikonekta ang Google account';

  @override
  String get syncNow => 'I-save ngayon';

  @override
  String get openSheet => 'Buksan ang sheet';

  @override
  String get disconnect => 'Idiskonekta';

  @override
  String get rateInfoTitle => 'Tungkol sa exchange rate';

  @override
  String get rateInfoBody =>
      'Ang halaga sa pera ng iyong bansa ay batay sa reference rate sa araw ng bayad (European Central Bank, o pampublikong rate data para sa ibang pera). Sa weekend at holiday, ginagamit ang rate ng nakaraang araw ng trabaho. Maaaring bahagyang iba ang aktuwal na card bill dahil sa rate at bayarin ng card issuer.';

  @override
  String googleSignInError(String details) {
    return 'Error sa pag-sign in sa Google: $details';
  }

  @override
  String get syncSaved => 'Na-save sa sheet';

  @override
  String syncFailed(String details) {
    return 'Hindi ma-save sa sheet: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Hindi ka naka-sign in sa Google.';

  @override
  String get syncErrorNoPermission =>
      'Kailangan ng pahintulot sa Google Drive. Pakikonekta muli.';

  @override
  String get syncErrorExpired =>
      'Nag-expire na ang iyong Google sign-in. Pakikonekta muli.';

  @override
  String get language => 'Wika';

  @override
  String get languageSystem => 'Awtomatiko (ayon sa nasyonalidad)';

  @override
  String get catFood => 'Pagkain';

  @override
  String get catSnack => 'Meryenda/Café';

  @override
  String get catSouvenir => 'Pasalubong';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTransport => 'Transportasyon';

  @override
  String get catLodging => 'Tuluyan';

  @override
  String get catSightseeing => 'Pamamasyal';

  @override
  String get catOther => 'Iba pa';

  @override
  String get sourceManual => 'Manual';

  @override
  String get sourceReceipt => 'Resibo';

  @override
  String get sourceCard => 'Card alert';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Mga gastos';

  @override
  String get tabTrips => 'Mga biyahe';

  @override
  String get tabSummary => 'Buod';

  @override
  String get colTrip => 'Biyahe';

  @override
  String get colDate => 'Petsa';

  @override
  String get colTime => 'Oras';

  @override
  String get colCategory => 'Kategorya';

  @override
  String get colMerchant => 'Tindahan';

  @override
  String get colCurrency => 'Pera';

  @override
  String get colLocalAmount => 'Lokal na halaga';

  @override
  String get colRateDate => 'Petsa ng rate';

  @override
  String get colPayment => 'Bayad';

  @override
  String get colSource => 'Pinagmulan';

  @override
  String get colMemo => 'Tala';

  @override
  String get colRateSource => 'Pinagmulan ng rate';

  @override
  String get colCountry => 'Bansa';

  @override
  String get colStartDate => 'Simula';

  @override
  String get colEndDate => 'Katapusan';

  @override
  String get colCount => 'Bilang';

  @override
  String get colShare => 'Bahagi (%)';

  @override
  String get scanReceipt => 'I-scan ang resibo';

  @override
  String get pickReceipt => 'Resibo mula sa photos';

  @override
  String get enterManually => 'Manual na ilagay';

  @override
  String get readingReceipt => 'Binabasa ang resibo…';

  @override
  String get receiptReadNotice =>
      'Pinunan mula sa iyong resibo. Suriin at itama bago i-save. Binura na ang larawan pagkatapos suriin.';

  @override
  String get receiptNothingFound =>
      'Walang nakitang halaga sa resibo. Pakilagay nang manual. Binura na ang larawan.';

  @override
  String receiptScanFailed(String details) {
    return 'Hindi mabasa ang resibo: $details';
  }

  @override
  String get photoDeletedNote =>
      'Sinusuri ang mga larawan sa iyong device at agad binubura. Hindi kailanman sine-save o ina-upload ang mga ito.';

  @override
  String get cardAlertsSection => 'Awtomatikong itala ang card payment alert';

  @override
  String get cardAlertsBody =>
      'Kapag nagbayad ka gamit ang card sa ibang bansa, babasahin ang approval alert mula sa iyong card app (o messenger) at itatala ito sa biyahe sa petsang iyon. Ang mga approval alert lang na nasa foreign currency ang pinoproseso, sa iyong device. Hindi kailanman sine-save o ipinapadala kahit saan ang ibang notification.';

  @override
  String get cardAlertsOn => 'Naka-on';

  @override
  String get cardAlertsOff => 'Naka-off (kailangan ng notification access)';

  @override
  String get cardAlertsAllow => 'Payagan ang notification access';

  @override
  String get cardAlertsSettings => 'Buksan ang notification access settings';

  @override
  String get cardAlertsConsentTitle => 'Tungkol sa notification access';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Sa susunod na screen, payagan ang notification access para sa \"$appName\". Pipiliin lang ng app ang mga approval ng card payment sa ibang bansa mula sa iyong mga notification at itatala ang mga ito bilang gastos. Hindi kailanman lalabas sa iyong device ang laman ng notification, at puwede mo itong i-off anumang oras sa parehong setting.';
  }

  @override
  String get agreeAndContinue => 'Sumang-ayon at magpatuloy';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count card payment ang naghihintay',
      one: '1 card payment ang naghihintay',
    );
    return '$_temp0 ng biyaheng sakop ang petsa ng bayad. Gawin ang biyaheng iyon at awtomatiko silang maidaragdag.';
  }

  @override
  String get pasteCardAlert => 'I-paste ang text ng card alert';

  @override
  String get pasteCardAlertHint =>
      'I-paste ang approval alert na natanggap mo mula sa card app o SMS.';

  @override
  String get pasteCardAlertFailed =>
      'Hindi ito mabasa bilang approval ng bayad sa ibang bansa. Pakilagay nang manual.';

  @override
  String get cardReadNotice =>
      'Pinunan mula sa iyong card alert. Suriin at itama bago i-save.';

  @override
  String get read => 'Basahin';

  @override
  String get privacyPolicy => 'Patakaran sa privacy';

  @override
  String colHomeRate(String currency) {
    return 'Rate ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Halaga ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Kabuuan ($currency)';
  }

  @override
  String get noConvertedYet => 'Wala pang na-convert na gastos';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Nasyonalidad';

  @override
  String get chooseNationality => 'Piliin ang iyong nasyonalidad';

  @override
  String get nationalityBody =>
      'Iko-convert ang lahat ng gastos sa pera ng iyong bansa, at itutugma rin ang wika ng app. Puwede mo itong baguhin mamaya sa Settings.';

  @override
  String get searchCountry => 'Maghanap ng bansa';

  @override
  String get homeCurrency => 'Pera ng iyong bansa';

  @override
  String get welcomeTitle => 'Maligayang pagdating sa Travel Expense';

  @override
  String get welcomeBody =>
      'Ikonekta ang iyong Google account para awtomatikong ma-save ang iyong mga gastos sa isang sheet sa sarili mong Google Drive.';

  @override
  String get skipForNow => 'Hindi muna';

  @override
  String get next => 'Susunod';

  @override
  String get exportTripSheet => 'I-save sa Google Sheets';

  @override
  String get exportTripSheetSaving => 'Sine-save sa Google Sheets…';

  @override
  String exportTripSheetDone(String title) {
    return 'Na-save sa sheet na \'$title\'';
  }

  @override
  String get receiptTotalNotFound =>
      'Hindi makumpirma ang kabuuan sa resibo. Pakilagay mismo ang halaga at currency. Binura ang larawan pagkatapos ng pagsusuri.';

  @override
  String get receiptCurrencyNotFound =>
      'Hindi makumpirma ang currency sa resibo. Suriin ang halaga at piliin mismo ang currency. Binura ang larawan pagkatapos ng pagsusuri.';

  @override
  String get currencyRequired => 'Pumili ng currency';
}
