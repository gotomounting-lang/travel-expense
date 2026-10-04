import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_mn.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_my.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fil'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('ko'),
    Locale('mn'),
    Locale('ms'),
    Locale('my'),
    Locale('ru'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'여행 경비'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// No description provided for @newTrip.
  ///
  /// In ko, this message translates to:
  /// **'새 여행'**
  String get newTrip;

  /// No description provided for @editTrip.
  ///
  /// In ko, this message translates to:
  /// **'여행 수정'**
  String get editTrip;

  /// No description provided for @deleteTrip.
  ///
  /// In ko, this message translates to:
  /// **'여행 삭제'**
  String get deleteTrip;

  /// No description provided for @tripTitle.
  ///
  /// In ko, this message translates to:
  /// **'여행 제목'**
  String get tripTitle;

  /// No description provided for @tripTitleHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 2026 도쿄 가족여행'**
  String get tripTitleHint;

  /// No description provided for @tripTitleRequired.
  ///
  /// In ko, this message translates to:
  /// **'여행 제목을 입력해 주세요'**
  String get tripTitleRequired;

  /// No description provided for @countryOptional.
  ///
  /// In ko, this message translates to:
  /// **'나라/도시 (선택)'**
  String get countryOptional;

  /// No description provided for @countryHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 일본 도쿄'**
  String get countryHint;

  /// No description provided for @localCurrency.
  ///
  /// In ko, this message translates to:
  /// **'현지 통화'**
  String get localCurrency;

  /// No description provided for @currency.
  ///
  /// In ko, this message translates to:
  /// **'통화'**
  String get currency;

  /// No description provided for @tripPeriod.
  ///
  /// In ko, this message translates to:
  /// **'여행 기간'**
  String get tripPeriod;

  /// No description provided for @save.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get delete;

  /// No description provided for @deleteTripConfirmTitle.
  ///
  /// In ko, this message translates to:
  /// **'여행을 삭제할까요?'**
  String get deleteTripConfirmTitle;

  /// No description provided for @deleteTripConfirmBody.
  ///
  /// In ko, this message translates to:
  /// **'이 여행의 모든 지출 내역이 함께 삭제되고, 다음 동기화 때 시트에서도 빠집니다.'**
  String get deleteTripConfirmBody;

  /// No description provided for @totalSpent.
  ///
  /// In ko, this message translates to:
  /// **'총 지출'**
  String get totalSpent;

  /// No description provided for @pendingRates.
  ///
  /// In ko, this message translates to:
  /// **'환율 확인 대기 {count}건 (인터넷 연결 후 아래로 당겨 새로고침)'**
  String pendingRates(int count);

  /// No description provided for @firstExpenseHint.
  ///
  /// In ko, this message translates to:
  /// **'+ 버튼으로 첫 지출을 기록하세요'**
  String get firstExpenseHint;

  /// No description provided for @addExpense.
  ///
  /// In ko, this message translates to:
  /// **'지출 추가'**
  String get addExpense;

  /// No description provided for @editExpense.
  ///
  /// In ko, this message translates to:
  /// **'지출 수정'**
  String get editExpense;

  /// No description provided for @ratePending.
  ///
  /// In ko, this message translates to:
  /// **'환율 대기'**
  String get ratePending;

  /// No description provided for @amount.
  ///
  /// In ko, this message translates to:
  /// **'금액'**
  String get amount;

  /// No description provided for @amountRequired.
  ///
  /// In ko, this message translates to:
  /// **'금액을 입력해 주세요'**
  String get amountRequired;

  /// No description provided for @category.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get category;

  /// No description provided for @merchantOptional.
  ///
  /// In ko, this message translates to:
  /// **'가맹점 (선택)'**
  String get merchantOptional;

  /// No description provided for @merchantHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 이치란 라멘'**
  String get merchantHint;

  /// No description provided for @paymentOptional.
  ///
  /// In ko, this message translates to:
  /// **'결제수단 (선택)'**
  String get paymentOptional;

  /// No description provided for @paymentHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 신한카드, 현금'**
  String get paymentHint;

  /// No description provided for @memoOptional.
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get memoOptional;

  /// No description provided for @checkingRate.
  ///
  /// In ko, this message translates to:
  /// **'환율 확인 중…'**
  String get checkingRate;

  /// No description provided for @rateUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'지금은 환율을 가져올 수 없어요. 저장해 두면 연결될 때 환산해 드립니다.'**
  String get rateUnavailable;

  /// No description provided for @rateInfo.
  ///
  /// In ko, this message translates to:
  /// **'1 {currency} = {rate} {home} ({date} 기준)'**
  String rateInfo(String currency, String rate, String home, String date);

  /// No description provided for @expenseCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}건'**
  String expenseCount(int count);

  /// No description provided for @krw.
  ///
  /// In ko, this message translates to:
  /// **'{amount}원'**
  String krw(String amount);

  /// No description provided for @emptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'첫 여행을 만들어 보세요'**
  String get emptyTitle;

  /// No description provided for @emptyBody.
  ///
  /// In ko, this message translates to:
  /// **'해외에서 쓴 돈을 결제한 날의 환율로 내 나라 돈으로 바꿔\n내 구글 시트에 정리해 드립니다.'**
  String get emptyBody;

  /// No description provided for @googleSheetsSection.
  ///
  /// In ko, this message translates to:
  /// **'구글 스프레드시트'**
  String get googleSheetsSection;

  /// No description provided for @googleSheetsBody.
  ///
  /// In ko, this message translates to:
  /// **'내 구글 계정으로 로그인하면 내 구글 드라이브에 \"{fileName}\" 시트가 만들어지고, 기록할 때마다 자동으로 저장됩니다. 이 앱은 앱이 만든 시트에만 접근하며, 내역은 운영자 서버로 보내지 않습니다.'**
  String googleSheetsBody(String fileName);

  /// No description provided for @connectGoogle.
  ///
  /// In ko, this message translates to:
  /// **'구글 계정으로 연결'**
  String get connectGoogle;

  /// No description provided for @syncNow.
  ///
  /// In ko, this message translates to:
  /// **'지금 저장'**
  String get syncNow;

  /// No description provided for @openSheet.
  ///
  /// In ko, this message translates to:
  /// **'시트 열기'**
  String get openSheet;

  /// No description provided for @disconnect.
  ///
  /// In ko, this message translates to:
  /// **'연결 해제'**
  String get disconnect;

  /// No description provided for @rateInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'환율 안내'**
  String get rateInfoTitle;

  /// No description provided for @rateInfoBody.
  ///
  /// In ko, this message translates to:
  /// **'결제한 날짜의 기준환율(유럽중앙은행 고시, 미지원 통화는 공개 환율 자료)로 내 나라 통화 금액을 계산합니다. 주말·공휴일은 직전 영업일 환율을 쓰며, 실제 카드 청구액은 카드사 환율과 수수료 때문에 조금 다를 수 있습니다.'**
  String get rateInfoBody;

  /// No description provided for @googleSignInError.
  ///
  /// In ko, this message translates to:
  /// **'구글 로그인 오류: {details}'**
  String googleSignInError(String details);

  /// No description provided for @syncSaved.
  ///
  /// In ko, this message translates to:
  /// **'시트에 저장됨'**
  String get syncSaved;

  /// No description provided for @syncFailed.
  ///
  /// In ko, this message translates to:
  /// **'시트 저장 실패: {details}'**
  String syncFailed(String details);

  /// No description provided for @syncErrorNotSignedIn.
  ///
  /// In ko, this message translates to:
  /// **'구글 계정에 로그인되어 있지 않습니다.'**
  String get syncErrorNotSignedIn;

  /// No description provided for @syncErrorNoPermission.
  ///
  /// In ko, this message translates to:
  /// **'구글 드라이브 권한이 필요합니다. 다시 연결해 주세요.'**
  String get syncErrorNoPermission;

  /// No description provided for @syncErrorExpired.
  ///
  /// In ko, this message translates to:
  /// **'구글 로그인이 만료되었습니다. 다시 연결해 주세요.'**
  String get syncErrorExpired;

  /// No description provided for @language.
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In ko, this message translates to:
  /// **'자동 (국적 기준)'**
  String get languageSystem;

  /// No description provided for @catFood.
  ///
  /// In ko, this message translates to:
  /// **'음식'**
  String get catFood;

  /// No description provided for @catSnack.
  ///
  /// In ko, this message translates to:
  /// **'간식/카페'**
  String get catSnack;

  /// No description provided for @catSouvenir.
  ///
  /// In ko, this message translates to:
  /// **'기념품'**
  String get catSouvenir;

  /// No description provided for @catShopping.
  ///
  /// In ko, this message translates to:
  /// **'쇼핑'**
  String get catShopping;

  /// No description provided for @catTransport.
  ///
  /// In ko, this message translates to:
  /// **'교통'**
  String get catTransport;

  /// No description provided for @catLodging.
  ///
  /// In ko, this message translates to:
  /// **'숙박'**
  String get catLodging;

  /// No description provided for @catSightseeing.
  ///
  /// In ko, this message translates to:
  /// **'관광/입장료'**
  String get catSightseeing;

  /// No description provided for @catOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get catOther;

  /// No description provided for @sourceManual.
  ///
  /// In ko, this message translates to:
  /// **'수동'**
  String get sourceManual;

  /// No description provided for @sourceReceipt.
  ///
  /// In ko, this message translates to:
  /// **'영수증'**
  String get sourceReceipt;

  /// No description provided for @sourceCard.
  ///
  /// In ko, this message translates to:
  /// **'카드 알림'**
  String get sourceCard;

  /// No description provided for @sheetFileTitle.
  ///
  /// In ko, this message translates to:
  /// **'여행 경비'**
  String get sheetFileTitle;

  /// No description provided for @tabExpenses.
  ///
  /// In ko, this message translates to:
  /// **'내역'**
  String get tabExpenses;

  /// No description provided for @tabTrips.
  ///
  /// In ko, this message translates to:
  /// **'여행'**
  String get tabTrips;

  /// No description provided for @tabSummary.
  ///
  /// In ko, this message translates to:
  /// **'요약'**
  String get tabSummary;

  /// No description provided for @colTrip.
  ///
  /// In ko, this message translates to:
  /// **'여행'**
  String get colTrip;

  /// No description provided for @colDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get colDate;

  /// No description provided for @colTime.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get colTime;

  /// No description provided for @colCategory.
  ///
  /// In ko, this message translates to:
  /// **'카테고리'**
  String get colCategory;

  /// No description provided for @colMerchant.
  ///
  /// In ko, this message translates to:
  /// **'가맹점'**
  String get colMerchant;

  /// No description provided for @colCurrency.
  ///
  /// In ko, this message translates to:
  /// **'통화'**
  String get colCurrency;

  /// No description provided for @colLocalAmount.
  ///
  /// In ko, this message translates to:
  /// **'현지금액'**
  String get colLocalAmount;

  /// No description provided for @colRateDate.
  ///
  /// In ko, this message translates to:
  /// **'환율기준일'**
  String get colRateDate;

  /// No description provided for @colPayment.
  ///
  /// In ko, this message translates to:
  /// **'결제수단'**
  String get colPayment;

  /// No description provided for @colSource.
  ///
  /// In ko, this message translates to:
  /// **'입력방식'**
  String get colSource;

  /// No description provided for @colMemo.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get colMemo;

  /// No description provided for @colRateSource.
  ///
  /// In ko, this message translates to:
  /// **'환율출처'**
  String get colRateSource;

  /// No description provided for @colCountry.
  ///
  /// In ko, this message translates to:
  /// **'국가'**
  String get colCountry;

  /// No description provided for @colStartDate.
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get colStartDate;

  /// No description provided for @colEndDate.
  ///
  /// In ko, this message translates to:
  /// **'종료일'**
  String get colEndDate;

  /// No description provided for @colCount.
  ///
  /// In ko, this message translates to:
  /// **'건수'**
  String get colCount;

  /// No description provided for @colShare.
  ///
  /// In ko, this message translates to:
  /// **'비율(%)'**
  String get colShare;

  /// No description provided for @scanReceipt.
  ///
  /// In ko, this message translates to:
  /// **'영수증 촬영'**
  String get scanReceipt;

  /// No description provided for @pickReceipt.
  ///
  /// In ko, this message translates to:
  /// **'앨범의 영수증 사진'**
  String get pickReceipt;

  /// No description provided for @enterManually.
  ///
  /// In ko, this message translates to:
  /// **'직접 입력'**
  String get enterManually;

  /// No description provided for @readingReceipt.
  ///
  /// In ko, this message translates to:
  /// **'영수증 읽는 중…'**
  String get readingReceipt;

  /// No description provided for @receiptReadNotice.
  ///
  /// In ko, this message translates to:
  /// **'영수증에서 읽은 내용입니다. 확인하고 고친 뒤 저장하세요. 사진은 분석 후 삭제했습니다.'**
  String get receiptReadNotice;

  /// No description provided for @receiptNothingFound.
  ///
  /// In ko, this message translates to:
  /// **'영수증에서 금액을 찾지 못했어요. 직접 입력해 주세요. 사진은 삭제했습니다.'**
  String get receiptNothingFound;

  /// No description provided for @receiptScanFailed.
  ///
  /// In ko, this message translates to:
  /// **'영수증을 읽지 못했습니다: {details}'**
  String receiptScanFailed(String details);

  /// No description provided for @photoDeletedNote.
  ///
  /// In ko, this message translates to:
  /// **'사진은 기기 안에서 분석한 뒤 바로 삭제되며, 어디에도 저장·전송되지 않습니다.'**
  String get photoDeletedNote;

  /// No description provided for @cardAlertsSection.
  ///
  /// In ko, this message translates to:
  /// **'카드 결제 알림 자동 기록'**
  String get cardAlertsSection;

  /// No description provided for @cardAlertsBody.
  ///
  /// In ko, this message translates to:
  /// **'해외에서 카드로 결제하면 카드 앱이나 카카오톡 알림톡으로 오는 승인 알림을 읽어 그 날짜의 여행에 자동으로 기록합니다. 외화 결제 승인 알림만 기기 안에서 처리하고, 다른 알림은 저장하지 않으며 어디로도 보내지 않습니다.'**
  String get cardAlertsBody;

  /// No description provided for @cardAlertsOn.
  ///
  /// In ko, this message translates to:
  /// **'켜짐'**
  String get cardAlertsOn;

  /// No description provided for @cardAlertsOff.
  ///
  /// In ko, this message translates to:
  /// **'꺼짐 (알림 접근 허용 필요)'**
  String get cardAlertsOff;

  /// No description provided for @cardAlertsAllow.
  ///
  /// In ko, this message translates to:
  /// **'알림 접근 허용하기'**
  String get cardAlertsAllow;

  /// No description provided for @cardAlertsSettings.
  ///
  /// In ko, this message translates to:
  /// **'알림 접근 설정 열기'**
  String get cardAlertsSettings;

  /// No description provided for @cardAlertsConsentTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 접근 안내'**
  String get cardAlertsConsentTitle;

  /// No description provided for @cardAlertsConsentBody.
  ///
  /// In ko, this message translates to:
  /// **'다음 화면에서 \"{appName}\"의 알림 접근을 허용하면, 앱은 휴대폰에 오는 알림 중 해외 카드 결제 승인 알림만 골라 지출로 기록합니다. 알림 내용은 기기 밖으로 보내지 않으며, 언제든 같은 설정에서 끌 수 있습니다.'**
  String cardAlertsConsentBody(String appName);

  /// No description provided for @agreeAndContinue.
  ///
  /// In ko, this message translates to:
  /// **'동의하고 계속'**
  String get agreeAndContinue;

  /// No description provided for @cardAlertsWaiting.
  ///
  /// In ko, this message translates to:
  /// **'결제일에 맞는 여행이 없는 카드 결제 {count}건이 기다리고 있어요. 그 기간의 여행을 만들면 자동으로 들어갑니다.'**
  String cardAlertsWaiting(int count);

  /// No description provided for @pasteCardAlert.
  ///
  /// In ko, this message translates to:
  /// **'카드 알림 문구 붙여넣기'**
  String get pasteCardAlert;

  /// No description provided for @pasteCardAlertHint.
  ///
  /// In ko, this message translates to:
  /// **'카드 앱·문자로 받은 해외 승인 알림 내용을 붙여넣으세요.'**
  String get pasteCardAlertHint;

  /// No description provided for @pasteCardAlertFailed.
  ///
  /// In ko, this message translates to:
  /// **'해외 결제 승인 알림으로 읽지 못했어요. 직접 입력해 주세요.'**
  String get pasteCardAlertFailed;

  /// No description provided for @cardReadNotice.
  ///
  /// In ko, this message translates to:
  /// **'카드 알림에서 읽은 내용입니다. 확인하고 고친 뒤 저장하세요.'**
  String get cardReadNotice;

  /// No description provided for @read.
  ///
  /// In ko, this message translates to:
  /// **'읽기'**
  String get read;

  /// No description provided for @privacyPolicy.
  ///
  /// In ko, this message translates to:
  /// **'개인정보처리방침'**
  String get privacyPolicy;

  /// No description provided for @colHomeRate.
  ///
  /// In ko, this message translates to:
  /// **'적용환율({currency})'**
  String colHomeRate(String currency);

  /// No description provided for @colHomeAmount.
  ///
  /// In ko, this message translates to:
  /// **'환산금액({currency})'**
  String colHomeAmount(String currency);

  /// No description provided for @colHomeTotal.
  ///
  /// In ko, this message translates to:
  /// **'합계({currency})'**
  String colHomeTotal(String currency);

  /// No description provided for @noConvertedYet.
  ///
  /// In ko, this message translates to:
  /// **'환산된 지출이 아직 없습니다'**
  String get noConvertedYet;

  /// No description provided for @approxAmount.
  ///
  /// In ko, this message translates to:
  /// **'≈ {amount}'**
  String approxAmount(String amount);

  /// No description provided for @nationality.
  ///
  /// In ko, this message translates to:
  /// **'국적'**
  String get nationality;

  /// No description provided for @chooseNationality.
  ///
  /// In ko, this message translates to:
  /// **'국적을 선택하세요'**
  String get chooseNationality;

  /// No description provided for @nationalityBody.
  ///
  /// In ko, this message translates to:
  /// **'선택한 나라의 통화로 모든 지출을 환산하고, 앱 언어도 맞춰 드립니다. 나중에 설정에서 바꿀 수 있습니다.'**
  String get nationalityBody;

  /// No description provided for @searchCountry.
  ///
  /// In ko, this message translates to:
  /// **'나라 검색'**
  String get searchCountry;

  /// No description provided for @homeCurrency.
  ///
  /// In ko, this message translates to:
  /// **'환산 통화'**
  String get homeCurrency;

  /// No description provided for @welcomeTitle.
  ///
  /// In ko, this message translates to:
  /// **'여행 경비에 오신 것을 환영합니다'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In ko, this message translates to:
  /// **'구글 계정을 연결하면 기록한 지출이 내 구글 드라이브의 시트에 자동으로 저장됩니다.'**
  String get welcomeBody;

  /// No description provided for @skipForNow.
  ///
  /// In ko, this message translates to:
  /// **'나중에 하기'**
  String get skipForNow;

  /// No description provided for @next.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get next;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'fil',
    'fr',
    'hi',
    'id',
    'ja',
    'ko',
    'mn',
    'ms',
    'my',
    'ru',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'mn':
      return AppLocalizationsMn();
    case 'ms':
      return AppLocalizationsMs();
    case 'my':
      return AppLocalizationsMy();
    case 'ru':
      return AppLocalizationsRu();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
