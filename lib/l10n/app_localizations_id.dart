// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Travel Expense';

  @override
  String get settings => 'Pengaturan';

  @override
  String get newTrip => 'Perjalanan baru';

  @override
  String get editTrip => 'Edit perjalanan';

  @override
  String get deleteTrip => 'Hapus perjalanan';

  @override
  String get tripTitle => 'Nama perjalanan';

  @override
  String get tripTitleHint => 'mis. Liburan keluarga ke Tokyo 2026';

  @override
  String get tripTitleRequired => 'Masukkan nama perjalanan';

  @override
  String get countryOptional => 'Negara/kota (opsional)';

  @override
  String get countryHint => 'mis. Tokyo, Jepang';

  @override
  String get localCurrency => 'Mata uang lokal';

  @override
  String get currency => 'Mata uang';

  @override
  String get tripPeriod => 'Tanggal perjalanan';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get delete => 'Hapus';

  @override
  String get deleteTripConfirmTitle => 'Hapus perjalanan ini?';

  @override
  String get deleteTripConfirmBody =>
      'Semua pengeluaran dalam perjalanan ini akan dihapus dan dikeluarkan dari sheet Anda saat sinkronisasi berikutnya.';

  @override
  String get totalSpent => 'Total pengeluaran';

  @override
  String pendingRates(int count) {
    return '$count menunggu kurs (tarik ke bawah untuk memuat ulang saat online)';
  }

  @override
  String get firstExpenseHint =>
      'Ketuk + untuk mencatat pengeluaran pertama Anda';

  @override
  String get addExpense => 'Tambah pengeluaran';

  @override
  String get editExpense => 'Edit pengeluaran';

  @override
  String get ratePending => 'Kurs tertunda';

  @override
  String get amount => 'Jumlah';

  @override
  String get amountRequired => 'Masukkan jumlah';

  @override
  String get category => 'Kategori';

  @override
  String get merchantOptional => 'Merchant (opsional)';

  @override
  String get merchantHint => 'mis. Ichiran Ramen';

  @override
  String get paymentOptional => 'Metode pembayaran (opsional)';

  @override
  String get paymentHint => 'mis. Kartu Visa, tunai';

  @override
  String get memoOptional => 'Catatan (opsional)';

  @override
  String get checkingRate => 'Memeriksa kurs…';

  @override
  String get rateUnavailable =>
      'Kurs tidak bisa diambil saat ini. Simpan dulu, nanti akan dikonversi saat Anda online.';

  @override
  String rateInfo(String currency, String rate, String home, String date) {
    return '1 $currency = $rate $home (per $date)';
  }

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pengeluaran',
      one: '1 pengeluaran',
    );
    return '$_temp0';
  }

  @override
  String krw(String amount) {
    return '₩$amount';
  }

  @override
  String get emptyTitle => 'Buat perjalanan pertama Anda';

  @override
  String get emptyBody =>
      'Pengeluaran Anda di luar negeri dikonversi ke mata uang negara Anda dengan kurs pada tanggal pembayaran\ndan disimpan di Google Sheet milik Anda sendiri.';

  @override
  String get googleSheetsSection => 'Google Sheets';

  @override
  String googleSheetsBody(String fileName) {
    return 'Masuk dengan akun Google Anda, dan sheet \"$fileName\" akan dibuat di Google Drive Anda sendiri serta diperbarui setiap kali Anda mencatat pengeluaran. Aplikasi hanya dapat mengakses sheet yang dibuatnya, dan data Anda tidak pernah dikirim ke server kami.';
  }

  @override
  String get connectGoogle => 'Hubungkan akun Google';

  @override
  String get syncNow => 'Simpan sekarang';

  @override
  String get openSheet => 'Buka sheet';

  @override
  String get disconnect => 'Putuskan';

  @override
  String get rateInfoTitle => 'Tentang kurs';

  @override
  String get rateInfoBody =>
      'Jumlah dalam mata uang negara Anda memakai kurs acuan pada tanggal pembayaran (Bank Sentral Eropa, atau data kurs publik untuk mata uang lain). Akhir pekan dan hari libur memakai kurs hari kerja sebelumnya. Tagihan kartu Anda bisa sedikit berbeda karena kurs dan biaya dari penerbit kartu.';

  @override
  String googleSignInError(String details) {
    return 'Gagal masuk ke Google: $details';
  }

  @override
  String get syncSaved => 'Tersimpan ke sheet';

  @override
  String syncFailed(String details) {
    return 'Gagal menyimpan ke sheet: $details';
  }

  @override
  String get syncErrorNotSignedIn => 'Anda belum masuk ke Google.';

  @override
  String get syncErrorNoPermission =>
      'Izin Google Drive diperlukan. Silakan hubungkan ulang.';

  @override
  String get syncErrorExpired =>
      'Sesi Google Anda telah berakhir. Silakan hubungkan ulang.';

  @override
  String get language => 'Bahasa';

  @override
  String get languageSystem => 'Otomatis (sesuai kewarganegaraan)';

  @override
  String get catFood => 'Makanan';

  @override
  String get catSnack => 'Camilan/Kafe';

  @override
  String get catSouvenir => 'Oleh-oleh';

  @override
  String get catShopping => 'Belanja';

  @override
  String get catTransport => 'Transportasi';

  @override
  String get catLodging => 'Penginapan';

  @override
  String get catSightseeing => 'Wisata';

  @override
  String get catOther => 'Lainnya';

  @override
  String get sourceManual => 'Manual';

  @override
  String get sourceReceipt => 'Struk';

  @override
  String get sourceCard => 'Notifikasi kartu';

  @override
  String get sheetFileTitle => 'Travel Expense';

  @override
  String get tabExpenses => 'Pengeluaran';

  @override
  String get tabTrips => 'Perjalanan';

  @override
  String get tabSummary => 'Ringkasan';

  @override
  String get colTrip => 'Perjalanan';

  @override
  String get colDate => 'Tanggal';

  @override
  String get colTime => 'Waktu';

  @override
  String get colCategory => 'Kategori';

  @override
  String get colMerchant => 'Merchant';

  @override
  String get colCurrency => 'Mata uang';

  @override
  String get colLocalAmount => 'Jumlah lokal';

  @override
  String get colRateDate => 'Tanggal kurs';

  @override
  String get colPayment => 'Pembayaran';

  @override
  String get colSource => 'Sumber';

  @override
  String get colMemo => 'Catatan';

  @override
  String get colRateSource => 'Sumber kurs';

  @override
  String get colCountry => 'Negara';

  @override
  String get colStartDate => 'Mulai';

  @override
  String get colEndDate => 'Selesai';

  @override
  String get colCount => 'Jumlah';

  @override
  String get colShare => 'Porsi (%)';

  @override
  String get scanReceipt => 'Pindai struk';

  @override
  String get pickReceipt => 'Struk dari galeri';

  @override
  String get enterManually => 'Isi manual';

  @override
  String get readingReceipt => 'Membaca struk…';

  @override
  String get receiptReadNotice =>
      'Diisi dari struk Anda. Periksa dan perbaiki sebelum menyimpan. Foto sudah dihapus setelah dianalisis.';

  @override
  String get receiptNothingFound =>
      'Jumlah tidak ditemukan di struk. Silakan isi manual. Foto sudah dihapus.';

  @override
  String receiptScanFailed(String details) {
    return 'Gagal membaca struk: $details';
  }

  @override
  String get photoDeletedNote =>
      'Foto dianalisis di perangkat Anda dan langsung dihapus. Foto tidak pernah disimpan atau diunggah.';

  @override
  String get cardAlertsSection => 'Catat otomatis notifikasi pembayaran kartu';

  @override
  String get cardAlertsBody =>
      'Saat Anda membayar dengan kartu di luar negeri, notifikasi persetujuan dari aplikasi kartu (atau messenger) akan dibaca dan dicatat ke perjalanan pada tanggal tersebut. Hanya notifikasi persetujuan dalam mata uang asing yang diproses, di perangkat Anda. Notifikasi lain tidak pernah disimpan atau dikirim ke mana pun.';

  @override
  String get cardAlertsOn => 'Aktif';

  @override
  String get cardAlertsOff => 'Nonaktif (perlu akses notifikasi)';

  @override
  String get cardAlertsAllow => 'Izinkan akses notifikasi';

  @override
  String get cardAlertsSettings => 'Buka pengaturan akses notifikasi';

  @override
  String get cardAlertsConsentTitle => 'Tentang akses notifikasi';

  @override
  String cardAlertsConsentBody(String appName) {
    return 'Di layar berikutnya, izinkan akses notifikasi untuk \"$appName\". Aplikasi hanya akan memilih notifikasi persetujuan pembayaran kartu di luar negeri dan mencatatnya sebagai pengeluaran. Isi notifikasi tidak pernah keluar dari perangkat Anda, dan Anda bisa menonaktifkannya kapan saja di pengaturan yang sama.';
  }

  @override
  String get agreeAndContinue => 'Setuju dan lanjutkan';

  @override
  String cardAlertsWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pembayaran kartu',
      one: '1 pembayaran kartu',
    );
    return '$_temp0 menunggu perjalanan yang mencakup tanggal pembayarannya. Buat perjalanan tersebut dan pembayaran akan ditambahkan otomatis.';
  }

  @override
  String get pasteCardAlert => 'Tempel teks notifikasi kartu';

  @override
  String get pasteCardAlertHint =>
      'Tempel notifikasi persetujuan dari aplikasi kartu atau SMS Anda.';

  @override
  String get pasteCardAlertFailed =>
      'Teks ini tidak terbaca sebagai persetujuan pembayaran luar negeri. Silakan isi manual.';

  @override
  String get cardReadNotice =>
      'Diisi dari notifikasi kartu Anda. Periksa dan perbaiki sebelum menyimpan.';

  @override
  String get read => 'Baca';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String colHomeRate(String currency) {
    return 'Kurs ($currency)';
  }

  @override
  String colHomeAmount(String currency) {
    return 'Jumlah ($currency)';
  }

  @override
  String colHomeTotal(String currency) {
    return 'Total ($currency)';
  }

  @override
  String get noConvertedYet => 'Belum ada pengeluaran yang dikonversi';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get nationality => 'Kewarganegaraan';

  @override
  String get chooseNationality => 'Pilih kewarganegaraan Anda';

  @override
  String get nationalityBody =>
      'Semua pengeluaran akan dikonversi ke mata uang negara Anda, dan bahasa aplikasi akan disesuaikan. Anda bisa mengubahnya nanti di Pengaturan.';

  @override
  String get searchCountry => 'Cari negara';

  @override
  String get homeCurrency => 'Mata uang asal';

  @override
  String get welcomeTitle => 'Selamat datang di Travel Expense';

  @override
  String get welcomeBody =>
      'Hubungkan akun Google Anda untuk menyimpan pengeluaran secara otomatis ke sheet di Google Drive Anda sendiri.';

  @override
  String get skipForNow => 'Nanti saja';

  @override
  String get next => 'Berikutnya';

  @override
  String get exportTripSheet => 'Simpan ke Google Spreadsheet';

  @override
  String get exportTripSheetSaving => 'Menyimpan ke Google Spreadsheet…';

  @override
  String exportTripSheetDone(String title) {
    return 'Tersimpan di sheet \'$title\'';
  }

  @override
  String get receiptTotalNotFound =>
      'Total pada struk tidak dapat dipastikan. Silakan masukkan jumlah dan mata uang sendiri. Foto sudah dihapus setelah dianalisis.';

  @override
  String get receiptCurrencyNotFound =>
      'Mata uang pada struk tidak dapat dipastikan. Periksa jumlahnya dan pilih mata uang sendiri. Foto sudah dihapus setelah dianalisis.';

  @override
  String get currencyRequired => 'Pilih mata uang';
}
