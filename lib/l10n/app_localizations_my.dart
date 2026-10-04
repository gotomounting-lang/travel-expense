// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Burmese (`my`).
class AppLocalizationsMy extends AppLocalizations {
  AppLocalizationsMy([String locale = 'my']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'ဆက်တင်များ';

  @override
  String get newTrip => 'ခရီးစဉ်အသစ်';

  @override
  String get editTrip => 'ခရီးစဉ် ပြင်ရန်';

  @override
  String get deleteTrip => 'ခရီးစဉ် ဖျက်ရန်';

  @override
  String get tripTitle => 'ခရီးစဉ်အမည်';

  @override
  String get tripTitleHint => 'ဥပမာ - ၂၀၂၆ တိုကျို မိသားစုခရီး';

  @override
  String get tripTitleRequired => 'ခရီးစဉ်အမည် ထည့်ပါ';

  @override
  String get countryOptional => 'နိုင်ငံ/မြို့ (မထည့်လည်းရ)';

  @override
  String get countryHint => 'ဥပမာ - တိုကျို၊ ဂျပန်';

  @override
  String get localCurrency => 'ဒေသတွင်း ငွေကြေး';

  @override
  String get currency => 'ငွေကြေး';

  @override
  String get tripPeriod => 'ခရီးစဉ် ရက်စွဲ';

  @override
  String get save => 'သိမ်းရန်';

  @override
  String get cancel => 'မလုပ်တော့ပါ';

  @override
  String get delete => 'ဖျက်ရန်';

  @override
  String get deleteTripConfirmTitle => 'ဤခရီးစဉ်ကို ဖျက်မလား။';

  @override
  String get deleteTripConfirmBody =>
      'ဤခရီးစဉ်ရှိ အသုံးစရိတ်အားလုံး ဖျက်ပစ်မည်ဖြစ်ပြီး နောက်တစ်ကြိမ် ချိန်ကိုက်ချိန်တွင် သင့်ရှိတ်မှလည်း ဖယ်ရှားပါမည်။';

  @override
  String get totalSpent => 'စုစုပေါင်း သုံးငွေ';

  @override
  String pendingRates(int count) {
    return 'ငွေလဲနှုန်း စောင့်နေသည် $count ခု (အွန်လိုင်းဖြစ်လျှင် အောက်သို့ဆွဲ၍ ပြန်ဖွင့်ပါ)';
  }

  @override
  String get firstExpenseHint => 'ပထမဆုံး အသုံးစရိတ် မှတ်ရန် + ကို နှိပ်ပါ';

  @override
  String get addExpense => 'အသုံးစရိတ် ထည့်ရန်';

  @override
  String get editExpense => 'အသုံးစရိတ် ပြင်ရန်';

  @override
  String get ratePending => 'နှုန်း စောင့်ဆဲ';

  @override
  String get amount => 'ပမာဏ';

  @override
  String get amountRequired => 'ပမာဏ ထည့်ပါ';

  @override
  String get category => 'အမျိုးအစား';

  @override
  String get merchantOptional => 'ဆိုင် (မထည့်လည်းရ)';

  @override
  String get merchantHint => 'ဥပမာ - Ichiran Ramen';

  @override
  String get paymentOptional => 'ငွေပေးချေပုံ (မထည့်လည်းရ)';

  @override
  String get paymentHint => 'ဥပမာ - Visa ကတ်၊ ငွေသား';

  @override
  String get memoOptional => 'မှတ်စု (မထည့်လည်းရ)';

  @override
  String get checkingRate => 'ငွေလဲနှုန်း စစ်နေသည်…';

  @override
  String get rateUnavailable =>
      'ယခု ငွေလဲနှုန်း မရနိုင်ပါ။ သိမ်းထားပါ၊ အွန်လိုင်းဖြစ်သည့်အခါ ပြောင်းလဲတွက်ချက်ပေးပါမည်။';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home ($date အရ)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'အသုံးစရိတ် $count ခု',
      one: 'အသုံးစရိတ် 1 ခု',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'ပထမဆုံး ခရီးစဉ် ဖန်တီးပါ';

  @override
  String get emptyBody =>
      'နိုင်ငံခြားတွင် သုံးငွေကို ငွေပေးချေသည့်နေ့၏ နှုန်းဖြင့် သင့်နိုင်ငံငွေသို့ ပြောင်းပြီး\nသင့်ကိုယ်ပိုင် Google Sheet တွင် သိမ်းပေးပါသည်။';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'သင့် Google အကောင့်ဖြင့် ဝင်လိုက်လျှင် သင့်ကိုယ်ပိုင် Google Drive တွင် \"$fileName\" ရှိတ်တစ်ခု ဖန်တီးပေးပြီး အသုံးစရိတ် မှတ်တိုင်း အလိုအလျောက် အပ်ဒိတ်လုပ်ပါမည်။ အက်ပ်သည် ၎င်းဖန်တီးထားသော ရှိတ်ကိုသာ ဝင်ရောက်နိုင်ပြီး သင့်ဒေတာကို ကျွန်ုပ်တို့၏ ဆာဗာသို့ ဘယ်တော့မှ မပို့ပါ။';
  }

