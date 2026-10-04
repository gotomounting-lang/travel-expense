import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/expense_repository.dart';
import '../l10n/app_localizations.dart';
import '../models/category.dart';
import '../models/expense.dart';
import '../models/trip.dart';
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
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now {
    account.addListener(_onAccountChanged);
  }

  final ExpenseRepository repository;
  final ExchangeRateService rates;
  final GoogleAccountService account;
  final SheetsSyncService sync;

  /// 시트에 쓸 언어 (앱 화면 언어와 같다).
  final AppLocalizations Function() strings;
  final DateTime Function() _now;
  final _uuid = const Uuid();

  List<Trip> _trips = [];
  List<Expense> _expenses = [];

  List<Trip> get trips => _trips;

  List<Expense> expensesFor(String tripId) =>
      _expenses.where((e) => e.tripId == tripId).toList();

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
        previous.currency == expense.currency &&
        dateOnly(previous.spentAt) == dateOnly(expense.spentAt);
    if (keepRate) {
      expense = expense.copyWith(
        krwRate: previous.krwRate,
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
      final r = await rates.krwRate(e.currency, e.spentAt);
      return e.copyWith(
        krwRate: r.rate,
        rateDate: r.rateDate,
        rateSource: r.source,
      );
    } catch (err) {
      debugPrint('exchange rate lookup failed: $err');
      return e.copyWith(clearRate: true);
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
      if (!e.hasRate) return true;
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
      if (updated.krwRate != e.krwRate || updated.rateDate != e.rateDate) {
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
