/// 여행지에서 자주 쓰는 통화 목록. 목록에 없는 통화도 ISO 코드로 직접 입력할 수 있다.
class Currency {
  const Currency(this.code, this.name, {this.decimals = 2});

  final String code;
  final String name;

  /// 소수점 자릿수 (엔화·동 등은 0).
  final int decimals;

  static const krw = Currency('KRW', '대한민국 원', decimals: 0);

  static const common = <Currency>[
    Currency('USD', '미국 달러'),
    Currency('JPY', '일본 엔', decimals: 0),
    Currency('EUR', '유로'),
    Currency('CNY', '중국 위안'),
    Currency('TWD', '대만 달러', decimals: 0),
    Currency('HKD', '홍콩 달러'),
    Currency('THB', '태국 바트'),
    Currency('VND', '베트남 동', decimals: 0),
    Currency('PHP', '필리핀 페소'),
    Currency('SGD', '싱가포르 달러'),
    Currency('MYR', '말레이시아 링깃'),
    Currency('IDR', '인도네시아 루피아', decimals: 0),
    Currency('GBP', '영국 파운드'),
    Currency('CHF', '스위스 프랑'),
    Currency('AUD', '호주 달러'),
    Currency('NZD', '뉴질랜드 달러'),
    Currency('CAD', '캐나다 달러'),
    Currency('MNT', '몽골 투그릭', decimals: 0),
    Currency('TRY', '튀르키예 리라'),
    Currency('CZK', '체코 코루나'),
    krw,
  ];

  static Currency byCode(String code) {
    final upper = code.toUpperCase();
    return common.firstWhere(
      (c) => c.code == upper,
      orElse: () => Currency(upper, upper),
    );
  }
}
