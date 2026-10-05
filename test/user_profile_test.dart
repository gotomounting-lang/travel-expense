import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_expense/models/country.dart';
import 'package:travel_expense/state/user_profile.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('기기 지역 나라: 목록에 있는 첫 나라', () {
    expect(Country.fromRegions(['XX', 'us', 'KR'])?.code, 'US');
    expect(Country.fromRegions([null, 'JP'])?.code, 'JP');
    expect(Country.fromRegions([null, 'ZZ']), isNull);
  });

  test('국적을 고르기 전 환산 통화는 기기 지역 나라의 통화', () async {
    final us = UserProfile(deviceCountry: Country.byCode('US'));
    await us.load();
    expect(us.homeCurrency, 'USD');
    expect(
      UserProfile(deviceCountry: Country.byCode('JP')).homeCurrency,
      'JPY',
    );
    expect(UserProfile().homeCurrency, 'USD');
  });

  test('고른 국적이 기기 지역보다 우선', () async {
    final p = UserProfile(deviceCountry: Country.byCode('US'));
    await p.setCountry(Country.byCode('KR')!);
    expect(p.homeCurrency, 'KRW');
  });
}