  @override
  String get connectGoogle => 'Google အကောင့် ချိတ်ရန်';

  @override
  String get syncNow => 'ယခု သိမ်းရန်';

  @override
  String get openSheet => 'ရှိတ် ဖွင့်ရန်';

  @override
  String get disconnect => 'ချိတ်ဆက်မှု ဖြုတ်ရန်';

  @override
  String get rateInfoTitle => 'ငွေလဲနှုန်းအကြောင်း';

  @override
  String get rateInfoBody =>
      'သင့်နိုင်ငံငွေဖြင့် ပမာဏကို ငွေပေးချေသည့်နေ့၏ ရည်ညွှန်းနှုန်း (ဥရောပ ဗဟိုဘဏ်၊ သို့မဟုတ် အခြားငွေကြေးများအတွက် အများသုံး ငွေလဲနှုန်းဒေတာ) ဖြင့် တွက်ပါသည်။ စနေ၊ တနင်္ဂနွေနှင့် ရုံးပိတ်ရက်များတွင် ယခင် အလုပ်ဖွင့်ရက်၏ နှုန်းကို သုံးပါသည်။ ကတ်ထုတ်ပေးသူ၏ နှုန်းနှင့် အခကြေးငွေကြောင့် အမှန်တကယ် ကတ်ငွေတောင်းခံလွှာ အနည်းငယ် ကွာနိုင်ပါသည်။';

  @override
  String googleSignInError(String details) {
    return 'Google ဝင်ရောက်မှု အမှား - $details';
  }

  @override
  String get syncSaved => 'ရှိတ်တွင် သိမ်းပြီး';

