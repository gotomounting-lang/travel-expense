// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Mongolian (`mn`).
class AppLocalizationsMn extends AppLocalizations {
  AppLocalizationsMn([String locale = 'mn']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Тохиргоо';

  @override
  String get newTrip => 'Шинэ аялал';

  @override
  String get editTrip => 'Аялал засах';

  @override
  String get deleteTrip => 'Аялал устгах';

  @override
  String get tripTitle => 'Аяллын нэр';

  @override
  String get tripTitleHint => 'Жишээ: 2026 Токио гэр бүлийн аялал';

  @override
  String get tripTitleRequired => 'Аяллын нэрээ оруулна уу';

  @override
  String get countryOptional => 'Улс/хот (заавал биш)';

  @override
  String get countryHint => 'Жишээ: Токио, Япон';

  @override
  String get localCurrency => 'Орон нутгийн валют';

  @override
  String get currency => 'Валют';

  @override
  String get tripPeriod => 'Аяллын хугацаа';

  @override
  String get save => 'Хадгалах';

  @override
  String get cancel => 'Цуцлах';

  @override
  String get delete => 'Устгах';

  @override
  String get deleteTripConfirmTitle => 'Энэ аяллыг устгах уу?';

  @override
  String get deleteTripConfirmBody =>
      'Энэ аяллын бүх зардал устах бөгөөд дараагийн синкээр хүснэгтээс хасагдана.';

  @override
  String get totalSpent => 'Нийт зарцуулсан';

  @override
  String pendingRates(int count) {
    return 'Ханш хүлээж буй: $count (интернэтэд холбогдоод доош татаж шинэчилнэ үү)';
  }

  @override
  String get firstExpenseHint => 'Эхний зардлаа бүртгэхийн тулд + дарна уу';

  @override
  String get addExpense => 'Зардал нэмэх';

  @override
  String get editExpense => 'Зардал засах';

  @override
  String get ratePending => 'Ханш хүлээгдэж байна';

  @override
  String get amount => 'Дүн';

  @override
  String get amountRequired => 'Дүнгээ оруулна уу';

  @override
  String get category => 'Ангилал';

  @override
  String get merchantOptional => 'Дэлгүүр (заавал биш)';

  @override
  String get merchantHint => 'Жишээ: Ichiran Ramen';

  @override
  String get paymentOptional => 'Төлбөрийн хэлбэр (заавал биш)';

  @override
  String get paymentHint => 'Жишээ: Visa карт, бэлэн мөнгө';

  @override
  String get memoOptional => 'Тэмдэглэл (заавал биш)';

  @override
  String get checkingRate => 'Ханш шалгаж байна…';

  @override
  String get rateUnavailable =>
      'Одоогоор ханш авах боломжгүй байна. Хадгалаад орхивол интернэтэд холбогдох үед хөрвүүлнэ.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home ($date-ны байдлаар)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count зардал',
      one: '1 зардал',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Эхний аяллаа үүсгээрэй';

  @override
  String get emptyBody =>
      'Гадаадад зарцуулсан мөнгийг төлбөр хийсэн өдрийн ханшаар өөрийн улсын валют руу хөрвүүлж\nтаны өөрийн Google Sheets хүснэгтэд хадгална.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Google бүртгэлээрээ нэвтэрвэл таны Google Drive-д \"$fileName\" хүснэгт үүсч, зардал бүртгэх бүрт шинэчлэгдэнэ. Апп зөвхөн өөрийн үүсгэсэн хүснэгтэд хандах бөгөөд таны мэдээллийг манай сервер рүү хэзээ ч илгээхгүй.';
  }

  @override
  String get connectGoogle => 'Google бүртгэл холбох';

  @override
  String get syncNow => 'Одоо хадгалах';

  @override
  String get openSheet => 'Хүснэгт нээх';

  @override
  String get disconnect => 'Салгах';

  @override
  String get rateInfoTitle => 'Ханшийн тухай';

  @override
  String get rateInfoBody =>
      'Таны улсын валютаарх дүнг төлбөр хийсэн өдрийн лавлах ханшаар (Европын Төв банк, бусад валютын хувьд нээлттэй ханшийн мэдээлэл) тооцно. Амралтын болон баярын өдрүүдэд өмнөх ажлын өдрийн ханшийг ашиглана. Картын бодит хуулга нь карт гаргагчийн ханш, шимтгэлээс шалтгаалан бага зэрэг зөрж болно.';

