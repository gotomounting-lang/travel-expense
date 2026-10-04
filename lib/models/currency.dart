/// 여행지에서 자주 쓰는 통화 목록. 목록에 없는 통화도 ISO 코드로 다룰 수 있다.
class Currency {
  const Currency(this.code, this._names, {this.decimals = 2});

  final String code;

  /// ko, en, zh, ja 순서의 통화 이름.
  final List<String> _names;

  /// 소수점 자릿수 (엔화·동 등은 0).
  final int decimals;

  static const _langs = ['ko', 'en', 'zh', 'ja'];

  String name(String languageCode) {
    final i = _langs.indexOf(languageCode);
    return _names.isEmpty ? code : _names[i < 0 ? 1 : i];
  }

  static const krw = Currency('KRW', [
    '대한민국 원',
    'South Korean won',
    '韩元',
    '韓国ウォン',
  ], decimals: 0);

  static const common = <Currency>[
    Currency('USD', ['미국 달러', 'US dollar', '美元', '米ドル']),
    Currency('JPY', ['일본 엔', 'Japanese yen', '日元', '日本円'], decimals: 0),
    Currency('EUR', ['유로', 'Euro', '欧元', 'ユーロ']),
    Currency('CNY', ['중국 위안', 'Chinese yuan', '人民币', '人民元']),
    Currency('TWD', ['대만 달러', 'Taiwan dollar', '新台币', '台湾ドル'], decimals: 0),
    Currency('HKD', ['홍콩 달러', 'Hong Kong dollar', '港币', '香港ドル']),
    Currency('THB', ['태국 바트', 'Thai baht', '泰铢', 'タイバーツ']),
    Currency('VND', ['베트남 동', 'Vietnamese dong', '越南盾', 'ベトナムドン'], decimals: 0),
    Currency('PHP', ['필리핀 페소', 'Philippine peso', '菲律宾比索', 'フィリピンペソ']),
    Currency('SGD', ['싱가포르 달러', 'Singapore dollar', '新加坡元', 'シンガポールドル']),
    Currency('MYR', ['말레이시아 링깃', 'Malaysian ringgit', '马来西亚林吉特', 'マレーシアリンギット']),
    Currency('IDR', [
      '인도네시아 루피아',
      'Indonesian rupiah',
      '印尼盾',
      'インドネシアルピア',
    ], decimals: 0),
    Currency('GBP', ['영국 파운드', 'British pound', '英镑', '英ポンド']),
    Currency('CHF', ['스위스 프랑', 'Swiss franc', '瑞士法郎', 'スイスフラン']),
    Currency('AUD', ['호주 달러', 'Australian dollar', '澳元', '豪ドル']),
    Currency('NZD', ['뉴질랜드 달러', 'New Zealand dollar', '新西兰元', 'NZドル']),
    Currency('CAD', ['캐나다 달러', 'Canadian dollar', '加元', 'カナダドル']),
    Currency('MNT', [
      '몽골 투그릭',
      'Mongolian tugrik',
      '蒙古图格里克',
      'モンゴルトゥグルグ',
    ], decimals: 0),
    Currency('TRY', ['튀르키예 리라', 'Turkish lira', '土耳其里拉', 'トルコリラ']),
    Currency('CZK', ['체코 코루나', 'Czech koruna', '捷克克朗', 'チェココルナ']),
    Currency('MOP', ['마카오 파타카', 'Macanese pataca', '澳门元', 'マカオパタカ']),
    Currency('INR', ['인도 루피', 'Indian rupee', '印度卢比', 'インドルピー']),
    Currency('KZT', ['카자흐스탄 텡게', 'Kazakhstani tenge', '哈萨克斯坦坚戈', 'カザフスタンテンゲ']),
    Currency('UZS', [
      '우즈베키스탄 숨',
      'Uzbekistani som',
      '乌兹别克斯坦苏姆',
      'ウズベキスタンスム',
    ], decimals: 0),
    Currency('RUB', ['러시아 루블', 'Russian ruble', '俄罗斯卢布', 'ロシアルーブル']),
    Currency('AED', ['아랍에미리트 디르함', 'UAE dirham', '阿联酋迪拉姆', 'UAEディルハム']),
    Currency('SAR', ['사우디 리얄', 'Saudi riyal', '沙特里亚尔', 'サウジアラビアリヤル']),
    Currency('MXN', ['멕시코 페소', 'Mexican peso', '墨西哥比索', 'メキシコペソ']),
    Currency('BRL', ['브라질 헤알', 'Brazilian real', '巴西雷亚尔', 'ブラジルレアル']),
    krw,
  ];

  static Currency byCode(String code) {
    final upper = code.toUpperCase();
    return common.firstWhere(
      (c) => c.code == upper,
      orElse: () => Currency(upper, const []),
    );
  }
}
