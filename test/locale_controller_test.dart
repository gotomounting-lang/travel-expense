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
      LocaleController.resolve(const [Locale('th'), Locale('zh', 'TW')]),
      const Locale('zh'),
    );
    expect(LocaleController.resolve(const [Locale('vi')]), const Locale('vi'));
    // 안드로이드 옛 코드: 인도네시아어 in, 타갈로그어 tl
    expect(LocaleController.resolve(const [Locale('in')]), const Locale('id'));
    expect(LocaleController.resolve(const [Locale('tl')]), const Locale('fil'));
    expect(LocaleController.resolve(const [Locale('th')]), const Locale('ko'));
    expect(LocaleController.resolve(null), const Locale('ko'));
  });

  test('직접 고른 언어는 저장되고 기기 언어보다 우선한다', () async {
    SharedPreferences.setMockInitialValues({});
    final c = LocaleController(deviceLocales: () => const [Locale('en')]);
    await c.load();
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

  test('국적 언어: 지원하는 언어의 나라는 그 언어, 나머지는 영어', () {
    String lang(String code) => Country.byCode(code)!.language;
    expect(lang('KR'), 'ko');
    expect(lang('CN'), 'zh');
    expect(lang('TW'), 'zh');
    expect(lang('HK'), 'zh');
    expect(lang('JP'), 'ja');
    const others = {
      'VN': 'vi',
      'RU': 'ru',
      'DE': 'de',
      'MN': 'mn',
      'FR': 'fr',
      'MM': 'my',
      'PH': 'fil',
      'ID': 'id',
      'MY': 'ms',
      'IN': 'hi',
    };
    for (final e in others.entries) {
      expect(lang(e.key), e.value, reason: e.key);
      expect(LocaleController.supported, contains(e.value));
    }
    for (final c in Country.all.where(
      (c) =>
          !const {'KR', 'CN', 'TW', 'HK', 'MO', 'JP'}.contains(c.code) &&
          !others.containsKey(c.code),
    )) {
      expect(c.language, 'en', reason: c.code);
    }
  });

  test('직접 고른 언어 > 국적 언어 > 기기(플레이스토어) 언어 > 영어', () async {
    SharedPreferences.setMockInitialValues({});
    final profile = UserProfile();
    final c = LocaleController(
      deviceLocales: () => const [Locale('vi', 'VN')],
      profile: profile,
    );
    await c.load();
    expect(c.current, const Locale('vi'), reason: '국적 고르기 전엔 기기 언어');
    // 앱이 말을 지원하지 않는 나라(태국)면 기기 언어를 그대로 쓴다.
    await profile.setCountry(Country.byCode('TH')!);
    expect(c.current, const Locale('vi'));
    await profile.setCountry(Country.byCode('GB')!);
    expect(c.current, const Locale('en'));

    final thai = LocaleController(
      deviceLocales: () => const [Locale('th')],
      profile: profile,
    );
    await thai.load();
    await profile.setCountry(Country.byCode('TH')!);
    expect(thai.current, const Locale('en'), reason: '기기·국적 언어 모두 미지원');
    await profile.setCountry(Country.byCode('DE')!);
    expect(thai.current, const Locale('de'));
    expect(profile.homeCurrency, 'EUR');

    await thai.choose('ko');
    expect(thai.current, const Locale('ko'));

    final reloaded = UserProfile();
    await reloaded.load();
    expect(reloaded.country?.code, 'DE');
  });
}
