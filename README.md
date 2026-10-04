# 여행 경비 (Travel Expense)

여행에서 쓴 돈을 **결제한 날의 환율로 사용자 나라 통화로 바꿔**, 사용자 **본인의 구글 스프레드시트**에 정리해 주는 Flutter 앱입니다.
Google Play 출시를 먼저 하고, 같은 코드로 App Store 에도 출시합니다.

## 주요 기능

- 여행 만들기: 제목, 나라/도시, 현지 통화, 기간
- 지출 기록: 금액·통화·카테고리(음식, 간식/카페, 기념품, 쇼핑, 교통, 숙박, 관광/입장료, 기타)·날짜·시간·가맹점·결제수단·메모
- 첫 실행: 구글 연결(또는 나중에 하기) → 국적 선택. 국적이 환산 통화와 앱 언어를 정함 (설정에서 변경 가능)
  - 한국인은 원화로, 한국에 온 외국인은 원화 지출을 자기 나라 통화로 환산
- 결제일 기준 내 나라 통화 환산
  - 1순위 [Frankfurter](https://frankfurter.dev) (유럽중앙은행 고시 환율), 미지원 통화(VND, TWD 등)는 [currency-api](https://github.com/fawazahmed0/exchange-api)
  - 주말·공휴일은 직전 영업일 환율, 실제 적용일을 함께 기록
  - 인터넷이 끊겨도 먼저 저장하고, 연결되면 환율을 채움
- 영수증 촬영(또는 앨범 사진) → 기기 안 OCR(Google ML Kit)로 합계·통화·날짜·가맹점·품목·카테고리를 찾아 확인 화면에 채움
  - 여행지 통화에 맞춰 한·중·일·라틴 문자 모델을 고름
  - 사진은 분석 직후 삭제되며 어디에도 저장·전송되지 않음 (앨범에서 고른 경우 앱이 받은 사본만 지우고 원본은 그대로)
- 여행별 카테고리 파이차트
- 한국어·영어·중국어(간체)·일본어. 국적이 한국이면 한국어, 중국·대만·홍콩·마카오는 중국어, 일본은 일본어, 그 외 나라는 영어. 국적을 고르기 전 첫 화면은 기기(Google Play) 언어를 따르고, 지원하지 않는 언어면 한국어. 설정에서 직접 바꿀 수 있음
- 사용자 본인 구글 드라이브의 `여행 경비` 시트에 자동 저장 (`내역`, `여행`, `요약` 탭)

다음 단계: 카드 앱 결제 알림 자동 기록 → 시트 안 파이차트 → 스토어 출시.

## 데이터와 개인정보

- 각 사용자는 **자기 구글 계정**으로 로그인하고, 시트는 **그 사용자의 드라이브**에 만들어집니다. 운영자 계정이나 서버는 사용자 데이터를 받지 않습니다.
- 요청하는 권한은 `drive.file` 하나뿐입니다. 앱이 직접 만든 파일에만 접근할 수 있고, 사용자의 다른 드라이브 파일은 볼 수 없습니다.
- 시트의 머리글·탭 이름·카테고리는 앱 언어로 쓰고, 언어를 바꾸면 다음 저장 때 바뀝니다 (탭은 고정 ID 로 찾음).
- 원본 데이터는 기기 안(SQLite)에 있고 시트는 사본입니다. 동기화할 때 각 탭을 통째로 다시 쓰므로, 시트에서 직접 고친 내용은 다음 동기화 때 덮어써집니다. 따로 정리하려면 새 탭을 만들어 쓰세요.

## 구조

```
lib/
  main.dart                      앱 시작, 의존성 연결
  models/                        여행·지출·카테고리·통화
  data/expense_repository.dart   기기 안 SQLite 저장소 + 환율 캐시
  services/
    exchange_rate_service.dart   결제일 환율 조회
    google_account_service.dart  사용자 구글 로그인 (drive.file 권한)
    sheets_sync_service.dart     사용자 시트 생성·찾기·쓰기
    sheet_rows.dart              시트에 쓸 표 만들기 (순수 함수)
    receipt_scanner.dart         영수증 사진 → OCR → 사진 삭제
    receipt_parser.dart          OCR 글자에서 합계·날짜·품목 찾기 (순수 함수)
  l10n/                          화면 문구 (app_ko/en/zh/ja.arb, 생성 코드)
  state/app_state.dart           저장 → 환율 → 시트 동기화 흐름
  state/locale_controller.dart   언어 선택
  ui/                            화면과 파이차트
```

## 개발 환경

```bash
flutter pub get
flutter analyze
flutter test
flutter gen-l10n   # 문구(arb)를 바꾼 뒤
flutter run --dart-define=GOOGLE_SERVER_CLIENT_ID=<웹 클라이언트 ID>
```

Flutter 3.47 (Dart 3.13) 기준입니다. GitHub Actions 가 PR 마다 분석·테스트를 돌리고 APK 를 만들어 Artifacts 에 올립니다.

## 구글 로그인 설정 (운영자가 한 번만)

구글 로그인과 시트 저장을 쓰려면 Google Cloud 프로젝트가 필요합니다.

1. [Google Cloud 콘솔](https://console.cloud.google.com)에서 새 프로젝트를 만듭니다.
2. **API 및 서비스 → 라이브러리**에서 **Google Sheets API** 와 **Google Drive API** 를 사용 설정합니다.
3. **OAuth 동의 화면**: 사용자 유형 "외부", 앱 이름·지원 이메일·개인정보처리방침 URL 을 넣고, 범위에 `.../auth/drive.file` 을 추가합니다. 출시 전에는 "테스트" 상태로 두고 테스트 사용자(최대 100명)를 등록합니다.
4. **사용자 인증 정보 → OAuth 클라이언트 ID** 를 두 개 만듭니다.
   - **Android**: 패키지 이름 `com.gotomounting.travelexpense`, 서명 인증서 SHA-1 (아래 서명 키의 SHA-1. Play 출시 후에는 Play Console 의 "앱 서명 키" SHA-1 도 추가)
   - **웹 애플리케이션**: 이 클라이언트 ID 가 `GOOGLE_SERVER_CLIENT_ID` 입니다.
5. GitHub 저장소 **Settings → Secrets and variables → Actions → Variables** 에 `GOOGLE_SERVER_CLIENT_ID` 를 추가합니다.

### 서명 키

구글 로그인은 APK 서명 키의 SHA-1 이 콘솔에 등록된 것과 같아야 동작합니다. CI 의 기본 디버그 키는 매번 바뀌므로 업로드 키를 하나 만들어 씁니다.

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
keytool -list -v -keystore upload-keystore.jks -alias upload   # SHA-1 확인
base64 -w0 upload-keystore.jks                                  # Secrets 에 넣을 값
```

GitHub **Secrets** 에 `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` 를 넣으면 CI 가 그 키로 서명합니다.
로컬에서는 `android/key.properties` 에 같은 값을 적습니다 (`storeFile` 은 `android/app` 기준 경로). 키 파일과 `key.properties` 는 커밋하지 않습니다.

### iOS (App Store 단계에서)

iOS 는 ML Kit 때문에 최소 iOS 15.5 가 필요하고, 한·중·일 OCR 모델 Pod(GoogleMLKit/TextRecognitionChinese 등)을 Podfile 에 추가해야 합니다. iOS 용 OAuth 클라이언트를 만들고 `ios/Runner/Info.plist` 에 `GIDClientID` 와 URL scheme(역순 클라이언트 ID)을 추가해야 합니다. iOS 는 다른 앱의 알림을 읽을 수 없어서 카드 알림 자동 기록은 안드로이드 전용이고, iOS 는 붙여넣기·공유 방식으로 대신합니다.