  @override
  String syncFailed(String details) {
    return 'ရှိတ်တွင် မသိမ်းနိုင်ပါ - $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Google သို့ ဝင်ရောက်ထားခြင်း မရှိပါ။';

  @override
  String get syncErrorNoPermission =>
      'Google Drive ခွင့်ပြုချက် လိုအပ်သည်။ ပြန်ချိတ်ပါ။';

  @override
  String get syncErrorExpired =>
      'Google ဝင်ရောက်မှု သက်တမ်းကုန်သွားပြီ။ ပြန်ချိတ်ပါ။';

  @override
  String get language => 'ဘာသာစကား';

  @override
  String get languageSystem => 'အလိုအလျောက် (နိုင်ငံသားအလိုက်)';

  @override
  String get catFood => 'အစားအသောက်';

  @override
  String get catSnack => 'မုန့်/ကော်ဖီဆိုင်';

  @override
  String get catSouvenir => 'အမှတ်တရပစ္စည်း';

  @override
  String get catShopping => 'ဈေးဝယ်';

  @override
  String get catTransport => 'သယ်ယူပို့ဆောင်ရေး';

  @override
  String get catLodging => 'တည်းခို';

  @override
  String get catSightseeing => 'လည်ပတ်ရေး';

  @override
  String get catOther => 'အခြား';

  @override
  String get sourceManual => 'ကိုယ်တိုင်';

  @override
  String get sourceReceipt => 'ပြေစာ';

  @override
  String get sourceCard => 'ကတ်အသိပေးချက်';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'အသုံးစရိတ်';

  @override
  String get tabTrips => 'ခရီးစဉ်';

  @override
  String get tabSummary => 'အနှစ်ချုပ်';

  @override
  String get colTrip => 'ခရီးစဉ်';

  @override
  String get colDate => 'ရက်စွဲ';

  @override
  String get colTime => 'အချိန်';

  @override
  String get colCategory => 'အမျိုးအစား';

  @override
  String get colMerchant => 'ဆိုင်';

  @override
  String get colCurrency => 'ငွေကြေး';

  @override
  String get colLocalAmount => 'ဒေသငွေ ပမာဏ';

  @override
  String get colRateDate => 'နှုန်း ရက်စွဲ';

  @override
  String get colPayment => 'ငွေပေးချေမှု';

  @override
  String get colSource => 'ရင်းမြစ်';

  @override
  String get colMemo => 'မှတ်စု';

  @override
  String get colRateSource => 'နှုန်း ရင်းမြစ်';

  @override
  String get colCountry => 'နိုင်ငံ';

  @override
  String get colStartDate => 'စတင်';

  @override
  String get colEndDate => 'ပြီးဆုံး';

  @override
  String get colCount => 'အရေအတွက်';

  @override
  String get colShare => 'ရာခိုင်နှုန်း (%)';

  @override
  String get scanReceipt => 'ပြေစာ စကင်ဖတ်ရန်';

  @override
  String get pickReceipt => 'ဓာတ်ပုံမှ ပြေစာ';

  @override
  String get enterManually => 'ကိုယ်တိုင် ထည့်ရန်';

  @override
  String get readingReceipt => 'ပြေစာ ဖတ်နေသည်…';

  @override
  String get receiptReadNotice =>
      'ပြေစာမှ ဖြည့်ထားသည်။ မသိမ်းမီ စစ်ဆေးပြင်ဆင်ပါ။ ခွဲခြမ်းစိတ်ဖြာပြီးနောက် ဓာတ်ပုံကို ဖျက်လိုက်ပါပြီ။';

  @override
  String get receiptNothingFound =>
      'ပြေစာတွင် ပမာဏ ရှာမတွေ့ပါ။ ကိုယ်တိုင် ထည့်ပါ။ ဓာတ်ပုံကို ဖျက်လိုက်ပါပြီ။';

  @override
  String receiptScanFailed(String details) {
    return 'ပြေစာ မဖတ်နိုင်ပါ - $details';
  }

  @override
  String get photoDeletedNote =>
      'ဓာတ်ပုံများကို သင့်စက်ပေါ်တွင်သာ ခွဲခြမ်းစိတ်ဖြာပြီး ချက်ချင်း ဖျက်ပါသည်။ ဘယ်တော့မှ သိမ်းဆည်းခြင်း သို့မဟုတ် အပ်လုဒ်လုပ်ခြင်း မပြုပါ။';

  @override
  String get cardAlertsSection =>
      'ကတ်ငွေပေးချေမှု အသိပေးချက် အလိုအလျောက် မှတ်ရန်';

  @override
  String get cardAlertsBody =>
      'နိုင်ငံခြားတွင် ကတ်ဖြင့် ပေးချေသည့်အခါ သင့်ကတ်အက်ပ် (သို့မဟုတ် မက်ဆင်ဂျာ) မှ အတည်ပြုအသိပေးချက်ကို ဖတ်ပြီး ထိုနေ့၏ ခရီးစဉ်တွင် မှတ်ပေးပါသည်။ နိုင်ငံခြားငွေ အတည်ပြုအသိပေးချက်များကိုသာ သင့်စက်ပေါ်တွင် လုပ်ဆောင်ပါသည်။ အခြား အသိပေးချက်များကို ဘယ်တော့မှ မသိမ်း၊ ဘယ်နေရာမှ မပို့ပါ။';

  @override
  String get cardAlertsOn => 'ဖွင့်ထားသည်';

  @override
  String get cardAlertsOff => 'ပိတ်ထားသည် (အသိပေးချက် ဝင်ရောက်ခွင့် လိုအပ်)';

  @override
  String get cardAlertsAllow => 'အသိပေးချက် ဝင်ရောက်ခွင့် ပေးရန်';

  @override
  String get cardAlertsSettings => 'အသိပေးချက် ဝင်ရောက်ခွင့် ဆက်တင် ဖွင့်ရန်';

  @override
  String get cardAlertsConsentTitle => 'အသိပေးချက် ဝင်ရောက်ခွင့်အကြောင်း';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'နောက်စာမျက်နှာတွင် \"$appName\" အတွက် အသိပေးချက် ဝင်ရောက်ခွင့် ပေးပါ။ အက်ပ်သည် သင့်အသိပေးချက်များထဲမှ နိုင်ငံခြား ကတ်ငွေပေးချေမှု အတည်ပြုချက်များကိုသာ ရွေးပြီး အသုံးစရိတ်အဖြစ် မှတ်ပါမည်။ အသိပေးချက် အကြောင်းအရာများသည် သင့်စက်မှ ဘယ်တော့မှ အပြင်မထွက်ပါ၊ ထိုဆက်တင်တွင်ပင် အချိန်မရွေး ပိတ်နိုင်ပါသည်။';
  }

