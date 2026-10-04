// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Cài đặt';

  @override
  String get newTrip => 'Chuyến đi mới';

  @override
  String get editTrip => 'Sửa chuyến đi';

  @override
  String get deleteTrip => 'Xóa chuyến đi';

  @override
  String get tripTitle => 'Tên chuyến đi';

  @override
  String get tripTitleHint => 'VD: Du lịch gia đình Tokyo 2026';

  @override
  String get tripTitleRequired => 'Vui lòng nhập tên chuyến đi';

  @override
  String get countryOptional => 'Quốc gia/thành phố (không bắt buộc)';

  @override
  String get countryHint => 'VD: Tokyo, Nhật Bản';

  @override
  String get localCurrency => 'Tiền tệ địa phương';

  @override
  String get currency => 'Tiền tệ';

  @override
  String get tripPeriod => 'Thời gian chuyến đi';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get deleteTripConfirmTitle => 'Xóa chuyến đi này?';

  @override
  String get deleteTripConfirmBody =>
      'Tất cả khoản chi trong chuyến đi này sẽ bị xóa và được gỡ khỏi bảng tính ở lần đồng bộ tiếp theo.';

  @override
  String get totalSpent => 'Tổng chi tiêu';

  @override
  String pendingRates(int count) {
    return '$count khoản đang chờ tỷ giá (kéo xuống để làm mới khi có mạng)';
  }

  @override
  String get firstExpenseHint => 'Nhấn + để ghi khoản chi đầu tiên';

  @override
  String get addExpense => 'Thêm khoản chi';

  @override
  String get editExpense => 'Sửa khoản chi';

  @override
  String get ratePending => 'Chờ tỷ giá';

  @override
  String get amount => 'Số tiền';

  @override
  String get amountRequired => 'Vui lòng nhập số tiền';

  @override
  String get category => 'Danh mục';

  @override
  String get merchantOptional => 'Cửa hàng (không bắt buộc)';

  @override
  String get merchantHint => 'VD: Ichiran Ramen';

  @override
  String get paymentOptional => 'Phương thức thanh toán (không bắt buộc)';

  @override
  String get paymentHint => 'VD: thẻ Visa, tiền mặt';

  @override
  String get memoOptional => 'Ghi chú (không bắt buộc)';

  @override
  String get checkingRate => 'Đang kiểm tra tỷ giá…';

  @override
  String get rateUnavailable =>
      'Hiện không lấy được tỷ giá. Hãy cứ lưu lại, chúng tôi sẽ quy đổi khi bạn có mạng.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (ngày $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khoản chi',
      one: '1 khoản chi',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Tạo chuyến đi đầu tiên';

  @override
  String get emptyBody =>
      'Chúng tôi quy đổi số tiền bạn chi ở nước ngoài sang tiền tệ nước bạn theo tỷ giá ngày thanh toán\nvà lưu vào bảng tính Google Sheets của riêng bạn.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Đăng nhập bằng tài khoản Google, bảng tính \"$fileName\" sẽ được tạo trong Google Drive của bạn và cập nhật mỗi khi bạn ghi một khoản chi. Ứng dụng chỉ truy cập được bảng tính do nó tạo ra, và dữ liệu của bạn không bao giờ được gửi đến máy chủ của chúng tôi.';
  }

  @override
  String get connectGoogle => 'Kết nối tài khoản Google';

  @override
  String get syncNow => 'Lưu ngay';

  @override
  String get openSheet => 'Mở bảng tính';

  @override
  String get disconnect => 'Ngắt kết nối';

  @override
  String get rateInfoTitle => 'Về tỷ giá';

  @override
  String get rateInfoBody =>
      'Số tiền theo tiền tệ nước bạn dùng tỷ giá tham chiếu của ngày thanh toán (Ngân hàng Trung ương Châu Âu, hoặc dữ liệu tỷ giá công khai cho các loại tiền khác). Cuối tuần và ngày lễ dùng tỷ giá của ngày làm việc liền trước. Số tiền thực tế trên sao kê thẻ có thể chênh lệch đôi chút do tỷ giá và phí của ngân hàng phát hành thẻ.';

  @override
  String googleSignInError(String details) {
    return 'Lỗi đăng nhập Google: $details';
  }

  @override
  String get syncSaved => 'Đã lưu vào bảng tính';

  @override
  String syncFailed(String details) {
    return 'Không lưu được vào bảng tính: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Bạn chưa đăng nhập Google.';

  @override
  String get syncErrorNoPermission =>
      'Cần quyền truy cập Google Drive. Vui lòng kết nối lại.';

  @override
  String get syncErrorExpired =>
      'Phiên đăng nhập Google đã hết hạn. Vui lòng kết nối lại.';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Tự động (theo quốc tịch)';

  @override
  String get catFood => 'Ăn uống';

  @override
  String get catSnack => 'Ăn vặt/Cà phê';

  @override
  String get catSouvenir => 'Quà lưu niệm';

  @override
  String get catShopping => 'Mua sắm';

  @override
  String get catTransport => 'Đi lại';

  @override
  String get catLodging => 'Lưu trú';

  @override
  String get catSightseeing => 'Tham quan';

  @override
  String get catOther => 'Khác';

  @override
  String get sourceManual => 'Thủ công';

  @override
  String get sourceReceipt => 'Hóa đơn';

  @override
  String get sourceCard => 'Thông báo thẻ';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Chi tiêu';

  @override
  String get tabTrips => 'Chuyến đi';

  @override
  String get tabSummary => 'Tổng hợp';

  @override
  String get colTrip => 'Chuyến đi';

  @override
  String get colDate => 'Ngày';

  @override
  String get colTime => 'Giờ';

  @override
  String get colCategory => 'Danh mục';

  @override
  String get colMerchant => 'Cửa hàng';

  @override
  String get colCurrency => 'Tiền tệ';

  @override
  String get colLocalAmount => 'Số tiền địa phương';

  @override
  String get colRateDate => 'Ngày tỷ giá';

  @override
  String get colPayment => 'Thanh toán';

  @override
  String get colSource => 'Nguồn';

  @override
  String get colMemo => 'Ghi chú';

  @override
  String get colRateSource => 'Nguồn tỷ giá';

  @override
  String get colCountry => 'Quốc gia';

  @override
  String get colStartDate => 'Bắt đầu';

  @override
  String get colEndDate => 'Kết thúc';

  @override
  String get colCount => 'Số lượng';

  @override
  String get colShare => 'Tỷ lệ (%)';

  @override
  String get scanReceipt => 'Quét hóa đơn';

  @override
  String get pickReceipt => 'Hóa đơn từ thư viện ảnh';

  @override
  String get enterManually => 'Nhập thủ công';

  @override
  String get readingReceipt => 'Đang đọc hóa đơn…';

  @override
  String get receiptReadNotice =>
      'Đã điền từ hóa đơn. Hãy kiểm tra và sửa trước khi lưu. Ảnh đã được xóa sau khi phân tích.';

  @override
  String get receiptNothingFound =>
      'Không tìm thấy số tiền trên hóa đơn. Vui lòng nhập thủ công. Ảnh đã được xóa.';

  @override
  String receiptScanFailed(String details) {
    return 'Không đọc được hóa đơn: $details';
  }

  @override
  String get photoDeletedNote =>
      'Ảnh được phân tích ngay trên thiết bị và xóa ngay sau đó. Ảnh không bao giờ được lưu trữ hay tải lên.';

  @override
  String get cardAlertsSection => 'Tự động ghi thông báo thanh toán thẻ';

  @override
  String get cardAlertsBody =>
      'Khi bạn thanh toán bằng thẻ ở nước ngoài, thông báo giao dịch từ ứng dụng thẻ (hoặc ứng dụng nhắn tin) sẽ được đọc và ghi vào chuyến đi của ngày đó. Chỉ thông báo giao dịch bằng ngoại tệ được xử lý, ngay trên thiết bị của bạn. Các thông báo khác không bao giờ được lưu hay gửi đi đâu.';

  @override
  String get cardAlertsOn => 'Bật';

  @override
  String get cardAlertsOff => 'Tắt (cần quyền truy cập thông báo)';

  @override
  String get cardAlertsAllow => 'Cho phép truy cập thông báo';

  @override
  String get cardAlertsSettings => 'Mở cài đặt truy cập thông báo';

  @override
  String get cardAlertsConsentTitle => 'Về quyền truy cập thông báo';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Ở màn hình tiếp theo, hãy cho phép \"$appName\" truy cập thông báo. Ứng dụng sẽ chỉ lọc ra các thông báo thanh toán thẻ ở nước ngoài và ghi chúng thành khoản chi. Nội dung thông báo không bao giờ rời khỏi thiết bị, và bạn có thể tắt tính năng này bất cứ lúc nào trong cùng phần cài đặt.';
  }

  @override
  String get agreeAndContinue => 'Đồng ý và tiếp tục';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giao dịch thẻ',
      one: '1 giao dịch thẻ',
    );
    return '$_temp0 đang chờ chuyến đi có ngày thanh toán tương ứng. Hãy tạo chuyến đi đó, các giao dịch sẽ được thêm tự động.';
  }

  @override
  String get pasteCardAlert => 'Dán nội dung thông báo thẻ';

  @override
  String get pasteCardAlertHint =>
      'Dán thông báo giao dịch bạn nhận được từ ứng dụng thẻ hoặc SMS.';

  @override
  String get pasteCardAlertFailed =>
      'Không nhận diện được đây là giao dịch thanh toán ở nước ngoài. Vui lòng nhập thủ công.';

  @override
  String get cardReadNotice =>
      'Đã điền từ thông báo thẻ. Hãy kiểm tra và sửa trước khi lưu.';

  @override
  String get read => 'Đọc';

  @override
  String get privacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String colHomeRate(String currency) {
    return 'Tỷ giá ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Số tiền ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Tổng ($currency)';
  }

  @override
  String get noConvertedYet => 'Chưa có khoản chi nào được quy đổi';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Quốc tịch';

  @override
  String get chooseNationality => 'Chọn quốc tịch của bạn';

  @override
  String get nationalityBody =>
      'Mọi khoản chi sẽ được quy đổi sang tiền tệ nước bạn và ngôn ngữ ứng dụng cũng sẽ được đặt theo đó. Bạn có thể thay đổi sau trong Cài đặt.';

  @override
  String get searchCountry => 'Tìm quốc gia';

  @override
  String get homeCurrency => 'Tiền tệ quy đổi';

  @override
  String get welcomeTitle => 'Chào mừng đến với Travel Expense';

  @override
  String get welcomeBody =>
      'Kết nối tài khoản Google để tự động lưu chi tiêu vào bảng tính trong Google Drive của riêng bạn.';

  @override
  String get skipForNow => 'Để sau';

  @override
  String get next => 'Tiếp';

  @override
  String get exportTripSheet => 'Lưu vào Google Trang tính';

  @override
  String get exportTripSheetSaving => 'Đang lưu vào Google Trang tính…';

  @override
  String exportTripSheetDone(String title) {
    return 'Đã lưu vào trang tính \'$title\'';
  }

  @override
  String get receiptTotalNotFound =>
      'Không xác định được tổng tiền trên hóa đơn. Vui lòng tự nhập số tiền và loại tiền. Ảnh đã được xóa sau khi phân tích.';

  @override
  String get receiptCurrencyNotFound =>
      'Không xác định được loại tiền trên hóa đơn. Hãy kiểm tra số tiền và tự chọn loại tiền. Ảnh đã được xóa sau khi phân tích.';

  @override
  String get currencyRequired => 'Hãy chọn loại tiền';

  @override
  String batchTitle(int count) {
    return 'Đã đọc $count khoản thanh toán';
  }

  @override
  String get batchHint => 'Chọn khoản cần lưu. Chạm vào số tiền để sửa.';

  @override
  String batchSave(int count) {
    return 'Lưu $count khoản đã chọn';
  }

  @override
  String batchSaved(int count) {
    return 'Đã lưu $count khoản';
  }

  @override
  String get batchOutsideTrip => 'Ngoài thời gian chuyến đi';

  @override
  String get batchDuplicate => 'Đã lưu trước đó';

  @override
  String get batchNeedsInput =>
      'Cần kiểm tra số tiền/loại tiền · chạm vào số tiền';

  @override
  String get scanIncomplete =>
      'Có khoản thanh toán không đọc được. Hãy nhập từng khoản.';
}
