/// 사용자 국적. 국적이 환산 통화(내 나라 돈)와 앱 언어를 정한다.
class Country {
  const Country(this.code, this.currency, this.flag, this._names);

  /// ISO 3166-1 alpha-2.
  final String code;

  /// 지출을 환산해 보여줄 통화 (ISO 4217).
  final String currency;
  final String flag;

  /// ko, en, zh, ja 순서의 나라 이름.
  final List<String> _names;

  static const _langs = ['ko', 'en', 'zh', 'ja'];

  String name(String languageCode) {
    final i = _langs.indexOf(languageCode);
    return _names[i < 0 ? 1 : i];
  }

  /// 국적에 따른 앱 언어. 앱이 지원하는 언어의 나라가 아니면 영어.
  String get language => ownLanguage ?? 'en';

  /// 그 나라 말을 앱이 지원하면 그 언어, 아니면 null.
  String? get ownLanguage => switch (code) {
    'US' || 'GB' || 'CA' || 'AU' || 'NZ' => 'en',
    'KR' => 'ko',
    'CN' || 'TW' || 'HK' || 'MO' => 'zh',
    'JP' => 'ja',
    'VN' => 'vi',
    'RU' => 'ru',
    'DE' || 'AT' => 'de',
    'MN' => 'mn',
    'FR' => 'fr',
    'MM' => 'my',
    'PH' => 'fil',
    'ID' => 'id',
    'MY' => 'ms',
    'IN' => 'hi',
    _ => null,
  };

  static Country? byCode(String? code) =>
      all.where((c) => c.code == code).firstOrNull;

  static const all = <Country>[
    Country('KR', 'KRW', '🇰🇷', ['대한민국', 'South Korea', '韩国', '韓国']),
    Country('US', 'USD', '🇺🇸', ['미국', 'United States', '美国', 'アメリカ']),
    Country('CN', 'CNY', '🇨🇳', ['중국', 'China', '中国', '中国']),
    Country('JP', 'JPY', '🇯🇵', ['일본', 'Japan', '日本', '日本']),
    Country('TW', 'TWD', '🇹🇼', ['대만', 'Taiwan', '台湾', '台湾']),
    Country('HK', 'HKD', '🇭🇰', ['홍콩', 'Hong Kong', '香港', '香港']),
    Country('MO', 'MOP', '🇲🇴', ['마카오', 'Macao', '澳门', 'マカオ']),
    Country('GB', 'GBP', '🇬🇧', ['영국', 'United Kingdom', '英国', 'イギリス']),
    Country('CA', 'CAD', '🇨🇦', ['캐나다', 'Canada', '加拿大', 'カナダ']),
    Country('AU', 'AUD', '🇦🇺', ['호주', 'Australia', '澳大利亚', 'オーストラリア']),
    Country('NZ', 'NZD', '🇳🇿', ['뉴질랜드', 'New Zealand', '新西兰', 'ニュージーランド']),
    Country('SG', 'SGD', '🇸🇬', ['싱가포르', 'Singapore', '新加坡', 'シンガポール']),
    Country('MY', 'MYR', '🇲🇾', ['말레이시아', 'Malaysia', '马来西亚', 'マレーシア']),
    Country('TH', 'THB', '🇹🇭', ['태국', 'Thailand', '泰国', 'タイ']),
    Country('VN', 'VND', '🇻🇳', ['베트남', 'Vietnam', '越南', 'ベトナム']),
    Country('PH', 'PHP', '🇵🇭', ['필리핀', 'Philippines', '菲律宾', 'フィリピン']),
    Country('ID', 'IDR', '🇮🇩', ['인도네시아', 'Indonesia', '印度尼西亚', 'インドネシア']),
    Country('IN', 'INR', '🇮🇳', ['인도', 'India', '印度', 'インド']),
    Country('MN', 'MNT', '🇲🇳', ['몽골', 'Mongolia', '蒙古', 'モンゴル']),
    Country('MM', 'MMK', '🇲🇲', ['미얀마', 'Myanmar', '缅甸', 'ミャンマー']),
    Country('KZ', 'KZT', '🇰🇿', ['카자흐스탄', 'Kazakhstan', '哈萨克斯坦', 'カザフスタン']),
    Country('UZ', 'UZS', '🇺🇿', ['우즈베키스탄', 'Uzbekistan', '乌兹别克斯坦', 'ウズベキスタン']),
    Country('RU', 'RUB', '🇷🇺', ['러시아', 'Russia', '俄罗斯', 'ロシア']),
    Country('DE', 'EUR', '🇩🇪', ['독일', 'Germany', '德国', 'ドイツ']),
    Country('FR', 'EUR', '🇫🇷', ['프랑스', 'France', '法国', 'フランス']),
    Country('IT', 'EUR', '🇮🇹', ['이탈리아', 'Italy', '意大利', 'イタリア']),
    Country('ES', 'EUR', '🇪🇸', ['스페인', 'Spain', '西班牙', 'スペイン']),
    Country('NL', 'EUR', '🇳🇱', ['네덜란드', 'Netherlands', '荷兰', 'オランダ']),
    Country('CH', 'CHF', '🇨🇭', ['스위스', 'Switzerland', '瑞士', 'スイス']),
    Country('TR', 'TRY', '🇹🇷', ['튀르키예', 'Türkiye', '土耳其', 'トルコ']),
    Country('AE', 'AED', '🇦🇪', [
      '아랍에미리트',
      'United Arab Emirates',
      '阿联酋',
      'アラブ首長国連邦',
    ]),
    Country('SA', 'SAR', '🇸🇦', [
      '사우디아라비아',
      'Saudi Arabia',
      '沙特阿拉伯',
      'サウジアラビア',
    ]),
    Country('MX', 'MXN', '🇲🇽', ['멕시코', 'Mexico', '墨西哥', 'メキシコ']),
    Country('BR', 'BRL', '🇧🇷', ['브라질', 'Brazil', '巴西', 'ブラジル']),
  ];
}
