import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:travel_expense/data/expense_repository.dart';
import 'package:travel_expense/services/exchange_rate_service.dart';

void main() {
  sqfliteFfiInit();
  final now = DateTime(2026, 10, 4, 10);
  late ExpenseRepository repo;
  late List<Uri> calls;

  setUp(() async {
    repo = await ExpenseRepository.open(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    calls = [];
  });
  tearDown(() => repo.close());

  ExchangeRateService service(
    Future<http.Response> Function(http.Request) handler,
  ) => ExchangeRateService(
    client: MockClient((req) {
      calls.add(req.url);
      return handler(req);
    }),
    cache: repo,
    now: () => now,
  );

  test('같은 통화는 조회 없이 1', () async {
    final s = service((_) async => http.Response('', 500));
    final r = await s.rate('krw', 'KRW', DateTime(2026, 10, 1));
    expect(r.rate, 1);
    expect(calls, isEmpty);
  });

  test('Frankfurter에서 결제일 환율을 가져오고 지난 날짜는 캐시한다', () async {
    final s = service((req) async {
      expect(req.url.host, 'api.frankfurter.dev');
      expect(req.url.path, '/v1/2026-10-03');
      expect(req.url.queryParameters, {'base': 'JPY', 'symbols': 'KRW'});
      // 토요일 요청 → 금요일 환율이 돌아온다.
      return http.Response(
        jsonEncode({
          'amount': 1.0,
          'base': 'JPY',
          'date': '2026-10-02',
          'rates': {'KRW': 9.41},
        }),
        200,
      );
    });
    final r = await s.rate('JPY', 'KRW', DateTime(2026, 10, 3, 21, 30));
    expect(r.rate, 9.41);
    expect(r.rateDate, DateTime(2026, 10, 2));
    expect(r.source, contains('ECB'));

    final again = await s.rate('JPY', 'KRW', DateTime(2026, 10, 3, 8));
    expect(again.rate, 9.41);
    expect(calls, hasLength(1), reason: '두 번째는 캐시에서');
  });

  test('Frankfurter 미지원 통화는 currency-api로 넘어간다', () async {
    final s = service((req) async {
      if (req.url.host == 'api.frankfurter.dev') {
        return http.Response('{"message":"not found"}', 404);
      }
      expect(
        req.url.path,
        '/npm/@fawazahmed0/currency-api@2026-09-20/v1/currencies/vnd.json',
      );
      return http.Response(
        jsonEncode({
          'date': '2026-09-20',
          'vnd': {'krw': 0.0531, 'usd': 0.000038},
        }),
        200,
      );
    });
    final r = await s.rate('VND', 'KRW', DateTime(2026, 9, 20));
    expect(r.rate, 0.0531);
    expect(r.source, 'currency-api');
  });

  test('오늘 환율은 캐시하지 않고, 미래 날짜는 오늘로 본다', () async {
    final s = service(
      (req) async => http.Response(
        jsonEncode({
          'base': 'USD',
          'date': '2026-10-02',
          'rates': {'KRW': 1390.5},
        }),
        200,
      ),
    );
    await s.rate('USD', 'KRW', DateTime(2026, 12, 25));
    expect(calls.single.path, '/v1/2026-10-04');
    await s.rate('USD', 'KRW', now);
    expect(calls, hasLength(2));
    expect(await repo.cachedRate('USD>KRW', now), isNull);
  });

  test('외국인 사용자: 원화를 내 나라 통화(USD)로 바꾼다', () async {
    final s = service((req) async {
      expect(req.url.queryParameters, {'base': 'KRW', 'symbols': 'USD'});
      return http.Response(
        jsonEncode({
          'base': 'KRW',
          'date': '2026-10-02',
          'rates': {'USD': 0.00072},
        }),
        200,
      );
    });
    final r = await s.rate('KRW', 'USD', DateTime(2026, 10, 2, 15));
    expect(r.rate, 0.00072);
    expect(await repo.cachedRate('KRW>USD', DateTime(2026, 10, 2)), isNotNull);
    expect(
      await repo.cachedRate('KRW>JPY', DateTime(2026, 10, 2)),
      isNull,
      reason: '통화 쌍별로 따로 캐시',
    );
  });

  test('모든 출처가 실패하면 예외', () async {
    final s = service((_) async => throw http.ClientException('offline'));
    expect(
      () => s.rate('USD', 'KRW', DateTime(2026, 9, 1)),
      throwsA(isA<ExchangeRateException>()),
    );
  });
}