  @override
  String googleSignInError(String details) {
    return 'Google-д нэвтрэхэд алдаа гарлаа: $details';
  }

  @override
  String get syncSaved => 'Хүснэгтэд хадгалагдлаа';

  @override
  String syncFailed(String details) {
    return 'Хүснэгтэд хадгалж чадсангүй: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Та Google-д нэвтрээгүй байна.';

  @override
  String get syncErrorNoPermission =>
      'Google Drive-ийн зөвшөөрөл шаардлагатай. Дахин холбоно уу.';

  @override
  String get syncErrorExpired =>
      'Google-ийн нэвтрэлтийн хугацаа дууссан. Дахин холбоно уу.';

  @override
  String get language => 'Хэл';

  @override
  String get languageSystem => 'Автомат (иргэншлээр)';

  @override
  String get catFood => 'Хоол';

  @override
  String get catSnack => 'Зууш/Кафе';

  @override
  String get catSouvenir => 'Бэлэг дурсгал';

  @override
  String get catShopping => 'Худалдан авалт';

  @override
  String get catTransport => 'Тээвэр';

  @override
  String get catLodging => 'Байр';

  @override
  String get catSightseeing => 'Үзвэр';

  @override
  String get catOther => 'Бусад';

  @override
  String get sourceManual => 'Гараар';

  @override
  String get sourceReceipt => 'Баримт';

  @override
  String get sourceCard => 'Картын мэдэгдэл';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Зардал';

  @override
  String get tabTrips => 'Аялал';

  @override
  String get tabSummary => 'Хураангуй';

  @override
  String get colTrip => 'Аялал';

  @override
  String get colDate => 'Огноо';

  @override
  String get colTime => 'Цаг';

  @override
  String get colCategory => 'Ангилал';

  @override
  String get colMerchant => 'Дэлгүүр';

  @override
  String get colCurrency => 'Валют';

  @override
  String get colLocalAmount => 'Орон нутгийн дүн';

  @override
  String get colRateDate => 'Ханшийн огноо';

  @override
  String get colPayment => 'Төлбөр';

  @override
  String get colSource => 'Эх сурвалж';

  @override
  String get colMemo => 'Тэмдэглэл';

  @override
  String get colRateSource => 'Ханшийн эх сурвалж';

  @override
  String get colCountry => 'Улс';

  @override
  String get colStartDate => 'Эхлэх';

  @override
  String get colEndDate => 'Дуусах';

  @override
  String get colCount => 'Тоо';

  @override
  String get colShare => 'Хувь (%)';

  @override
  String get scanReceipt => 'Баримт скан хийх';

  @override
  String get pickReceipt => 'Зургаас баримт сонгох';

  @override
  String get enterManually => 'Гараар оруулах';

  @override
  String get readingReceipt => 'Баримт уншиж байна…';

  @override
  String get receiptReadNotice =>
      'Баримтаас бөглөлөө. Хадгалахаасаа өмнө шалгаж засна уу. Зургийг шинжилсний дараа устгасан.';

  @override
  String get receiptNothingFound =>
      'Баримтаас дүн олдсонгүй. Гараар оруулна уу. Зургийг устгасан.';

  @override
  String receiptScanFailed(String details) {
    return 'Баримтыг уншиж чадсангүй: $details';
  }

  @override
  String get photoDeletedNote =>
      'Зургийг таны төхөөрөмж дээр шинжлээд шууд устгана. Хэзээ ч хадгалахгүй, илгээхгүй.';

  @override
  String get cardAlertsSection =>
      'Картын төлбөрийн мэдэгдлийг автоматаар бүртгэх';

  @override
  String get cardAlertsBody =>
      'Гадаадад картаар төлбөр хийхэд картын апп (эсвэл мессенжер)-аас ирэх зөвшөөрлийн мэдэгдлийг уншиж, тухайн өдрийн аялалд бүртгэнэ. Зөвхөн гадаад валютын төлбөрийн мэдэгдлийг таны төхөөрөмж дээр боловсруулна. Бусад мэдэгдлийг хэзээ ч хадгалахгүй, хаашаа ч илгээхгүй.';

  @override
  String get cardAlertsOn => 'Асаалттай';

  @override
  String get cardAlertsOff =>
      'Унтраалттай (мэдэгдэлд хандах зөвшөөрөл хэрэгтэй)';

  @override
  String get cardAlertsAllow => 'Мэдэгдэлд хандахыг зөвшөөрөх';

  @override
  String get cardAlertsSettings => 'Мэдэгдэлд хандах тохиргоог нээх';

  @override
  String get cardAlertsConsentTitle => 'Мэдэгдэлд хандах тухай';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Дараагийн дэлгэц дээр \"$appName\"-д мэдэгдэлд хандахыг зөвшөөрнө үү. Апп таны мэдэгдлүүдээс зөвхөн гадаад дахь картын төлбөрийн зөвшөөрлийг ялгаж, зардал болгон бүртгэнэ. Мэдэгдлийн агуулга таны төхөөрөмжөөс хэзээ ч гарахгүй бөгөөд та үүнийг ижил тохиргооноос хүссэн үедээ унтрааж болно.';
  }

