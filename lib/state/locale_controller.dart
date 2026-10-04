import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import 'user_profile.dart';

/// 앱 언어를 정하는 순서:
/// 1. 설정에서 직접 고른 언어
/// 2. 국적의 언어 (앱이 그 나라 말을 지원할 때)
/// 3. 기기(=Google Play) 언어 중 앱이 지원하는 언어
/// 4. 국적을 골랐으면 영어, 아무것도 없으면 한국어
class LocaleController extends ChangeNotifier {
  LocaleController({List<Locale> Function()? deviceLocales, this.profile})
    : _deviceLocales =
          deviceLocales ?? (() => PlatformDispatcher.instance.locales) {
    profile?.addListener(notifyListeners);
  }

  /// 국적. 설정에서 언어를 직접 고르지 않았으면 국적 언어를 쓴다.
  final UserProfile? profile;

  static const supported = [
    'ko',
    'en',
    'zh',
    'ja',
    'vi',
    'ru',
    'de',
    'mn',
    'fr',
    'my',
    'fil',
    'id',
    'ms',
    'hi',
  ];
  static const fallback = Locale('ko');

  /// 언어 선택 화면에 쓰는 각 언어의 자기 이름.
  static const nativeNames = {
    'ko': '한국어',
    'en': 'English',
    'zh': '中文',
    'ja': '日本語',
    'vi': 'Tiếng Việt',
    'ru': 'Русский',
    'de': 'Deutsch',
    'mn': 'Монгол',
    'fr': 'Français',
    'my': 'မြန်မာ',
    'fil': 'Filipino',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'hi': 'हिन्दी',
  };

  static const _prefKey = 'app_language';

  final List<Locale> Function() _deviceLocales;

  /// 사용자가 고른 언어 코드. null 이면 기기 언어를 따른다.
  String? _choice;
  String? get choice => _choice;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey);
    _choice = supported.contains(saved) ? saved : null;
    notifyListeners();
  }

  Future<void> choose(String? languageCode) async {
    _choice = supported.contains(languageCode) ? languageCode : null;
    final prefs = await SharedPreferences.getInstance();
    if (_choice == null) {
      await prefs.remove(_prefKey);
    } else {
      await prefs.setString(_prefKey, _choice!);
    }
    notifyListeners();
  }

  /// MaterialApp.locale 에 넣는 값.
  /// 직접 고른 언어 > 국적의 언어(앱이 지원할 때) > 기기(플레이스토어) 언어 중
  /// 지원하는 언어 > 국적을 골랐으면 영어.
  /// null 이면 MaterialApp 이 [resolveDevice] 로 기기 언어를 고른다.
  Locale? get selected {
    if (_choice != null) return Locale(_choice!);
    final own = profile?.country?.ownLanguage;
    return own == null ? null : Locale(own);
  }

  /// 지금 화면에 쓰는 언어.
  Locale get current => selected ?? resolveDevice(_deviceLocales());

  /// 기기 언어 중 지원하는 언어. 없으면 국적을 골랐을 때 영어, 아니면 한국어.
  Locale resolveDevice(List<Locale>? deviceLocales) =>
      _firstSupported(deviceLocales ?? const []) ??
      (profile?.country == null ? fallback : const Locale('en'));

  /// 기기 언어 목록에서 처음으로 지원하는 언어를 고르고, 없으면 한국어.
  static Locale resolve(List<Locale>? deviceLocales) =>
      _firstSupported(deviceLocales ?? const []) ?? fallback;

  /// 안드로이드 옛 버전이 쓰는 언어 코드 (인도네시아어 in, 타갈로그어 tl).
  static const _aliases = {'in': 'id', 'tl': 'fil'};

  static Locale? _firstSupported(List<Locale> locales) {
    for (final l in locales) {
      final code = _aliases[l.languageCode] ?? l.languageCode;
      if (supported.contains(code)) return Locale(code);
    }
    return null;
  }

  AppLocalizations get strings => lookupAppLocalizations(current);
}
