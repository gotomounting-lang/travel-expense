// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '旅行记账';

  @override
  String get settings => '设置';

  @override
  String get newTrip => '新建旅行';

  @override
  String get editTrip => '编辑旅行';

  @override
  String get deleteTrip => '删除旅行';

  @override
  String get tripTitle => '旅行名称';

  @override
  String get tripTitleHint => '例如：2026 东京家庭旅行';

  @override
  String get tripTitleRequired => '请输入旅行名称';

  @override
  String get countryOptional => '国家/城市（可选）';

  @override
  String get countryHint => '例如：日本 东京';

  @override
  String get localCurrency => '当地货币';

  @override
  String get currency => '货币';

  @override
  String get tripPeriod => '旅行日期';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get deleteTripConfirmTitle => '要删除此旅行吗？';

  @override
  String get deleteTripConfirmBody => '此旅行的所有支出都会被删除，并在下次同步时从表格中移除。';

  @override
  String get totalSpent => '总支出';

  @override
  String pendingRates(int count) {
    return '$count 笔等待汇率（联网后下拉刷新）';
  }

  @override
  String get firstExpenseHint => '点击 + 记录第一笔支出';

  @override
  String get addExpense => '添加支出';

  @override
  String get editExpense => '编辑支出';

  @override
  String get ratePending => '等待汇率';

  @override
  String get amount => '金额';

  @override
  String get amountRequired => '请输入金额';

  @override
  String get category => '类别';

  @override
  String get merchantOptional => '商户（可选）';

  @override
  String get merchantHint => '例如：一兰拉面';

  @override
  String get paymentOptional => '支付方式（可选）';

  @override
  String get paymentHint => '例如：信用卡、现金';

  @override
  String get memoOptional => '备注（可选）';

  @override
  String get checkingRate => '正在获取汇率…';

  @override
  String get rateUnavailable => '暂时无法获取汇率。先保存，联网后会自动换算。';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home（$date）';
  }

  @override
  String expenseCount(int count) {
    return '$count 笔';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => '创建你的第一次旅行';

  @override
  String get emptyBody => '按付款当天的汇率将境外消费换算为本国货币，\n并整理到你自己的 Google 表格中。';

  @override
  String get googleSheetsSection => 'Google 表格';

  @override
  String googleSheetsBody(String fileName) {
    return '使用你的 Google 账号登录后，会在你自己的 Google 云端硬盘中创建“$fileName”表格，每次记录时自动保存。本应用只能访问它创建的表格，你的数据不会发送到运营方服务器。';
  }

  @override
  String get connectGoogle => '连接 Google 账号';

  @override
  String get syncNow => '立即保存';

  @override
  String get openSheet => '打开表格';

  @override
  String get disconnect => '断开连接';

  @override
  String get rateInfoTitle => '汇率说明';

  @override
  String get rateInfoBody =>
      '按付款当天的参考汇率（欧洲央行公布，不支持的货币使用公开汇率数据）换算为本国货币。周末和节假日使用前一个工作日的汇率。实际信用卡账单可能因发卡行汇率和手续费略有不同。';

  @override
  String googleSignInError(String details) {
    return 'Google 登录错误：$details';
  }

  @override
  String get syncSaved => '已保存到表格';

  @override
  String syncFailed(String details) {
    return '保存到表格失败：$details';
  }

  @override
  String get syncErrorNotSignedIn => '尚未登录 Google 账号。';

  @override
  String get syncErrorNoPermission => '需要 Google 云端硬盘权限，请重新连接。';

  @override
  String get syncErrorExpired => 'Google 登录已过期，请重新连接。';

  @override
  String get language => '语言';

  @override
  String get languageSystem => '自动（按国籍）';

  @override
  String get catFood => '餐饮';

  @override
  String get catSnack => '零食/咖啡';

  @override
  String get catSouvenir => '纪念品';

  @override
  String get catShopping => '购物';

  @override
  String get catTransport => '交通';

  @override
  String get catLodging => '住宿';

  @override
  String get catSightseeing => '观光/门票';

  @override
  String get catOther => '其他';

  @override
  String get sourceManual => '手动';

  @override
  String get sourceReceipt => '收据';

  @override
  String get sourceCard => '银行卡通知';

  @override
  String get sheetFileTitle => '旅行记账';

  @override
  String get tabExpenses => '明细';

  @override
  String get tabTrips => '旅行';

  @override
  String get tabSummary => '汇总';

  @override
  String get colTrip => '旅行';

  @override
  String get colDate => '日期';

  @override
  String get colTime => '时间';

  @override
  String get colCategory => '类别';

  @override
  String get colMerchant => '商户';

  @override
  String get colCurrency => '货币';

  @override
  String get colLocalAmount => '当地金额';

  @override
  String get colRateDate => '汇率日期';

  @override
  String get colPayment => '支付方式';

  @override
  String get colSource => '录入方式';

  @override
  String get colMemo => '备注';

  @override
  String get colRateSource => '汇率来源';

  @override
  String get colCountry => '国家';

  @override
  String get colStartDate => '开始日期';

  @override
  String get colEndDate => '结束日期';

  @override
  String get colCount => '笔数';

  @override
  String get colShare => '占比(%)';

  @override
  String get scanReceipt => '拍摄收据';

  @override
  String get pickReceipt => '从相册选择收据';

  @override
  String get enterManually => '手动输入';

  @override
  String get readingReceipt => '正在识别收据…';

  @override
  String get receiptReadNotice => '已根据收据填写。请检查修改后保存。照片已在识别后删除。';

  @override
  String get receiptNothingFound => '未能从收据中识别金额，请手动输入。照片已删除。';

  @override
  String receiptScanFailed(String details) {
    return '无法识别收据：$details';
  }

  @override
  String get photoDeletedNote => '照片仅在设备上识别并立即删除，不会保存或上传。';

  @override
  String get cardAlertsSection => '自动记录银行卡消费通知';

  @override
  String get cardAlertsBody =>
      '在境外刷卡时，读取银行卡应用（或消息应用）发来的消费通知，并自动记录到当天的旅行中。仅在设备上处理外币消费通知，其他通知不会保存或发送到任何地方。';

  @override
  String get cardAlertsOn => '已开启';

  @override
  String get cardAlertsOff => '未开启（需要通知使用权）';

  @override
  String get cardAlertsAllow => '允许通知使用权';

  @override
  String get cardAlertsSettings => '打开通知使用权设置';

  @override
  String get cardAlertsConsentTitle => '关于通知使用权';

  @override
  String cardAlertsConsentBody(String appName) {
    return '请在下一个页面允许“$appName”使用通知。应用只会从通知中挑选境外银行卡消费通知并记为支出。通知内容不会离开你的设备，你可以随时在同一设置中关闭。';
  }

  @override
  String get agreeAndContinue => '同意并继续';

  @override
  String cardAlertsWaiting(int count) {
    return '有 $count 笔银行卡消费没有对应日期的旅行。创建该期间的旅行后会自动加入。';
  }

  @override
  String get pasteCardAlert => '粘贴银行卡通知内容';

  @override
  String get pasteCardAlertHint => '粘贴银行卡应用或短信收到的境外消费通知。';

  @override
  String get pasteCardAlertFailed => '无法识别为境外消费通知，请手动输入。';

  @override
  String get cardReadNotice => '已根据银行卡通知填写，请检查修改后保存。';

  @override
  String get read => '识别';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String colHomeRate(String currency) {
    return '汇率（$currency）';
  }

  @override
  String colHomeAmount(String currency) {
    return '换算金额（$currency）';
  }

  @override
  String colHomeTotal(String currency) {
    return '合计（$currency）';
  }

  @override
  String get noConvertedYet => '还没有已换算的支出';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => '国籍';

  @override
  String get chooseNationality => '请选择你的国籍';

  @override
  String get nationalityBody => '所有支出都将换算为你所在国家的货币，应用语言也会随之设置。之后可在设置中更改。';

  @override
  String get searchCountry => '搜索国家';

  @override
  String get homeCurrency => '换算货币';

  @override
  String get welcomeTitle => '欢迎使用旅行记账';

  @override
  String get welcomeBody => '连接 Google 账号后，记录的支出会自动保存到你自己的 Google 云端硬盘中的表格。';

  @override
  String get skipForNow => '以后再说';

  @override
  String get next => '下一步';
}
