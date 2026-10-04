import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import 'user_profile.dart';

/// 앱 언어를 정하는 순서:
/// 1. 설정에서 직접 고른 언어
/// 2. 국적 (한국 → 한국어, 중국·대만·홍콩·마카오 → 중국어, 일본 → 일본어, 그 외 → 영어)
/// 3. 국적을 고르기 전(첫 화면): 기기(=Google Play) 언어, 지원하지 않으면 한국어
class LocaleController extends ChangeNotifier {
  LocaleController({List<Locale> Function()? deviceLocales, this.profile})
    : _deviceLocales =
          deviceLocales ?? (() => PlatformDispatcher.instance.locales) {
    profile?.addListener(notifyListeners);
  }

  /// 국적. 설정에서 언어를 직접 고르지 않았으면 국적 언어를 쓴다.
  final UserProfile? profile;

  static const supported = ['ko', 'en', 'zh', 'ja'];
  static const fallback = Locale('ko');

  /// 언어 선택 화면에 쓰는 각 언어의 자기 이름.
  static const nativeNames = {
    'ko': '한국어',
    'en': 'English',
    'zh': '中文',
    'ja': '日本語',
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

  /// MaterialApp.locale 에 넣는 값. null 이면 [resolve] 가 기기 언어로 고른다.
  Locale? get selected {
    final code = _choice ?? profile?.country?.language;
    return code == null ? null : Locale(code);
  }

  /// 지금 화면에 쓰는 언어.
  Locale get current => selected ?? resolve(_deviceLocales());

  /// 기기 언어 목록에서 처음으로 지원하는 언어를 고르고, 없으면 한국어.
  static Locale resolve(List<Locale>? deviceLocales) {
    for (final l in deviceLocales ?? const <Locale>[]) {
      if (supported.contains(l.languageCode)) return Locale(l.languageCode);
    }
    return fallback;
  }

  AppLocalizations get strings => lookupAppLocalizations(current);
}
