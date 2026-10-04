// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get newTrip => 'नई यात्रा';

  @override
  String get editTrip => 'यात्रा बदलें';

  @override
  String get deleteTrip => 'यात्रा हटाएं';

  @override
  String get tripTitle => 'यात्रा का नाम';

  @override
  String get tripTitleHint => 'जैसे: टोक्यो फ़ैमिली ट्रिप 2026';

  @override
  String get tripTitleRequired => 'कृपया यात्रा का नाम डालें';

  @override
  String get countryOptional => 'देश/शहर (वैकल्पिक)';

  @override
  String get countryHint => 'जैसे: टोक्यो, जापान';

  @override
  String get localCurrency => 'स्थानीय मुद्रा';

  @override
  String get currency => 'मुद्रा';

  @override
  String get tripPeriod => 'यात्रा की तारीखें';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get deleteTripConfirmTitle => 'यह यात्रा हटाएं?';

  @override
  String get deleteTripConfirmBody =>
      'इस यात्रा के सभी खर्च हटा दिए जाएंगे और अगली सिंक पर आपकी शीट से भी निकाल दिए जाएंगे।';

  @override
  String get totalSpent => 'कुल खर्च';

  @override
  String pendingRates(int count) {
    return '$count विनिमय दर की प्रतीक्षा में (ऑनलाइन होने पर रीफ़्रेश के लिए नीचे खींचें)';
  }

  @override
  String get firstExpenseHint =>
      'अपना पहला खर्च दर्ज करने के लिए + पर टैप करें';

  @override
  String get addExpense => 'खर्च जोड़ें';

  @override
  String get editExpense => 'खर्च बदलें';

  @override
  String get ratePending => 'दर बाकी है';

  @override
  String get amount => 'राशि';

  @override
  String get amountRequired => 'कृपया राशि डालें';

  @override
  String get category => 'श्रेणी';

  @override
  String get merchantOptional => 'दुकान/व्यापारी (वैकल्पिक)';

  @override
  String get merchantHint => 'जैसे: Ichiran Ramen';

  @override
  String get paymentOptional => 'भुगतान का तरीका (वैकल्पिक)';

  @override
  String get paymentHint => 'जैसे: Visa कार्ड, नकद';

  @override
  String get memoOptional => 'नोट (वैकल्पिक)';

  @override
  String get checkingRate => 'विनिमय दर देखी जा रही है…';

  @override
  String get rateUnavailable =>
      'अभी विनिमय दर नहीं मिल पा रही है। इसे सेव कर लें, ऑनलाइन होने पर हम इसे बदल देंगे।';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home ($date के अनुसार)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count खर्च',
      one: '1 खर्च',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'अपनी पहली यात्रा बनाएं';

  @override
  String get emptyBody =>
      'विदेश में किए गए खर्च को भुगतान की तारीख की दर से आपकी अपनी मुद्रा में बदलकर\nआपकी अपनी Google Sheet में रखा जाता है।';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'अपने Google खाते से साइन इन करें, आपकी अपनी Google Drive में \"$fileName\" शीट बन जाएगी और हर बार खर्च दर्ज करने पर अपडेट होगी। ऐप सिर्फ़ अपनी बनाई शीट तक ही पहुंच सकता है, और आपका डेटा कभी हमारे सर्वर पर नहीं भेजा जाता।';
  }

  @override
  String get connectGoogle => 'Google खाता जोड़ें';

  @override
  String get syncNow => 'अभी सेव करें';

  @override
  String get openSheet => 'शीट खोलें';

  @override
  String get disconnect => 'डिस्कनेक्ट करें';

  @override
  String get rateInfoTitle => 'विनिमय दरों के बारे में';

  @override
  String get rateInfoBody =>
      'आपकी मुद्रा में राशि भुगतान की तारीख की संदर्भ दर से निकाली जाती है (यूरोपीय सेंट्रल बैंक, या अन्य मुद्राओं के लिए सार्वजनिक दर डेटा)। सप्ताहांत और छुट्टियों पर पिछले कामकाजी दिन की दर ली जाती है। कार्ड जारीकर्ता की दर और शुल्क के कारण आपका असली कार्ड बिल थोड़ा अलग हो सकता है।';

  @override
  String googleSignInError(String details) {
    return 'Google साइन-इन में त्रुटि: $details';
  }

  @override
  String get syncSaved => 'शीट में सेव हो गया';

  @override
  String syncFailed(String details) {
    return 'शीट में सेव नहीं हो सका: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'आप Google में साइन इन नहीं हैं।';

  @override
  String get syncErrorNoPermission =>
      'Google Drive की अनुमति चाहिए। कृपया फिर से कनेक्ट करें।';

  @override
  String get syncErrorExpired =>
      'आपका Google साइन-इन समाप्त हो गया है। कृपया फिर से कनेक्ट करें।';

  @override
  String get language => 'भाषा';

  @override
  String get languageSystem => 'स्वचालित (राष्ट्रीयता के अनुसार)';

  @override
  String get catFood => 'खाना';

  @override
  String get catSnack => 'नाश्ता/कैफ़े';

  @override
  String get catSouvenir => 'स्मृति-चिह्न';

  @override
  String get catShopping => 'शॉपिंग';

  @override
  String get catTransport => 'यातायात';

  @override
  String get catLodging => 'ठहरना';

  @override
  String get catSightseeing => 'घूमना-फिरना';

  @override
  String get catOther => 'अन्य';

  @override
  String get sourceManual => 'मैन्युअल';

  @override
  String get sourceReceipt => 'रसीद';

  @override
  String get sourceCard => 'कार्ड अलर्ट';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'खर्च';

  @override
  String get tabTrips => 'यात्राएं';

  @override
  String get tabSummary => 'सारांश';

  @override
  String get colTrip => 'यात्रा';

  @override
  String get colDate => 'तारीख';

  @override
  String get colTime => 'समय';

  @override
  String get colCategory => 'श्रेणी';

  @override
  String get colMerchant => 'व्यापारी';

  @override
  String get colCurrency => 'मुद्रा';

  @override
  String get colLocalAmount => 'स्थानीय राशि';

  @override
  String get colRateDate => 'दर की तारीख';

  @override
  String get colPayment => 'भुगतान';

  @override
  String get colSource => 'स्रोत';

  @override
  String get colMemo => 'नोट';

  @override
  String get colRateSource => 'दर का स्रोत';

  @override
  String get colCountry => 'देश';

  @override
  String get colStartDate => 'शुरुआत';

  @override
  String get colEndDate => 'अंत';

  @override
  String get colCount => 'संख्या';

  @override
  String get colShare => 'हिस्सा (%)';

  @override
  String get scanReceipt => 'रसीद स्कैन करें';

  @override
  String get pickReceipt => 'फ़ोटो से रसीद';

  @override
  String get enterManually => 'खुद डालें';

  @override
  String get readingReceipt => 'रसीद पढ़ी जा रही है…';

  @override
  String get receiptReadNotice =>
      'आपकी रसीद से भरा गया है। सेव करने से पहले जांचें और सुधारें। विश्लेषण के बाद फ़ोटो हटा दी गई।';

  @override
  String get receiptNothingFound =>
      'रसीद पर कोई राशि नहीं मिली। कृपया खुद डालें। फ़ोटो हटा दी गई।';

  @override
  String receiptScanFailed(String details) {
    return 'रसीद नहीं पढ़ी जा सकी: $details';
  }

  @override
  String get photoDeletedNote =>
      'फ़ोटो का विश्लेषण आपके डिवाइस पर होता है और तुरंत हटा दी जाती है। इन्हें कभी सेव या अपलोड नहीं किया जाता।';

  @override
  String get cardAlertsSection => 'कार्ड भुगतान अलर्ट अपने-आप दर्ज करें';

  @override
  String get cardAlertsBody =>
      'विदेश में कार्ड से भुगतान करने पर आपके कार्ड ऐप (या मैसेंजर) का स्वीकृति अलर्ट पढ़कर उस तारीख की यात्रा में दर्ज किया जाता है। सिर्फ़ विदेशी मुद्रा वाले स्वीकृति अलर्ट ही आपके डिवाइस पर प्रोसेस होते हैं। अन्य सूचनाएं कभी सेव नहीं की जातीं और कहीं नहीं भेजी जातीं।';

  @override
  String get cardAlertsOn => 'चालू';

  @override
  String get cardAlertsOff => 'बंद (सूचना ऐक्सेस ज़रूरी)';

  @override
  String get cardAlertsAllow => 'सूचना ऐक्सेस की अनुमति दें';

  @override
  String get cardAlertsSettings => 'सूचना ऐक्सेस सेटिंग खोलें';

  @override
  String get cardAlertsConsentTitle => 'सूचना ऐक्सेस के बारे में';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'अगली स्क्रीन पर \"$appName\" के लिए सूचना ऐक्सेस की अनुमति दें। ऐप आपकी सूचनाओं में से सिर्फ़ विदेशी कार्ड भुगतान की स्वीकृतियां चुनकर उन्हें खर्च के रूप में दर्ज करेगा। सूचनाओं की सामग्री कभी आपके डिवाइस से बाहर नहीं जाती, और आप इसे कभी भी उसी सेटिंग में बंद कर सकते हैं।';
  }

  @override
  String get agreeAndContinue => 'सहमत हैं, आगे बढ़ें';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count कार्ड भुगतान',
      one: '1 कार्ड भुगतान',
    );
    return '$_temp0 ऐसी यात्रा की प्रतीक्षा में हैं जिसमें भुगतान की तारीख आती हो। वह यात्रा बनाएं, ये अपने-आप जुड़ जाएंगे।';
  }

  @override
  String get pasteCardAlert => 'कार्ड अलर्ट का टेक्स्ट पेस्ट करें';

  @override
  String get pasteCardAlertHint =>
      'अपने कार्ड ऐप या SMS से मिला स्वीकृति अलर्ट पेस्ट करें।';

  @override
  String get pasteCardAlertFailed =>
      'इसे विदेशी भुगतान स्वीकृति के रूप में नहीं पढ़ा जा सका। कृपया खुद डालें।';

  @override
  String get cardReadNotice =>
      'आपके कार्ड अलर्ट से भरा गया है। सेव करने से पहले जांचें और सुधारें।';

  @override
  String get read => 'पढ़ें';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String colHomeRate(String currency) {
    return 'दर ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'राशि ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'कुल ($currency)';
  }

  @override
  String get noConvertedYet => 'अभी तक कोई खर्च बदला नहीं गया';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'राष्ट्रीयता';

  @override
  String get chooseNationality => 'अपनी राष्ट्रीयता चुनें';

  @override
  String get nationalityBody =>
      'सारे खर्च आपके देश की मुद्रा में बदले जाएंगे, और ऐप की भाषा भी उसी के अनुसार होगी। आप इसे बाद में सेटिंग्स में बदल सकते हैं।';

  @override
  String get searchCountry => 'देश खोजें';

  @override
  String get homeCurrency => 'अपनी मुद्रा';

  @override
  String get welcomeTitle => 'Travel Expense में आपका स्वागत है';

  @override
  String get welcomeBody =>
      'अपना Google खाता जोड़ें ताकि आपके खर्च अपने-आप आपकी Google Drive की एक शीट में सेव हो जाएं।';

  @override
  String get skipForNow => 'अभी नहीं';

  @override
  String get next => 'आगे';

  @override
  String get exportTripSheet => 'Google Sheets में सहेजें';

  @override
  String get exportTripSheetSaving => 'Google Sheets में सहेजा जा रहा है…';

  @override
  String exportTripSheetDone(String title) {
    return '\'$title\' शीट में सहेजा गया';
  }

  @override
  String get receiptTotalNotFound =>
      'रसीद पर कुल राशि की पुष्टि नहीं हो सकी। कृपया राशि और मुद्रा खुद दर्ज करें। विश्लेषण के बाद फ़ोटो हटा दी गई।';

  @override
  String get receiptCurrencyNotFound =>
      'रसीद पर मुद्रा की पुष्टि नहीं हो सकी। राशि जाँचें और मुद्रा खुद चुनें। विश्लेषण के बाद फ़ोटो हटा दी गई।';

  @override
  String get currencyRequired => 'मुद्रा चुनें';
}
