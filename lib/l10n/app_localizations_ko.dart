// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '여행 경비';

  @override
  String get settings => '설정';

  @override
  String get newTrip => '새 여행';

  @override
  String get editTrip => '여행 수정';

  @override
  String get deleteTrip => '여행 삭제';

  @override
  String get tripTitle => '여행 제목';

  @override
  String get tripTitleHint => '예: 2026 도쿄 가족여행';

  @override
  String get tripTitleRequired => '여행 제목을 입력해 주세요';

  @override
  String get countryOptional => '나라/도시 (선택)';

  @override
  String get countryHint => '예: 일본 도쿄';

  @override
  String get localCurrency => '현지 통화';

  @override
  String get currency => '통화';

  @override
  String get tripPeriod => '여행 기간';

  @override
  String get save => '저장';

  @override
  String get cancel => '취소';

  @override
  String get delete => '삭제';

  @override
  String get deleteTripConfirmTitle => '여행을 삭제할까요?';

  @override
  String get deleteTripConfirmBody =>
      '이 여행의 모든 지출 내역이 함께 삭제되고, 다음 동기화 때 시트에서도 빠집니다.';

  @override
  String get totalSpent => '총 지출';

  @override
  String pendingRates(int count) {
    return '환율 확인 대기 $count건 (인터넷 연결 후 아래로 당겨 새로고침)';
  }

  @override
  String get firstExpenseHint => '+ 버튼으로 첫 지출을 기록하세요';

  @override
  String get addExpense => '지출 추가';

  @override
  String get editExpense => '지출 수정';

  @override
  String get ratePending => '환율 대기';

  @override
  String get amount => '금액';

  @override
  String get amountRequired => '금액을 입력해 주세요';

  @override
  String get category => '카테고리';

  @override
  String get merchantOptional => '가맹점 (선택)';

  @override
  String get merchantHint => '예: 이치란 라멘';

  @override
  String get paymentOptional => '결제수단 (선택)';

  @override
  String get paymentHint => '예: 신한카드, 현금';

  @override
  String get memoOptional => '메모 (선택)';

  @override
  String get checkingRate => '환율 확인 중…';

  @override
  String get rateUnavailable => '지금은 환율을 가져올 수 없어요. 저장해 두면 연결될 때 환산해 드립니다.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home ($date 기준)';
  }

  @override
  String expenseCount(int count) {
    return '$count건';
  }

  @override
  String krw(String amount) {
    return '$amount원';
  }

  @override
  String get emptyTitle => '첫 여행을 만들어 보세요';

  @override
  String get emptyBody =>
      '해외에서 쓴 돈을 결제한 날의 환율로 내 나라 돈으로 바꿔\n내 구글 시트에 정리해 드립니다.';

  @override
  String get googleSheetsSection => '구글 스프레드시트';

  @override
  String googleSheetsBody(String fileName) {
    return '내 구글 계정으로 로그인하면 내 구글 드라이브에 \"$fileName\" 시트가 만들어지고, 기록할 때마다 자동으로 저장됩니다. 이 앱은 앱이 만든 시트에만 접근하며, 내역은 운영자 서버로 보내지 않습니다.';
  }

  @override
  String get connectGoogle => '구글 계정으로 연결';

  @override
  String get syncNow => '지금 저장';

  @override
  String get openSheet => '시트 열기';

  @override
  String get disconnect => '연결 해제';

  @override
  String get rateInfoTitle => '환율 안내';

  @override
  String get rateInfoBody =>
      '결제한 날짜의 기준환율(유럽중앙은행 고시, 미지원 통화는 공개 환율 자료)로 내 나라 통화 금액을 계산합니다. 주말·공휴일은 직전 영업일 환율을 쓰며, 실제 카드 청구액은 카드사 환율과 수수료 때문에 조금 다를 수 있습니다.';

  @override
  String googleSignInError(String details) {
    return '구글 로그인 오류: $details';
  }

  @override
  String get syncSaved => '시트에 저장됨';

  @override
  String syncFailed(String details) {
    return '시트 저장 실패: $details';
  }

  @override
  String get syncErrorNotSignedIn => '구글 계정에 로그인되어 있지 않습니다.';

  @override
  String get syncErrorNoPermission => '구글 드라이브 권한이 필요합니다. 다시 연결해 주세요.';

  @override
  String get syncErrorExpired => '구글 로그인이 만료되었습니다. 다시 연결해 주세요.';

  @override
  String get language => '언어';

  @override
  String get languageSystem => '자동 (국적 기준)';

  @override
  String get catFood => '음식';

  @override
  String get catSnack => '간식/카페';

  @override
  String get catSouvenir => '기념품';

  @override
  String get catShopping => '쇼핑';

  @override
  String get catTransport => '교통';

  @override
  String get catLodging => '숙박';

  @override
  String get catSightseeing => '관광/입장료';

  @override
  String get catOther => '기타';

  @override
  String get sourceManual => '수동';

  @override
  String get sourceReceipt => '영수증';

  @override
  String get sourceCard => '카드 알림';

  @override
  String get sheetFileTitle => '여행 경비';

  @override
  String get tabExpenses => '내역';

  @override
  String get tabTrips => '여행';

  @override
  String get tabSummary => '요약';

  @override
  String get colTrip => '여행';

  @override
  String get colDate => '날짜';

  @override
  String get colTime => '시간';

  @override
  String get colCategory => '카테고리';

  @override
  String get colMerchant => '가맹점';

  @override
  String get colCurrency => '통화';

  @override
  String get colLocalAmount => '현지금액';

  @override
  String get colRateDate => '환율기준일';

  @override
  String get colPayment => '결제수단';

  @override
  String get colSource => '입력방식';

  @override
  String get colMemo => '메모';

  @override
  String get colRateSource => '환율출처';

  @override
  String get colCountry => '국가';

  @override
  String get colStartDate => '시작일';

  @override
  String get colEndDate => '종료일';

  @override
  String get colCount => '건수';

  @override
  String get colShare => '비율(%)';

  @override
  String get scanReceipt => '영수증 촬영';

  @override
  String get pickReceipt => '앨범의 영수증 사진';

  @override
  String get enterManually => '직접 입력';

  @override
  String get readingReceipt => '영수증 읽는 중…';

  @override
  String get receiptReadNotice =>
      '영수증에서 읽은 내용입니다. 확인하고 고친 뒤 저장하세요. 사진은 분석 후 삭제했습니다.';

  @override
  String get receiptNothingFound =>
      '영수증에서 금액을 찾지 못했어요. 직접 입력해 주세요. 사진은 삭제했습니다.';

  @override
  String receiptScanFailed(String details) {
    return '영수증을 읽지 못했습니다: $details';
  }

  @override
  String get photoDeletedNote => '사진은 기기 안에서 분석한 뒤 바로 삭제되며, 어디에도 저장·전송되지 않습니다.';

  @override
  String get cardAlertsSection => '카드 결제 알림 자동 기록';

  @override
  String get cardAlertsBody =>
      '해외에서 카드로 결제하면 카드 앱이나 카카오톡 알림톡으로 오는 승인 알림을 읽어 그 날짜의 여행에 자동으로 기록합니다. 외화 결제 승인 알림만 기기 안에서 처리하고, 다른 알림은 저장하지 않으며 어디로도 보내지 않습니다.';

  @override
  String get cardAlertsOn => '켜짐';

  @override
  String get cardAlertsOff => '꺼짐 (알림 접근 허용 필요)';

  @override
  String get cardAlertsAllow => '알림 접근 허용하기';

  @override
  String get cardAlertsSettings => '알림 접근 설정 열기';

  @override
  String get cardAlertsConsentTitle => '알림 접근 안내';

  @override
  String cardAlertsConsentBody(String appName) {
    return '다음 화면에서 \"$appName\"의 알림 접근을 허용하면, 앱은 휴대폰에 오는 알림 중 해외 카드 결제 승인 알림만 골라 지출로 기록합니다. 알림 내용은 기기 밖으로 보내지 않으며, 언제든 같은 설정에서 끌 수 있습니다.';
  }

  @override
  String get agreeAndContinue => '동의하고 계속';

  @override
  String cardAlertsWaiting(int count) {
    return '결제일에 맞는 여행이 없는 카드 결제 $count건이 기다리고 있어요. 그 기간의 여행을 만들면 자동으로 들어갑니다.';
  }

  @override
  String get pasteCardAlert => '카드 알림 문구 붙여넣기';

  @override
  String get pasteCardAlertHint => '카드 앱·문자로 받은 해외 승인 알림 내용을 붙여넣으세요.';

  @override
  String get pasteCardAlertFailed => '해외 결제 승인 알림으로 읽지 못했어요. 직접 입력해 주세요.';

  @override
  String get cardReadNotice => '카드 알림에서 읽은 내용입니다. 확인하고 고친 뒤 저장하세요.';

  @override
  String get read => '읽기';

  @override
  String get privacyPolicy => '개인정보처리방침';

  @override
  String colHomeRate(String currency) {
    return '적용환율($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return '환산금액($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return '합계($currency)';
  }

  @override
  String get noConvertedYet => '환산된 지출이 아직 없습니다';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => '국적';

  @override
  String get chooseNationality => '국적을 선택하세요';

  @override
  String get nationalityBody =>
      '선택한 나라의 통화로 모든 지출을 환산하고, 앱 언어도 맞춰 드립니다. 나중에 설정에서 바꿀 수 있습니다.';

  @override
  String get searchCountry => '나라 검색';

  @override
  String get homeCurrency => '환산 통화';

  @override
  String get welcomeTitle => '여행 경비에 오신 것을 환영합니다';

  @override
  String get welcomeBody => '구글 계정을 연결하면 기록한 지출이 내 구글 드라이브의 시트에 자동으로 저장됩니다.';

  @override
  String get skipForNow => '나중에 하기';

  @override
  String get next => '다음';

  @override
  String get exportTripSheet => '구글 시트로 저장';

  @override
  String get exportTripSheetSaving => '구글 시트에 저장하는 중…';

  @override
  String exportTripSheetDone(String title) {
    return '\'$title\' 시트에 저장했어요';
  }

  @override
  String get receiptTotalNotFound =>
      '영수증에서 합계 금액을 확인할 수 없어요. 금액과 통화를 직접 입력해 주세요. 사진은 분석 후 삭제했습니다.';

  @override
  String get receiptCurrencyNotFound =>
      '영수증에서 통화를 확인할 수 없어요. 금액을 확인하고 통화를 직접 골라 주세요. 사진은 분석 후 삭제했습니다.';

  @override
  String get currencyRequired => '통화를 골라 주세요';

  @override
  String batchTitle(int count) {
    return '결제 $count건 읽음';
  }

  @override
  String get batchHint => '저장할 건을 고르세요. 금액을 누르면 고칠 수 있어요.';

  @override
  String batchSave(int count) {
    return '선택한 $count건 저장';
  }

  @override
  String batchSaved(int count) {
    return '$count건 저장했어요';
  }

  @override
  String get batchOutsideTrip => '여행 기간 밖';

  @override
  String get batchDuplicate => '이미 저장된 건';

  @override
  String get batchNeedsInput => '통화·금액 확인 필요 · 금액을 눌러 입력';

  @override
  String get scanIncomplete => '읽지 못한 결제 건이 있어요. 건별로 직접 입력해 주세요.';
}
