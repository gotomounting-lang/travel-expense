import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';
import '../models/trip.dart';
import '../util/dates.dart';

/// 기기 안 SQLite 저장소. 구글 시트는 이 데이터의 사본이고, 해외에서
/// 인터넷이 끊겨도 먼저 여기 저장한 뒤 연결되면 시트로 동기화한다.
class ExpenseRepository {
  ExpenseRepository(this._db);

  final Database _db;

  static const _version = 2;

  static Future<ExpenseRepository> open({
    DatabaseFactory? factory,
    String? path,
  }) async {
    final f = factory ?? databaseFactory;
    final dbPath =
        path ?? p.join(await f.getDatabasesPath(), 'travel_expense.db');
    final db = await f.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _version,
        onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
        onCreate: (db, _) => _createSchema(db),
        onUpgrade: (db, from, _) async {
          if (from < 2) {
            await db.execute(
              "ALTER TABLE expenses ADD COLUMN home_currency TEXT NOT NULL DEFAULT 'KRW'",
            );
          }
        },
      ),
    );
    return ExpenseRepository(db);
  }

  static Future<void> _createSchema(Database db) async {
    await db.execute('''
      CREATE TABLE trips (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        country TEXT NOT NULL DEFAULT '',
        currency TEXT NOT NULL,
        start_date TEXT NOT NULL,
        end_date TEXT NOT NULL
      )''');
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        trip_id TEXT NOT NULL REFERENCES trips(id) ON DELETE CASCADE,
        spent_at TEXT NOT NULL,
        category TEXT NOT NULL,
        currency TEXT NOT NULL,
        amount REAL NOT NULL,
        merchant TEXT NOT NULL DEFAULT '',
        payment_method TEXT NOT NULL DEFAULT '',
        memo TEXT NOT NULL DEFAULT '',
        source TEXT NOT NULL DEFAULT 'manual',
        home_currency TEXT NOT NULL DEFAULT 'KRW',
        krw_rate REAL,
        rate_date TEXT,
        rate_source TEXT
      )''');
    await db.execute(
      'CREATE INDEX idx_expenses_trip ON expenses(trip_id, spent_at)',
    );
    await db.execute('''
      CREATE TABLE fx_rates (
        currency TEXT NOT NULL,
        requested_date TEXT NOT NULL,
        rate REAL NOT NULL,
        rate_date TEXT NOT NULL,
        source TEXT NOT NULL,
        PRIMARY KEY (currency, requested_date)
      )''');
  }

  Future<void> close() => _db.close();

  // ---- 여행 ----

  Future<List<Trip>> trips() async {
    final rows = await _db.query('trips', orderBy: 'start_date DESC');
    return rows.map(Trip.fromMap).toList();
  }

  Future<void> saveTrip(Trip trip) => _db.insert(
    'trips',
    trip.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  Future<void> deleteTrip(String id) =>
      _db.delete('trips', where: 'id = ?', whereArgs: [id]);

  // ---- 지출 ----

  Future<List<Expense>> expenses({String? tripId}) async {
    final rows = await _db.query(
      'expenses',
      where: tripId == null ? null : 'trip_id = ?',
      whereArgs: tripId == null ? null : [tripId],
      orderBy: 'spent_at DESC',
    );
    return rows.map(Expense.fromMap).toList();
  }

  Future<List<Expense>> expensesMissingRate() async {
    final rows = await _db.query('expenses', where: 'krw_rate IS NULL');
    return rows.map(Expense.fromMap).toList();
  }

  Future<void> saveExpense(Expense e) => _db.insert(
    'expenses',
    e.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  Future<void> deleteExpense(String id) =>
      _db.delete('expenses', where: 'id = ?', whereArgs: [id]);

  // ---- 환율 캐시 ----

  Future<CachedRate?> cachedRate(String currency, DateTime date) async {
    final rows = await _db.query(
      'fx_rates',
      where: 'currency = ? AND requested_date = ?',
      whereArgs: [currency, formatYmd(date)],
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return CachedRate(
      rate: (r['rate'] as num).toDouble(),
      rateDate: DateTime.parse(r['rate_date'] as String),
      source: r['source'] as String,
    );
  }

  Future<void> cacheRate(
    String currency,
    DateTime requestedDate,
    CachedRate rate,
  ) => _db.insert('fx_rates', {
    'currency': currency,
    'requested_date': formatYmd(requestedDate),
    'rate': rate.rate,
    'rate_date': formatYmd(rate.rateDate),
    'source': rate.source,
  }, conflictAlgorithm: ConflictAlgorithm.replace);
}

class CachedRate {
  const CachedRate({
    required this.rate,
    required this.rateDate,
    required this.source,
  });

  final double rate;
  final DateTime rateDate;
  final String source;
}