  @override
  String get agreeAndContinue => 'Зөвшөөрөөд үргэлжлүүлэх';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count картын төлбөр',
      one: '1 картын төлбөр',
    );
    return '$_temp0 төлбөрийн огноог хамарсан аялал хүлээж байна. Тэр аяллыг үүсгэвэл автоматаар нэмэгдэнэ.';
  }

  @override
  String get pasteCardAlert => 'Картын мэдэгдэл буулгах';

  @override
  String get pasteCardAlertHint =>
      'Картын апп эсвэл SMS-ээр ирсэн зөвшөөрлийн мэдэгдлийг буулгана уу.';

  @override
  String get pasteCardAlertFailed =>
      'Үүнийг гадаад төлбөрийн зөвшөөрөл гэж уншиж чадсангүй. Гараар оруулна уу.';

  @override
  String get cardReadNotice =>
      'Картын мэдэгдлээс бөглөлөө. Хадгалахаасаа өмнө шалгаж засна уу.';

  @override
  String get read => 'Унших';

  @override
  String get privacyPolicy => 'Нууцлалын бодлого';

  @override
  String colHomeRate(String currency) {
    return 'Ханш ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Дүн ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Нийт ($currency)';
  }

  @override
  String get noConvertedYet => 'Хөрвүүлсэн зардал одоогоор алга';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Иргэншил';

  @override
  String get chooseNationality => 'Иргэншлээ сонгоно уу';

  @override
  String get nationalityBody =>
      'Бүх зардлыг таны улсын валют руу хөрвүүлж, аппын хэлийг ч тааруулна. Дараа нь Тохиргооноос өөрчилж болно.';

  @override
  String get searchCountry => 'Улс хайх';

  @override
  String get homeCurrency => 'Үндсэн валют';

  @override
  String get welcomeTitle => 'Travel Expense-д тавтай морил';

  @override
  String get welcomeBody =>
      'Google бүртгэлээ холбовол зардлууд тань өөрийн Google Drive дахь хүснэгтэд автоматаар хадгалагдана.';

  @override
  String get skipForNow => 'Дараа';

  @override
  String get next => 'Дараах';

  @override
  String get exportTripSheet => 'Google Sheets-д хадгалах';

  @override
  String get exportTripSheetSaving => 'Google Sheets-д хадгалж байна…';

  @override
  String exportTripSheetDone(String title) {
    return '\'$title\' хүснэгтэд хадгаллаа';
  }

  @override
  String get receiptTotalNotFound =>
      'Баримтын нийт дүнг тодорхойлж чадсангүй. Дүн болон валютаа өөрөө оруулна уу. Зургийг шинжилсний дараа устгасан.';

  @override
  String get receiptCurrencyNotFound =>
      'Баримтын валютыг тодорхойлж чадсангүй. Дүнгээ шалгаад валютаа өөрөө сонгоно уу. Зургийг шинжилсний дараа устгасан.';

  @override
  String get currencyRequired => 'Валют сонгоно уу';

  @override
  String batchTitle(int count) {
    return '$count төлбөр уншлаа';
  }

  @override
  String get batchHint => 'Хадгалахыг сонгоно уу. Дүн дээр дарж засна.';

  @override
  String batchSave(int count) {
    return 'Сонгосон $count-г хадгалах';
  }

  @override
  String batchSaved(int count) {
    return '$count зардал хадгаллаа';
  }

  @override
  String get batchOutsideTrip => 'Аяллын хугацаанаас гадуур';

  @override
  String get batchDuplicate => 'Өмнө хадгалсан';

  @override
  String get batchNeedsInput => 'Дүн/валют шалгах · дүн дээр дарна уу';

  @override
  String scanUnreadable(int count) {
    return '$count зурагнаас төлбөр уншиж чадсангүй. Нэг бүрчлэн оруулна уу.';
  }
}
