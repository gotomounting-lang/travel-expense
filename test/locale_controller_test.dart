import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_expense/models/country.dart';
import 'package:travel_expense/state/locale_controller.dart';
import 'package:travel_expense/state/user_profile.dart';

void main() {
  test('기기 언어 중 처음 지원하는 언어, 없으면 한국어', () {
    expect(
      LocaleController.resolve(const [Locale('ja', 'JP')]),
      const Locale('ja'),
    );
    expect(
      LocaleController.resolve(const [Locale('fr'), Locale('zh', 'TW')]),
      const Locale('zh'),
    );
    expect(LocaleController.resolve(const [Locale('fr')]), const Locale('ko'));
    expect(LocaleController.resolve(null), const Locale('ko'));
  });

  test('직접 고른 언어는 저장되고 기기 언어보다 우선한다', () async {
    SharedPreferences.setMockInitialValues({});
    final c = LocaleController(deviceLocales: () => const [Locale('en')]);
    await c.load();
    expect(c.selected, isNull);
    expect(c.current, const Locale('en'));
    expect(c.strings.appTitle, 'Travel Expense');

    await c.choose('ja');
    expect(c.current, const Locale('ja'));

    final again = LocaleController(deviceLocales: () => const [Locale('en')]);
    await again.load();
    expect(again.choice, 'ja');

    await again.choose(null);
    expect(again.current, const Locale('en'));
  });

  test('국적 언어: 한국·중국어권·일본은 자기 언어, 나머지는 영어', () {
    String lang(String code) => Country.byCode(code)!.language;
    expect(lang('KR'), 'ko');
    expect(lang('CN'), 'zh');
    expect(lang('TW'), 'zh');
    expect(lang('HK'), 'zh');
    expect(lang('JP'), 'ja');
    for (final c in Country.all.where(
      (c) => !const {'KR', 'CN', 'TW', 'HK', 'MO', 'JP'}.contains(c.code),
    )) {
      expect(c.language, 'en', reason: c.code);
    }
  });

  test('국적이 기기 언어보다 우선하고, 직접 고른 언어가 국적보다 우선한다', () async {
    SharedPreferences.setMockInitialValues({});
    final profile = UserProfile();
    final c = LocaleController(
      deviceLocales: () => const [Locale('ja')],
      profile: profile,
    );
    await c.load();
    expect(c.current, const Locale('ja'), reason: '국적 고르기 전엔 기기 언어');

    await profile.setCountry(Country.byCode('DE')!);
    expect(c.current, const Locale('en'));
    expect(profile.homeCurrency, 'EUR');

    await c.choose('ko');
    expect(c.current, const Locale('ko'));

    final reloaded = UserProfile();
    await reloaded.load();
    expect(reloaded.country?.code, 'DE');
  });
}
