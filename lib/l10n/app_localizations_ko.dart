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
  String get rateUnavailable => '지금은 환율을 가져올 수 없어요. 저장해 두면 연결될 때 원화로 바꿔 드립니다.';

  @override
  String approxKrw(String amount) {
    return '≈ $amount';
  }

  @override
  String rateInfo(String currency, String rate, String date) {
    return '1 $currency = $rate원 ($date 기준)';
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
  String get emptyBody => '해외에서 쓴 돈을 결제한 날의 환율로 원화로 바꿔\n내 구글 시트에 정리해 드립니다.';

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
      '결제한 날짜의 기준환율(유럽중앙은행 고시, 미지원 통화는 공개 환율 자료)로 원화를 계산합니다. 주말·공휴일은 직전 영업일 환율을 쓰며, 실제 카드 청구액은 카드사 환율과 수수료 때문에 조금 다를 수 있습니다.';

  @override
  String get noKrwYet => '원화로 환산된 지출이 아직 없습니다';

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
  String get languageSystem => '기기 설정 따르기';

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
  String get colKrwRate => '적용환율(원)';

  @override
  String get colRateDate => '환율기준일';

  @override
  String get colKrwAmount => '원화금액';

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
  String get colKrwTotal => '원화합계';

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
}
