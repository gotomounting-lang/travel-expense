import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/expense_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../models/trip.dart';
import '../services/card_notification_parser.dart';
import '../services/card_notification_source.dart';
import '../services/exchange_rate_service.dart';
import '../services/google_account_service.dart';
import '../services/sheets_sync_service.dart';
import '../util/dates.dart';

enum SyncStatus { idle, syncing, ok, failed }

/// 화면들이 공유하는 앱 상태. 저장 → 환율 조회 → 시트 동기화 순서를 관리한다.
class AppState extends ChangeNotifier {
  AppState({
    required this.repository,
    required this.rates,
    required this.account,
    required this.sync,
    required this.strings,
    String Function()? homeCurrency,
    CardNotificationSource? cardNotifications,
    DateTime Function()? now,
  }) : cardNotifications =
           cardNotifications ?? CardNotificationSource(supported: false),
       homeCurrency = homeCurrency ?? (() => 'KRW'),
       _now = now ?? DateTime.now {
    account.addListener(_onAccountChanged);
  }

  final ExpenseRepository repository;
  final ExchangeRateService rates;
  final GoogleAccountService account;
  final SheetsSyncService sync;

  /// 시트에 쓸 언어 (앱 화면 언어와 같다).
  final AppLocalizations Function() strings;

  /// 사용자 국적의 통화. 모든 지출을 이 통화로 환산해 보여준다.
  final String Function() homeCurrency;

  /// 안드로이드 카드 결제 알림. iOS·테스트에서는 아무것도 하지 않는다.
  final CardNotificationSource cardNotifications;
  final DateTime Function() _now;
  final _uuid = const Uuid();

  List<Trip> _trips = [];
  List<Expense> _expenses = [];

  List<Trip> get trips => _trips;

  List<Expense> expensesFor(String tripId) =>
      _expenses.where((e) => e.tripId == tripId).toList();

  /// 지금 환산 통화로 환산이 끝난 지출 (합계·차트에 쓴다).
  List<Expense> convertedFor(String tripId) {
    final home = homeCurrency();
    return expensesFor(tripId)
        .where((e) => e.hasRate && e.homeCurrency == home)
        .toList();
  }

  Trip? tripById(String id) => _trips.where((t) => t.id == id).firstOrNull;

  SyncStatus _syncStatus = SyncStatus.idle;
  SyncStatus get syncStatus => _syncStatus;

  /// 마지막 동기화 실패 원인. 화면에서 언어에 맞게 보여준다.
  Object? _syncError;
  Object? get syncError => _syncError;
  String? _sheetUrl;
  String? get sheetUrl => _sheetUrl;

  Timer? _syncDebounce;
  bool _syncAgain = false;
  Future<void>? _refreshingRates;
  bool _wasSignedIn = false;

  Future<void> load() async {
    _trips = await repository.trips();
    _expenses = await repository.expenses();
    notifyListeners();
    unawaited(refreshMissingRates());
  }

  // ---- 여행 ----