  @override
  String get agreeAndContinue => 'သဘောတူပြီး ဆက်သွားရန်';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ကတ်ငွေပေးချေမှု $count ခုသည်',
      one: 'ကတ်ငွေပေးချေမှု 1 ခုသည်',
    );
    return '$_temp0 ငွေပေးချေသည့်ရက်ပါဝင်သော ခရီးစဉ်ကို စောင့်နေပါသည်။ ထိုခရီးစဉ်ကို ဖန်တီးလိုက်လျှင် အလိုအလျောက် ထည့်ပေးပါမည်။';
  }

  @override
  String get pasteCardAlert => 'ကတ်အသိပေးချက် စာသား ကူးထည့်ရန်';

  @override
  String get pasteCardAlertHint =>
      'ကတ်အက်ပ် သို့မဟုတ် SMS မှ ရရှိသော အတည်ပြုအသိပေးချက်ကို ကူးထည့်ပါ။';

  @override
  String get pasteCardAlertFailed =>
      '၎င်းကို နိုင်ငံခြား ငွေပေးချေမှု အတည်ပြုချက်အဖြစ် မဖတ်နိုင်ပါ။ ကိုယ်တိုင် ထည့်ပါ။';

  @override
  String get cardReadNotice =>
      'ကတ်အသိပေးချက်မှ ဖြည့်ထားသည်။ မသိမ်းမီ စစ်ဆေးပြင်ဆင်ပါ။';

  @override
  String get read => 'ဖတ်ရန်';

  @override
  String get privacyPolicy => 'ကိုယ်ရေးအချက်အလက် မူဝါဒ';

  @override
  String colHomeRate(String currency) {
    return 'နှုန်း ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'ပမာဏ ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'စုစုပေါင်း ($currency)';
  }

  @override
  String get noConvertedYet => 'ပြောင်းလဲတွက်ပြီး အသုံးစရိတ် မရှိသေးပါ';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'နိုင်ငံသား';

  @override
  String get chooseNationality => 'သင့်နိုင်ငံသားကို ရွေးပါ';

  @override
  String get nationalityBody =>
      'အသုံးစရိတ်အားလုံးကို သင့်နိုင်ငံ၏ ငွေကြေးသို့ ပြောင်းတွက်ပြီး အက်ပ်ဘာသာစကားကိုလည်း လိုက်ညှိပေးပါမည်။ နောက်မှ ဆက်တင်များတွင် ပြောင်းနိုင်ပါသည်။';

  @override
  String get searchCountry => 'နိုင်ငံ ရှာရန်';

  @override
  String get homeCurrency => 'မိခင်နိုင်ငံ ငွေကြေး';

  @override
  String get welcomeTitle => 'Travel Expense မှ ကြိုဆိုပါသည်';

  @override
  String get welcomeBody =>
      'သင့် Google အကောင့်ကို ချိတ်ဆက်ပြီး အသုံးစရိတ်များကို သင့်ကိုယ်ပိုင် Google Drive ရှိ ရှိတ်တွင် အလိုအလျောက် သိမ်းပါ။';

  @override
  String get skipForNow => 'နောက်မှ';

  @override
  String get next => 'ရှေ့ဆက်ရန်';

  @override
  String get exportTripSheet => 'Google Sheets တွင် သိမ်းရန်';

  @override
  String get exportTripSheetSaving => 'Google Sheets တွင် သိမ်းနေသည်…';

  @override
  String exportTripSheetDone(String title) {
    return '\'$title\' စာရင်းဇယားတွင် သိမ်းပြီးပါပြီ';
  }

  @override
  String get receiptTotalNotFound =>
      'ပြေစာပေါ်ရှိ စုစုပေါင်းငွေပမာဏကို အတည်မပြုနိုင်ပါ။ ငွေပမာဏနှင့် ငွေကြေးကို ကိုယ်တိုင်ထည့်ပါ။ ဓာတ်ပုံကို စစ်ဆေးပြီးနောက် ဖျက်လိုက်ပါပြီ။';

  @override
  String get receiptCurrencyNotFound =>
      'ပြေစာပေါ်ရှိ ငွေကြေးအမျိုးအစားကို အတည်မပြုနိုင်ပါ။ ငွေပမာဏကို စစ်ဆေးပြီး ငွေကြေးကို ကိုယ်တိုင်ရွေးပါ။ ဓာတ်ပုံကို စစ်ဆေးပြီးနောက် ဖျက်လိုက်ပါပြီ။';

  @override
  String get currencyRequired => 'ငွေကြေးကို ရွေးပါ';

  @override
  String batchTitle(int count) {
    return 'ငွေပေးချေမှု $count ခု ဖတ်ပြီး';
  }

  @override
  String get batchHint => 'သိမ်းမည့်အရာကို ရွေးပါ။ ပြင်ရန် ငွေပမာဏကို နှိပ်ပါ။';

  @override
  String batchSave(int count) {
    return 'ရွေးထားသော $count ခု သိမ်းရန်';
  }

  @override
  String batchSaved(int count) {
    return '$count ခု သိမ်းပြီး';
  }

  @override
  String get batchOutsideTrip => 'ခရီးကာလ ပြင်ပ';

  @override
  String get batchDuplicate => 'သိမ်းပြီးသား';

  @override
  String get batchNeedsInput => 'ငွေပမာဏ/ငွေကြေး စစ်ရန် · ငွေပမာဏကို နှိပ်ပါ';

  @override
  String get scanIncomplete =>
      'မဖတ်နိုင်သော ငွေပေးချေမှု ရှိပါသည်။ တစ်ခုချင်း ထည့်ပါ။';
}
