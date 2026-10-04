// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Tetapan';

  @override
  String get newTrip => 'Perjalanan baharu';

  @override
  String get editTrip => 'Edit perjalanan';

  @override
  String get deleteTrip => 'Padam perjalanan';

  @override
  String get tripTitle => 'Nama perjalanan';

  @override
  String get tripTitleHint => 'cth. Percutian keluarga ke Tokyo 2026';

  @override
  String get tripTitleRequired => 'Sila masukkan nama perjalanan';

  @override
  String get countryOptional => 'Negara/bandar (pilihan)';

  @override
  String get countryHint => 'cth. Tokyo, Jepun';

  @override
  String get localCurrency => 'Mata wang tempatan';

  @override
  String get currency => 'Mata wang';

  @override
  String get tripPeriod => 'Tarikh perjalanan';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Padam';

  @override
  String get deleteTripConfirmTitle => 'Padam perjalanan ini?';

  @override
  String get deleteTripConfirmBody =>
      'Semua perbelanjaan dalam perjalanan ini akan dipadam dan dikeluarkan daripada helaian anda pada penyegerakan seterusnya.';

  @override
  String get totalSpent => 'Jumlah perbelanjaan';

  @override
  String pendingRates(int count) {
    return '$count menunggu kadar pertukaran (tarik ke bawah untuk muat semula apabila dalam talian)';
  }

  @override
  String get firstExpenseHint =>
      'Ketik + untuk merekod perbelanjaan pertama anda';

  @override
  String get addExpense => 'Tambah perbelanjaan';

  @override
  String get editExpense => 'Edit perbelanjaan';

  @override
  String get ratePending => 'Kadar belum tersedia';

  @override
  String get amount => 'Amaun';

  @override
  String get amountRequired => 'Sila masukkan amaun';

  @override
  String get category => 'Kategori';

  @override
  String get merchantOptional => 'Peniaga (pilihan)';

  @override
  String get merchantHint => 'cth. Ichiran Ramen';

  @override
  String get paymentOptional => 'Kaedah bayaran (pilihan)';

  @override
  String get paymentHint => 'cth. Kad Visa, tunai';

  @override
  String get memoOptional => 'Nota (pilihan)';

  @override
  String get checkingRate => 'Menyemak kadar pertukaran…';

  @override
  String get rateUnavailable =>
      'Kadar pertukaran tidak dapat diperoleh sekarang. Simpan dahulu, dan ia akan ditukar apabila anda dalam talian.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (pada $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perbelanjaan',
      one: '1 perbelanjaan',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Cipta perjalanan pertama anda';

  @override
  String get emptyBody =>
      'Perbelanjaan anda di luar negara ditukar kepada mata wang negara anda mengikut kadar pada tarikh bayaran\ndan disimpan dalam Google Sheet anda sendiri.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Log masuk dengan akaun Google anda, dan helaian \"$fileName\" akan dicipta dalam Google Drive anda sendiri serta dikemas kini setiap kali anda merekod perbelanjaan. Aplikasi hanya boleh mengakses helaian yang diciptanya, dan data anda tidak pernah dihantar ke pelayan kami.';
  }

  @override
  String get connectGoogle => 'Sambungkan akaun Google';

  @override
  String get syncNow => 'Simpan sekarang';

  @override
  String get openSheet => 'Buka helaian';

  @override
  String get disconnect => 'Putuskan sambungan';

  @override
  String get rateInfoTitle => 'Tentang kadar pertukaran';

  @override
  String get rateInfoBody =>
      'Amaun dalam mata wang negara anda menggunakan kadar rujukan pada tarikh bayaran (Bank Pusat Eropah, atau data kadar awam untuk mata wang lain). Hujung minggu dan cuti umum menggunakan kadar hari bekerja sebelumnya. Bil kad sebenar anda mungkin sedikit berbeza disebabkan kadar dan caj pengeluar kad.';

  @override
  String googleSignInError(String details) {
    return 'Ralat log masuk Google: $details';
  }

  @override
  String get syncSaved => 'Disimpan ke helaian';

  @override
  String syncFailed(String details) {
    return 'Gagal menyimpan ke helaian: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Anda belum log masuk ke Google.';

  @override
  String get syncErrorNoPermission =>
      'Kebenaran Google Drive diperlukan. Sila sambung semula.';

  @override
  String get syncErrorExpired =>
      'Log masuk Google anda telah tamat tempoh. Sila sambung semula.';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Automatik (ikut kewarganegaraan)';

  @override
  String get catFood => 'Makanan';

  @override
  String get catSnack => 'Snek/Kafe';

  @override
  String get catSouvenir => 'Cenderamata';

  @override
  String get catShopping => 'Membeli-belah';

  @override
  String get catTransport => 'Pengangkutan';

  @override
  String get catLodging => 'Penginapan';

  @override
  String get catSightseeing => 'Lawatan';

  @override
  String get catOther => 'Lain-lain';

  @override
  String get sourceManual => 'Manual';

  @override
  String get sourceReceipt => 'Resit';

  @override
  String get sourceCard => 'Makluman kad';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Perbelanjaan';

  @override
  String get tabTrips => 'Perjalanan';

  @override
  String get tabSummary => 'Ringkasan';

  @override
  String get colTrip => 'Perjalanan';

  @override
  String get colDate => 'Tarikh';

  @override
  String get colTime => 'Masa';

  @override
  String get colCategory => 'Kategori';

  @override
  String get colMerchant => 'Peniaga';

  @override
  String get colCurrency => 'Mata wang';

  @override
  String get colLocalAmount => 'Amaun tempatan';

  @override
  String get colRateDate => 'Tarikh kadar';

  @override
  String get colPayment => 'Bayaran';

  @override
  String get colSource => 'Sumber';

  @override
  String get colMemo => 'Nota';

  @override
  String get colRateSource => 'Sumber kadar';

  @override
  String get colCountry => 'Negara';

  @override
  String get colStartDate => 'Mula';

  @override
  String get colEndDate => 'Tamat';

  @override
  String get colCount => 'Bilangan';

  @override
  String get colShare => 'Bahagian (%)';

  @override
  String get scanReceipt => 'Imbas resit';

  @override
  String get pickReceipt => 'Resit daripada galeri';

  @override
  String get enterManually => 'Masukkan secara manual';

  @override
  String get readingReceipt => 'Membaca resit…';

  @override
  String get receiptReadNotice =>
      'Diisi daripada resit anda. Semak dan betulkan sebelum menyimpan. Foto telah dipadam selepas dianalisis.';

  @override
  String get receiptNothingFound =>
      'Amaun tidak ditemui pada resit. Sila masukkan secara manual. Foto telah dipadam.';

  @override
  String receiptScanFailed(String details) {
    return 'Tidak dapat membaca resit: $details';
  }

  @override
  String get photoDeletedNote =>
      'Foto dianalisis pada peranti anda dan terus dipadam. Foto tidak pernah disimpan atau dimuat naik.';

  @override
  String get cardAlertsSection => 'Rekod automatik makluman bayaran kad';

  @override
  String get cardAlertsBody =>
      'Apabila anda membayar dengan kad di luar negara, makluman kelulusan daripada aplikasi kad (atau aplikasi pesanan) anda akan dibaca dan direkodkan dalam perjalanan pada tarikh tersebut. Hanya makluman kelulusan dalam mata wang asing diproses, pada peranti anda. Pemberitahuan lain tidak pernah disimpan atau dihantar ke mana-mana.';

  @override
  String get cardAlertsOn => 'Hidup';

  @override
  String get cardAlertsOff => 'Mati (perlu akses pemberitahuan)';

  @override
  String get cardAlertsAllow => 'Benarkan akses pemberitahuan';

  @override
  String get cardAlertsSettings => 'Buka tetapan akses pemberitahuan';

  @override
  String get cardAlertsConsentTitle => 'Tentang akses pemberitahuan';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Pada skrin seterusnya, benarkan akses pemberitahuan untuk \"$appName\". Aplikasi hanya akan memilih makluman kelulusan bayaran kad luar negara daripada pemberitahuan anda dan merekodkannya sebagai perbelanjaan. Kandungan pemberitahuan tidak pernah keluar dari peranti anda, dan anda boleh mematikannya pada bila-bila masa dalam tetapan yang sama.';
  }

  @override
  String get agreeAndContinue => 'Setuju dan teruskan';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bayaran kad',
      one: '1 bayaran kad',
    );
    return '$_temp0 sedang menunggu perjalanan yang meliputi tarikh bayarannya. Cipta perjalanan itu dan bayaran akan ditambah secara automatik.';
  }

  @override
  String get pasteCardAlert => 'Tampal teks makluman kad';

  @override
  String get pasteCardAlertHint =>
      'Tampal makluman kelulusan yang anda terima daripada aplikasi kad atau SMS.';

  @override
  String get pasteCardAlertFailed =>
      'Teks ini tidak dapat dibaca sebagai kelulusan bayaran luar negara. Sila masukkan secara manual.';

  @override
  String get cardReadNotice =>
      'Diisi daripada makluman kad anda. Semak dan betulkan sebelum menyimpan.';

  @override
  String get read => 'Baca';

  @override
  String get privacyPolicy => 'Dasar privasi';

  @override
  String colHomeRate(String currency) {
    return 'Kadar ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Amaun ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Jumlah ($currency)';
  }

  @override
  String get noConvertedYet => 'Belum ada perbelanjaan yang ditukar';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Kewarganegaraan';

  @override
  String get chooseNationality => 'Pilih kewarganegaraan anda';

  @override
  String get nationalityBody =>
      'Semua perbelanjaan akan ditukar kepada mata wang negara anda, dan bahasa aplikasi akan disesuaikan. Anda boleh mengubahnya kemudian dalam Tetapan.';

  @override
  String get searchCountry => 'Cari negara';

  @override
  String get homeCurrency => 'Mata wang asal';

  @override
  String get welcomeTitle => 'Selamat datang ke Travel Expense';

  @override
  String get welcomeBody =>
      'Sambungkan akaun Google anda untuk menyimpan perbelanjaan secara automatik ke helaian dalam Google Drive anda sendiri.';

  @override
  String get skipForNow => 'Bukan sekarang';

  @override
  String get next => 'Seterusnya';

  @override
  String get exportTripSheet => 'Simpan ke Google Sheets';

  @override
  String get exportTripSheetSaving => 'Menyimpan ke Google Sheets…';

  @override
  String exportTripSheetDone(String title) {
    return 'Disimpan ke helaian \'$title\'';
  }

  @override
  String get receiptTotalNotFound =>
      'Jumlah keseluruhan pada resit tidak dapat disahkan. Sila masukkan amaun dan mata wang sendiri. Foto telah dipadam selepas analisis.';

  @override
  String get receiptCurrencyNotFound =>
      'Mata wang pada resit tidak dapat disahkan. Semak amaun dan pilih mata wang sendiri. Foto telah dipadam selepas analisis.';

  @override
  String get currencyRequired => 'Pilih mata wang';

  @override
  String batchTitle(int count) {
    return '$count bayaran dibaca';
  }

  @override
  String get batchHint =>
      'Pilih yang hendak disimpan. Ketik amaun untuk mengubah.';

  @override
  String batchSave(int count) {
    return 'Simpan $count yang dipilih';
  }

  @override
  String batchSaved(int count) {
    return '$count perbelanjaan disimpan';
  }

  @override
  String get batchOutsideTrip => 'Di luar tarikh perjalanan';

  @override
  String get batchDuplicate => 'Sudah disimpan';

  @override
  String get batchNeedsInput => 'Semak amaun/mata wang · ketik amaun';

  @override
  String get scanIncomplete =>
      'Ada bayaran yang tidak dapat dibaca. Sila masukkan satu demi satu.';
}