  Future<Trip> saveTrip({
    String? id,
    required String title,
    required String country,
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final trip = Trip(
      id: id ?? _uuid.v4(),
      title: title.trim(),
      country: country.trim(),
      currency: currency.toUpperCase(),
      startDate: dateOnly(startDate),
      endDate: dateOnly(endDate),
    );
    await repository.saveTrip(trip);
    await load();
    _scheduleSync();
    // 이 여행 기간에 해당하는 기다리던 카드 알림이 있으면 넣는다.
    unawaited(importCardNotifications());
    return trip;
  }

  Future<void> deleteTrip(String id) async {
    await repository.deleteTrip(id);
    await load();
    _scheduleSync();
  }

  // ---- 지출 ----

  /// 지출을 저장한다. 환율 조회에 실패해도(오프라인 등) 먼저 저장하고,
  /// 나중에 [refreshMissingRates]에서 다시 채운다.
  Future<Expense> saveExpense({
    String? id,
    required String tripId,
    required DateTime spentAt,
    required ExpenseCategory category,
    required String currency,
    required double amount,
    String merchant = '',
    String paymentMethod = '',
    String memo = '',
    ExpenseSource source = ExpenseSource.manual,
  }) async {
    final previous = id == null
        ? null
        : _expenses.where((e) => e.id == id).firstOrNull;
    var expense = Expense(
      id: id ?? _uuid.v4(),
      tripId: tripId,
      spentAt: spentAt,
      category: category,
      currency: currency.toUpperCase(),
      amount: amount,
      merchant: merchant.trim(),
      paymentMethod: paymentMethod.trim(),
      memo: memo.trim(),
      source: previous?.source ?? source,
    );

    // 날짜·통화가 그대로면 기존 환율을 유지한다.
    final keepRate =
        previous != null &&
        previous.hasRate &&
        previous.homeCurrency == homeCurrency() &&
        previous.currency == expense.currency &&
        dateOnly(previous.spentAt) == dateOnly(expense.spentAt);
    if (keepRate) {
      expense = expense.copyWith(
        homeCurrency: previous.homeCurrency,
        homeRate: previous.homeRate,
        rateDate: previous.rateDate,
        rateSource: previous.rateSource,
      );
    } else {
      expense = await _withRate(expense);
    }

    await repository.saveExpense(expense);
    await load();
    _scheduleSync();
    return expense;
  }

  Future<void> deleteExpense(String id) async {
    await repository.deleteExpense(id);
    await load();
    _scheduleSync();
  }

  Future<Expense> _withRate(Expense e) async {
    try {
      final home = homeCurrency();
      final r = await rates.rate(e.currency, home, e.spentAt);
      return e.copyWith(
        homeCurrency: home,
        homeRate: r.rate,
        rateDate: r.rateDate,
        rateSource: r.source,
      );
    } catch (err) {
      debugPrint('exchange rate lookup failed: $err');
      return e.copyWith(homeCurrency: homeCurrency(), clearRate: true);
    }
  }

  /// 환율이 비어 있는 내역과, 아직 고시 전이라 직전 영업일 환율로 임시
  /// 계산된 최근 내역의 환율을 다시 조회한다.
  Future<void> refreshMissingRates() async {
    // 이미 도는 조회가 있으면 끝난 뒤 지금 상태로 한 번 더 조회한다.
    while (_refreshingRates != null) {
      await _refreshingRates;
    }
    final run = _refreshRates();
    _refreshingRates = run;
    try {
      await run;
    } finally {
      _refreshingRates = null;
    }
  }

  Future<void> _refreshRates() async {
    final today = dateOnly(_now());
    final targets = _expenses.where((e) {
      if (!e.hasRate || e.homeCurrency != homeCurrency()) return true;
      final day = dateOnly(e.spentAt);
      final isWeekday = day.weekday <= DateTime.friday;
      return isWeekday &&
          e.rateDate != null &&
          e.rateDate!.isBefore(day) &&
          today.difference(day).inDays <= 5;
    }).toList();
    if (targets.isEmpty) return;

    var changed = false;
    for (final e in targets) {
      final updated = await _withRate(e);
      if (updated.homeRate != e.homeRate ||
          updated.homeCurrency != e.homeCurrency ||
          updated.rateDate != e.rateDate) {
        if (!updated.hasRate) continue;
        await repository.saveExpense(updated);
        changed = true;
      }
    }
    if (changed) {
      _expenses = await repository.expenses();
      notifyListeners();
      _scheduleSync();
    }
  }

  // ---- 카드 결제 알림 ----

  int _waitingCardPayments = 0;

  /// 결제일에 맞는 여행이 없어 기다리는 카드 결제 수.
  int get waitingCardPayments => _waitingCardPayments;

  Future<void>? _importing;

  /// 기기에 모인 카드 결제 알림을 해당 날짜의 여행에 지출로 기록한다.
  /// 맞는 여행이 없는 알림은 지우지 않고 남겨 두었다가, 여행이 생기면 넣는다.
  Future<void> importCardNotifications() async {
    while (_importing != null) {
      await _importing;
    }
    final run = _importCardNotifications();
    _importing = run;
    try {
      await run;
    } catch (e) {
      debugPrint('card notification import failed: $e');
    } finally {
      _importing = null;
    }
  }

  Future<void> _importCardNotifications() async {
    final pending = await cardNotifications.pending();
    final parser = CardNotificationParser(homeCurrency: homeCurrency());
    final done = <String>[];
    var waiting = 0;
    for (final n in pending) {
      final payment = parser.parse(n);
      if (payment == null) {
        done.add(n.id); // 카드 결제가 아닌 알림
        continue;
      }
      final trip = tripFor(payment.spentAt);
      if (trip == null) {
        waiting++;
        continue;
      }
      if (!_isDuplicate(trip.id, payment)) {
        await saveExpense(
          tripId: trip.id,
          spentAt: payment.spentAt,
          category: payment.category ?? ExpenseCategory.other,
          currency: payment.currency,
          amount: payment.amount,
          merchant: payment.merchant,
          paymentMethod: payment.card,
          source: ExpenseSource.cardNotification,
        );
      }
      done.add(n.id);
    }
    await cardNotifications.remove(done);
    if (waiting != _waitingCardPayments) {
      _waitingCardPayments = waiting;
      notifyListeners();
    }
  }

  /// 결제일이 기간 안에 드는 여행 (여럿이면 가장 늦게 시작한 여행).
  Trip? tripFor(DateTime at) {
    final day = dateOnly(at);
    final matches =
        _trips
            .where((t) => !day.isBefore(t.startDate) && !day.isAfter(t.endDate))
            .toList()
          ..sort((a, b) => b.startDate.compareTo(a.startDate));
    return matches.firstOrNull;
  }

  /// 카드 앱 푸시와 알림톡이 둘 다 오거나 이미 직접 입력한 경우를 걸러낸다.
  bool _isDuplicate(String tripId, CardPayment p) => _expenses.any(
    (e) =>
        e.tripId == tripId &&
        e.currency == p.currency &&
        (e.amount - p.amount).abs() < 0.005 &&
        e.spentAt.difference(p.spentAt).inMinutes.abs() <= 10,
  );

  // ---- 구글 시트 ----

  void _onAccountChanged() {
    final signedIn = account.isSignedIn;
    if (signedIn && !_wasSignedIn) {
      unawaited(_loadSheetUrl());
      _scheduleSync(delay: Duration.zero);
    }
    if (!signedIn) {
      _sheetUrl = null;
      _syncStatus = SyncStatus.idle;
      _syncError = null;
    }
    _wasSignedIn = signedIn;
    notifyListeners();
  }

  Future<void> _loadSheetUrl() async {
    _sheetUrl = await sync.spreadsheetUrl();
    notifyListeners();
  }

  void _scheduleSync({Duration delay = const Duration(seconds: 2)}) {
    if (!account.isSignedIn) return;
    _syncDebounce?.cancel();
    _syncDebounce = Timer(delay, () => syncNow());
  }

  /// 시트에 지금 반영한다. [interactive]가 true면 필요할 때 권한 창을 띄운다.
  Future<void> syncNow({bool interactive = false}) async {
    if (!account.isSignedIn) return;
    if (_syncStatus == SyncStatus.syncing) {
      // 동기화 중에 바뀐 내용은 끝난 뒤 한 번 더 반영한다.
      _syncAgain = true;
      return;
    }
    _syncStatus = SyncStatus.syncing;
    _syncError = null;
    notifyListeners();
    try {
      _sheetUrl = await sync.sync(
        strings(),
        homeCurrency(),
        _trips,
        _expenses,
        interactive: interactive,
      );
      _syncStatus = SyncStatus.ok;
    } catch (e) {
      _syncStatus = SyncStatus.failed;
      _syncError = e;
    }
    notifyListeners();
    if (_syncAgain) {
      _syncAgain = false;
      await syncNow();
    }
  }

  @override
  void dispose() {
    _syncDebounce?.cancel();
    account.removeListener(_onAccountChanged);
    super.dispose();
  }
}
