// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '旅行経費';

  @override
  String get settings => '設定';

  @override
  String get newTrip => '新しい旅行';

  @override
  String get editTrip => '旅行を編集';

  @override
  String get deleteTrip => '旅行を削除';

  @override
  String get tripTitle => '旅行名';

  @override
  String get tripTitleHint => '例：2026 東京家族旅行';

  @override
  String get tripTitleRequired => '旅行名を入力してください';

  @override
  String get countryOptional => '国・都市（任意）';

  @override
  String get countryHint => '例：日本 東京';

  @override
  String get localCurrency => '現地通貨';

  @override
  String get currency => '通貨';

  @override
  String get tripPeriod => '旅行期間';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get deleteTripConfirmTitle => 'この旅行を削除しますか？';

  @override
  String get deleteTripConfirmBody => 'この旅行のすべての支出が削除され、次回の同期でシートからも削除されます。';

  @override
  String get totalSpent => '支出合計';

  @override
  String pendingRates(int count) {
    return '為替レート待ち $count件（オンライン時に下に引いて更新）';
  }

  @override
  String get firstExpenseHint => '＋ボタンで最初の支出を記録しましょう';

  @override
  String get addExpense => '支出を追加';

  @override
  String get editExpense => '支出を編集';

  @override
  String get ratePending => 'レート待ち';

  @override
  String get amount => '金額';

  @override
  String get amountRequired => '金額を入力してください';

  @override
  String get category => 'カテゴリ';

  @override
  String get merchantOptional => '店舗（任意）';

  @override
  String get merchantHint => '例：一蘭ラーメン';

  @override
  String get paymentOptional => '支払方法（任意）';

  @override
  String get paymentHint => '例：クレジットカード、現金';

  @override
  String get memoOptional => 'メモ（任意）';

  @override
  String get checkingRate => '為替レートを確認中…';

  @override
  String get rateUnavailable => '現在為替レートを取得できません。保存しておけば、接続時にウォンへ換算します。';

  @override
  String approxKrw(String amount) {
    return '≈ $amount';
  }

  @override
  String rateInfo(String currency, String rate, String date) {
    return '1 $currency = $rateウォン（$date時点）';
  }

  @override
  String expenseCount(int count) {
    return '$count件';
  }

  @override
  String krw(String amount) {
    return '$amountウォン';
  }

  @override
  String get emptyTitle => '最初の旅行を作成しましょう';

  @override
  String get emptyBody =>
      '海外での支出を支払日のレートでウォンに換算し、\nあなたの Google スプレッドシートに整理します。';

  @override
  String get googleSheetsSection => 'Google スプレッドシート';

  @override
  String googleSheetsBody(String fileName) {
    return 'Google アカウントでログインすると、あなたの Google ドライブに「$fileName」シートが作成され、記録するたびに自動で保存されます。アプリは自分で作成したシートにのみアクセスし、データを運営者のサーバーに送ることはありません。';
  }

  @override
  String get connectGoogle => 'Google アカウントを接続';

  @override
  String get syncNow => '今すぐ保存';

  @override
  String get openSheet => 'シートを開く';

  @override
  String get disconnect => '接続を解除';

  @override
  String get rateInfoTitle => '為替レートについて';

  @override
  String get rateInfoBody =>
      '支払日の基準レート（欧州中央銀行、未対応通貨は公開レートデータ）でウォンを計算します。土日・祝日は直前の営業日のレートを使います。実際のカード請求額はカード会社のレートや手数料により多少異なる場合があります。';

  @override
  String get noKrwYet => 'ウォンに換算された支出はまだありません';

  @override
  String googleSignInError(String details) {
    return 'Google ログインエラー：$details';
  }

  @override
  String get syncSaved => 'シートに保存しました';

  @override
  String syncFailed(String details) {
    return 'シートへの保存に失敗：$details';
  }

  @override
  String get syncErrorNotSignedIn => 'Google アカウントにログインしていません。';

  @override
  String get syncErrorNoPermission => 'Google ドライブの権限が必要です。再接続してください。';

  @override
  String get syncErrorExpired => 'Google ログインの有効期限が切れました。再接続してください。';

  @override
  String get language => '言語';

  @override
  String get languageSystem => '端末の設定に従う';

  @override
  String get catFood => '食事';

  @override
  String get catSnack => 'おやつ・カフェ';

  @override
  String get catSouvenir => 'お土産';

  @override
  String get catShopping => 'ショッピング';

  @override
  String get catTransport => '交通';

  @override
  String get catLodging => '宿泊';

  @override
  String get catSightseeing => '観光・入場料';

  @override
  String get catOther => 'その他';

  @override
  String get sourceManual => '手入力';

  @override
  String get sourceReceipt => 'レシート';

  @override
  String get sourceCard => 'カード通知';

  @override
  String get sheetFileTitle => '旅行経費';

  @override
  String get tabExpenses => '明細';

  @override
  String get tabTrips => '旅行';

  @override
  String get tabSummary => '集計';

  @override
  String get colTrip => '旅行';

  @override
  String get colDate => '日付';

  @override
  String get colTime => '時刻';

  @override
  String get colCategory => 'カテゴリ';

  @override
  String get colMerchant => '店舗';

  @override
  String get colCurrency => '通貨';

  @override
  String get colLocalAmount => '現地金額';

  @override
  String get colKrwRate => 'レート（ウォン）';

  @override
  String get colRateDate => 'レート基準日';

  @override
  String get colKrwAmount => 'ウォン金額';

  @override
  String get colPayment => '支払方法';

  @override
  String get colSource => '入力方法';

  @override
  String get colMemo => 'メモ';

  @override
  String get colRateSource => 'レート出典';

  @override
  String get colCountry => '国';

  @override
  String get colStartDate => '開始日';

  @override
  String get colEndDate => '終了日';

  @override
  String get colKrwTotal => 'ウォン合計';

  @override
  String get colCount => '件数';

  @override
  String get colShare => '割合(%)';

  @override
  String get scanReceipt => 'レシートを撮影';

  @override
  String get pickReceipt => 'アルバムのレシート写真';

  @override
  String get enterManually => '手入力';

  @override
  String get readingReceipt => 'レシートを読み取り中…';

  @override
  String get receiptReadNotice =>
      'レシートから読み取りました。確認・修正してから保存してください。写真は解析後に削除しました。';

  @override
  String get receiptNothingFound => 'レシートから金額を読み取れませんでした。手入力してください。写真は削除しました。';

  @override
  String receiptScanFailed(String details) {
    return 'レシートを読み取れませんでした：$details';
  }

  @override
  String get photoDeletedNote => '写真は端末内で解析した後すぐに削除され、保存・送信されることはありません。';

  @override
  String get cardAlertsSection => 'カード決済通知の自動記録';

  @override
  String get cardAlertsBody =>
      '海外でカード決済すると、カードアプリ（またはメッセンジャー）の承認通知を読み取り、その日の旅行に自動で記録します。外貨決済の承認通知だけを端末内で処理し、他の通知は保存も送信もしません。';

  @override
  String get cardAlertsOn => 'オン';

  @override
  String get cardAlertsOff => 'オフ（通知へのアクセス許可が必要）';

  @override
  String get cardAlertsAllow => '通知へのアクセスを許可';

  @override
  String get cardAlertsSettings => '通知アクセス設定を開く';

  @override
  String get cardAlertsConsentTitle => '通知へのアクセスについて';

  @override
  String cardAlertsConsentBody(String appName) {
    return '次の画面で「$appName」の通知へのアクセスを許可すると、アプリは届いた通知のうち海外カード決済の承認通知だけを支出として記録します。通知内容は端末の外に送られず、同じ設定からいつでもオフにできます。';
  }

  @override
  String get agreeAndContinue => '同意して続行';

  @override
  String cardAlertsWaiting(int count) {
    return '支払日に合う旅行がないカード決済が $count件あります。その期間の旅行を作成すると自動で追加されます。';
  }

  @override
  String get pasteCardAlert => 'カード通知の文面を貼り付け';

  @override
  String get pasteCardAlertHint => 'カードアプリやSMSで届いた海外承認通知を貼り付けてください。';

  @override
  String get pasteCardAlertFailed => '海外決済の承認通知として読み取れませんでした。手入力してください。';

  @override
  String get cardReadNotice => 'カード通知から読み取りました。確認・修正してから保存してください。';

  @override
  String get read => '読み取る';

  @override
  String get privacyPolicy => 'プライバシーポリシー';
}
