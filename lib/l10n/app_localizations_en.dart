// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Settings';

  @override
  String get newTrip => 'New trip';

  @override
  String get editTrip => 'Edit trip';

  @override
  String get deleteTrip => 'Delete trip';

  @override
  String get tripTitle => 'Trip name';

  @override
  String get tripTitleHint => 'e.g. Tokyo family trip 2026';

  @override
  String get tripTitleRequired => 'Please enter a trip name';

  @override
  String get countryOptional => 'Country/city (optional)';

  @override
  String get countryHint => 'e.g. Tokyo, Japan';

  @override
  String get localCurrency => 'Local currency';

  @override
  String get currency => 'Currency';

  @override
  String get tripPeriod => 'Trip dates';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteTripConfirmTitle => 'Delete this trip?';

  @override
  String get deleteTripConfirmBody =>
      'All expenses in this trip will be deleted and removed from your sheet at the next sync.';

  @override
  String get totalSpent => 'Total spent';

  @override
  String pendingRates(int count) {
    return '$count waiting for exchange rate (pull down to refresh when online)';
  }

  @override
  String get firstExpenseHint => 'Tap + to record your first expense';

  @override
  String get addExpense => 'Add expense';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get ratePending => 'Rate pending';

  @override
  String get amount => 'Amount';

  @override
  String get amountRequired => 'Please enter an amount';

  @override
  String get category => 'Category';

  @override
  String get merchantOptional => 'Merchant (optional)';

  @override
  String get merchantHint => 'e.g. Ichiran Ramen';

  @override
  String get paymentOptional => 'Payment method (optional)';

  @override
  String get paymentHint => 'e.g. Visa card, cash';

  @override
  String get memoOptional => 'Note (optional)';

  @override
  String get checkingRate => 'Checking exchange rate…';

  @override
  String get rateUnavailable =>
      'Can\'t get the exchange rate right now. Save it and we\'ll convert it once you\'re online.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (as of $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Create your first trip';

  @override
  String get emptyBody =>
      'We convert what you spend abroad into your home currency at the rate of the payment date\nand keep it in your own Google Sheet.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Sign in with your Google account and a \"$fileName\" sheet is created in your own Google Drive, updated every time you record an expense. The app can only access the sheet it created, and your data is never sent to our servers.';
  }

  @override
  String get connectGoogle => 'Connect Google account';

  @override
  String get syncNow => 'Save now';

  @override
  String get openSheet => 'Open sheet';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get rateInfoTitle => 'About exchange rates';

  @override
  String get rateInfoBody =>
      'Amounts in your home currency use the reference rate of the payment date (European Central Bank, or public rate data for other currencies). Weekends and holidays use the previous business day. Your actual card bill may differ slightly due to the card issuer\'s rate and fees.';

  @override
  String googleSignInError(String details) {
    return 'Google sign-in error: $details';
  }

  @override
  String get syncSaved => 'Saved to sheet';

  @override
  String syncFailed(String details) {
    return 'Couldn\'t save to sheet: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'You\'re not signed in to Google.';

  @override
  String get syncErrorNoPermission =>
      'Google Drive permission is needed. Please reconnect.';

  @override
  String get syncErrorExpired =>
      'Your Google sign-in expired. Please reconnect.';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Automatic (by nationality)';

  @override
  String get catFood => 'Food';

  @override
  String get catSnack => 'Snacks/Cafe';

  @override
  String get catSouvenir => 'Souvenirs';

  @override
  String get catShopping => 'Shopping';

  @override
  String get catTransport => 'Transport';

  @override
  String get catLodging => 'Lodging';

  @override
  String get catSightseeing => 'Sightseeing';

  @override
  String get catOther => 'Other';

  @override
  String get sourceManual => 'Manual';

  @override
  String get sourceReceipt => 'Receipt';

  @override
  String get sourceCard => 'Card alert';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Expenses';

  @override
  String get tabTrips => 'Trips';

  @override
  String get tabSummary => 'Summary';

  @override
  String get colTrip => 'Trip';

  @override
  String get colDate => 'Date';

  @override
  String get colTime => 'Time';

  @override
  String get colCategory => 'Category';

  @override
  String get colMerchant => 'Merchant';

  @override
  String get colCurrency => 'Currency';

  @override
  String get colLocalAmount => 'Local amount';

  @override
  String get colRateDate => 'Rate date';

  @override
  String get colPayment => 'Payment';

  @override
  String get colSource => 'Source';

  @override
  String get colMemo => 'Note';

  @override
  String get colRateSource => 'Rate source';

  @override
  String get colCountry => 'Country';

  @override
  String get colStartDate => 'Start';

  @override
  String get colEndDate => 'End';

  @override
  String get colCount => 'Count';

  @override
  String get colShare => 'Share (%)';

  @override
  String get scanReceipt => 'Scan receipt';

  @override
  String get pickReceipt => 'Receipt from photos';

  @override
  String get enterManually => 'Enter manually';

  @override
  String get readingReceipt => 'Reading receipt…';

  @override
  String get receiptReadNotice =>
      'Filled in from your receipt. Check and fix before saving. The photo was deleted after analysis.';

  @override
  String get receiptNothingFound =>
      'Couldn\'t find an amount on the receipt. Please enter it manually. The photo was deleted.';

  @override
  String receiptScanFailed(String details) {
    return 'Couldn\'t read the receipt: $details';
  }

  @override
  String get photoDeletedNote =>
      'Photos are analyzed on your device and deleted right away. They are never stored or uploaded.';

  @override
  String get cardAlertsSection => 'Auto-record card payment alerts';

  @override
  String get cardAlertsBody =>
      'When you pay abroad by card, the approval alert from your card app (or messenger) is read and recorded in the trip for that date. Only foreign-currency approval alerts are processed, on your device. Other notifications are never stored or sent anywhere.';

  @override
  String get cardAlertsOn => 'On';

  @override
  String get cardAlertsOff => 'Off (notification access needed)';

  @override
  String get cardAlertsAllow => 'Allow notification access';

  @override
  String get cardAlertsSettings => 'Open notification access settings';

  @override
  String get cardAlertsConsentTitle => 'About notification access';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'On the next screen, allow notification access for \"$appName\". The app will pick out only foreign card payment approvals from your notifications and record them as expenses. Notification content never leaves your device, and you can turn this off anytime in the same setting.';
  }

  @override
  String get agreeAndContinue => 'Agree and continue';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count card payments are',
      one: '1 card payment is',
    );
    return '$_temp0 waiting for a trip that covers the payment date. Create that trip and they\'ll be added automatically.';
  }

  @override
  String get pasteCardAlert => 'Paste card alert text';

  @override
  String get pasteCardAlertHint =>
      'Paste the approval alert you got from your card app or SMS.';

  @override
  String get pasteCardAlertFailed =>
      'Couldn\'t read this as a foreign payment approval. Please enter it manually.';

  @override
  String get cardReadNotice =>
      'Filled in from your card alert. Check and fix before saving.';

  @override
  String get read => 'Read';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String colHomeRate(String currency) {
    return 'Rate ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Amount ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Total ($currency)';
  }

  @override
  String get noConvertedYet => 'No converted expenses yet';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Nationality';

  @override
  String get chooseNationality => 'Select your nationality';

  @override
  String get nationalityBody =>
      'All spending will be converted into your country\'s currency, and the app language will match. You can change this later in Settings.';

  @override
  String get searchCountry => 'Search country';

  @override
  String get homeCurrency => 'Home currency';

  @override
  String get welcomeTitle => 'Welcome to Travel Expense';

  @override
  String get welcomeBody =>
      'Connect your Google account to save your expenses automatically to a sheet in your own Google Drive.';

  @override
  String get skipForNow => 'Not now';

  @override
  String get next => 'Next';

  @override
  String get exportTripSheet => 'Save to Google Sheets';

  @override
  String get exportTripSheetSaving => 'Saving to Google Sheets…';

  @override
  String exportTripSheetDone(String title) {
    return 'Saved to the \'$title\' sheet';
  }

  @override
  String get receiptTotalNotFound =>
      'Couldn\'t confirm the total on this receipt. Please enter the amount and currency yourself. The photo was deleted after analysis.';

  @override
  String get receiptCurrencyNotFound =>
      'Couldn\'t confirm the currency on this receipt. Check the amount and choose the currency yourself. The photo was deleted after analysis.';

  @override
  String get currencyRequired => 'Choose a currency';

  @override
  String batchTitle(int count) {
    return '$count payments found';
  }

  @override
  String get batchHint => 'Choose which to save. Tap an amount to edit it.';

  @override
  String batchSave(int count) {
    return 'Save $count selected';
  }

  @override
  String batchSaved(int count) {
    return 'Saved $count expenses';
  }

  @override
  String get batchOutsideTrip => 'Outside trip dates';

  @override
  String get batchDuplicate => 'Already saved';

  @override
  String get batchNeedsInput => 'Check amount/currency · tap the amount';

  @override
  String get scanIncomplete =>
      'Some payments couldn\'t be read. Please enter each payment manually.';
}
