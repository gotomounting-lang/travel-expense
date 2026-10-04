import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/expense_repository.dart';
import '../util/dates.dart';

class ExchangeRateException implements Exception {
  ExchangeRateException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// 결제한 날짜 기준 원화 환율을 가져온다.
///
/// 1순위 Frankfurter(유럽중앙은행 고시, 약 30개 통화)로 조회하고,
/// 지원하지 않는 통화(VND, TWD 등)나 실패 시 fawazahmed0 currency-api로 넘어간다.
/// 둘 다 무료이고 API 키가 필요 없어서 앱이 서버 없이 바로 호출한다.
/// 주말·공휴일에는 각 출처가 직전 영업일 환율을 돌려주며, 실제 적용일을 함께 저장한다.
class ExchangeRateService {
  ExchangeRateService({
    required this.client,
    this.cache,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final http.Client client;

  /// 지난 날짜 환율 캐시. 없으면 매번 조회한다.
  final ExpenseRepository? cache;
  final DateTime Function() _now;

  static const _timeout = Duration(seconds: 10);

  Future<CachedRate> krwRate(String currency, DateTime spentAt) async {
    final code = currency.toUpperCase();
    final today = dateOnly(_now());
    var date = dateOnly(spentAt);
    if (date.isAfter(today)) date = today;

    if (code == 'KRW') {
      return CachedRate(rate: 1, rateDate: date, source: 'KRW');
    }

    final cached = await cache?.cachedRate(code, date);
    if (cached != null) return cached;

    final errors = <String>[];
    CachedRate? rate;
    for (final fetch in [_frankfurter, _currencyApi]) {
      try {
        rate = await fetch(code, date, today);
        if (rate != null) break;
      } catch (e) {
        errors.add(e.toString());
      }
    }
    if (rate == null) {
      throw ExchangeRateException(
        '$code 환율을 가져오지 못했습니다 (${errors.join(' / ')})',
      );
    }

    // 지난 날짜의 환율은 바뀌지 않으므로 캐시한다. 오늘 환율은 아직
    // 고시 전일 수 있어서 저장하지 않는다.
    if (date.isBefore(today)) {
      await cache?.cacheRate(code, date, rate);
    }
    return rate;
  }

  Future<CachedRate?> _frankfurter(
    String code,
    DateTime date,
    DateTime today,
  ) async {
    final uri = Uri.https('api.frankfurter.dev', '/v1/${formatYmd(date)}', {
      'base': code,
      'symbols': 'KRW',
    });
    final res = await client.get(uri).timeout(_timeout);
    if (res.statusCode == 404 || res.statusCode == 422) return null;
    if (res.statusCode != 200) {
      throw ExchangeRateException('frankfurter ${res.statusCode}');
    }
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    final krw = (body['rates'] as Map<String, dynamic>?)?['KRW'] as num?;
    if (krw == null) return null;
    return CachedRate(
      rate: krw.toDouble(),
      rateDate: DateTime.parse(body['date'] as String),
      source: 'ECB(frankfurter)',
    );
  }

  Future<CachedRate?> _currencyApi(
    String code,
    DateTime date,
    DateTime today,
  ) async {
    final lower = code.toLowerCase();
    // 오늘·어제 자료는 아직 날짜 태그가 없을 수 있어 latest로 대신한다.
    final tags = [
      formatYmd(date),
      if (today.difference(date).inDays <= 1) 'latest',
    ];
    for (final tag in tags) {
      for (final uri in [
        Uri.https(
          'cdn.jsdelivr.net',
          '/npm/@fawazahmed0/currency-api@$tag/v1/currencies/$lower.json',
        ),
        Uri.https('$tag.currency-api.pages.dev', '/v1/currencies/$lower.json'),
      ]) {
        http.Response res;
        try {
          res = await client.get(uri).timeout(_timeout);
        } catch (_) {
          continue;
        }
        if (res.statusCode != 200) continue;
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        final krw = (body[lower] as Map<String, dynamic>?)?['krw'] as num?;
        if (krw == null) return null;
        return CachedRate(
          rate: krw.toDouble(),
          rateDate: DateTime.parse(body['date'] as String),
          source: 'currency-api',
        );
      }
    }
    return null;
  }
}
