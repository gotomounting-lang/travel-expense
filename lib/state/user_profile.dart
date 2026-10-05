import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/country.dart';

/// 사용자 국적. 처음 실행할 때 로그인 다음 화면에서 고른다.
/// 국적이 지출을 환산할 통화와 앱 언어를 정한다.
class UserProfile extends ChangeNotifier {
  UserProfile({Country? initial, this.deviceCountry}) : _country = initial;

  /// 기기(플레이스토어) 지역 설정의 나라. 국적을 고르기 전 기본값이고,
  /// 국적 화면 맨 위에 보여 준다.
  final Country? deviceCountry;

  static const _prefKey = 'nationality';

  Country? _country;
  Country? get country => _country;

  bool get hasNationality => _country != null;

  /// 지출을 환산해 보여줄 통화. 국적을 고르기 전에는 기기 지역의 나라 통화,
  /// 그것도 모르면 미국 달러.
  String get homeCurrency => (_country ?? deviceCountry)?.currency ?? 'USD';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _country = Country.byCode(prefs.getString(_prefKey)) ?? _country;
    notifyListeners();
  }

  Future<void> setCountry(Country country) async {
    _country = country;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, country.code);
    notifyListeners();
  }
}
