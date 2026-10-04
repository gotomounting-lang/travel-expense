import '../models/category.dart';
import '../models/currency.dart';
import 'receipt_parser.dart';

/// 카드 앱(또는 카카오톡 알림톡) 결제 알림 한 건.
class CardNotification {
  const CardNotification({
    required this.id,
    required this.text,
    required this.postedAt,
    this.packageName = '',
    this.title = '',
  });

  final String id;
  final String packageName;
  final String title;
  final String text;

  /// 알림이 기기에 도착한 시각 (여행지 기기 시간).
  final DateTime postedAt;

  factory CardNotification.fromMap(Map<Object?, Object?> m) => CardNotification(
    id: m['id'] as String,
    packageName: (m['package'] as String?) ?? '',
    title: (m['title'] as String?) ?? '',
    text: (m['text'] as String?) ?? '',
    postedAt: DateTime.fromMillisecondsSinceEpoch(
      (m['postedAt'] as num).toInt(),
    ),
  );
}

/// 알림에서 읽어 낸 해외 결제.
class CardPayment {
  const CardPayment({
    required this.currency,
    required this.amount,
    required this.spentAt,
    this.merchant = '',
    this.card = '',
    this.category,
    this.withForeign = false,
  });

  /// 외화 금액이 함께 찍혀 있었는지 (해외 결제).
  final bool withForeign;

  final String currency;
  final double amount;
  final DateTime spentAt;
  final String merchant;

  /// 결제수단 칸에 쓸 카드 이름 (예: 신한카드(1234)).
  final String card;
  final ExpenseCategory? category;

  ReceiptDraft toDraft() => ReceiptDraft(
    amount: amount,
    currency: currency,
    date: spentAt,
    merchant: merchant,
    category: category,
    paymentMethod: card,
  );
}

/// 국내 카드사의 해외 승인 알림 문구를 읽는다.
///
/// 카드사마다 문구가 조금씩 달라서 특정 형식에 묶지 않고
/// "승인" 표시 + 외화 통화 코드와 금액을 찾는 방식으로 읽는다.
/// 취소·거절 알림과 내 나라 통화 결제는 기록하지 않는다.
class CardNotificationParser {
  CardNotificationParser({this.homeCurrency = 'KRW'});

  /// 사용자 나라 통화. 이 통화로 결제한 알림(국내 결제)은 기록하지 않는다.
  final String homeCurrency;

  /// 결제(승인) 알림을 뜻하는 말. 앱이 지원하는 14개 언어 나라의 카드사·은행
  /// 알림 표기를 모았다.
  static final _approved = RegExp(
    // 한국어
    r'승인|'
    // 영어 (미국·영국·인도·필리핀·말레이시아 은행 SMS 포함)
    r'approved|approval|purchase|spent|charged|debited|transaction|'
    r'payment of|paid|txn|'
    // 일본어·중국어
    r'承認|ご利用|利用|決済|批准|已消费|消费|消費|支付|交易|刷卡|'
    // 베트남어
    r'giao dịch|\bGD\b|thanh toán|chi tiêu|'
    // 러시아어
    r'покупка|оплата|списание|'
    // 독일어
    r'zahlung|bezahlt|umsatz|belastung|'
    // 몽골어
    r'гүйлгээ|төлбөр|зарцуулалт|худалдан авалт|'
    // 프랑스어
    r'paiement|achat|débit|'
    // 미얀마어
    r'ငွေပေးချေ|ဝယ်ယူ|'
    // 타갈로그어
    r'nagbayad|bayad|binili|'
    // 인도네시아어·말레이어
    r'transaksi|pembelian|pembayaran|bayaran|belian|'
    // 힌디어
    r'लेनदेन|खर्च|भुगतान|डेबिट',
    caseSensitive: false,
  );
  static final _rejected = RegExp(
    r'취소|거절|거부|실패|한도초과|\(광고\)|'
    r'cancel|declin|reject|refund|reversal|reversed|credited|failed|'
    r'取消|取り消し|キャンセル|返品|拒否|撤销|退款|失败|拒绝|'
    r'hủy|huỷ|từ chối|thất bại|hoàn tiền|'
    r'отмен|отказ|возврат|отклон|'
    r'storn|abgelehnt|erstattung|gutschrift|'
    r'цуцал|татгалз|буцаалт|'
    r'annul|refus|rembours|'
    r'ပယ်ဖျက်|ငြင်းပယ်|'
    r'kinansela|tinanggihan|'
    r'dibatalkan|ditolak|gagal|batal|pengembalian|'
    r'रद्द|अस्वीकृत|वापसी',
    caseSensitive: false,
  );

  /// 금액: "1,234.56" "1.234,56" "1 234,56"(띄어쓰기 대신 쓰는 공백 문자) "12.5".
  static const _amt =
      r'\d{1,3}(?:[,.  ]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?';

  static final _currencyAmount = RegExp(
    '\\b([A-Z]{3})[ \\u00a0]?($_amt)|($_amt)[ \\u00a0]?([A-Z]{3})\\b',
  );

  /// 나라별 통화 기호·단위. 통화 코드(USD) 대신 이것을 쓰는 알림이 많다.
  static const _symbols = <String, List<String>>{
    'KRW': ['원', '₩', '￦'],
    'VND': ['₫', 'đ', 'VNĐ', 'vnd'],
    'RUB': ['₽', 'руб.', 'руб', 'р.'],
    'EUR': ['€'],
    'MNT': ['₮', 'төг'],
    'MMK': ['Ks', 'ကျပ်'],
    'PHP': ['₱', 'Php'],
    'IDR': ['Rp.', 'Rp'],
    'MYR': ['RM'],
    'INR': ['₹', 'Rs.', 'Rs'],
    'JPY': ['円', '¥', '￥'],
    'CNY': ['元', '¥', '￥', 'RMB'],
    'TWD': [r'NT$', '元'],
    'HKD': [r'HK$'],
    'SGD': [r'S$'],
    'USD': [r'US$', r'$'],
    'CAD': [r'C$', r'$'],
    'AUD': [r'A$', r'$'],
    'GBP': ['£'],
    'THB': ['฿', 'บาท'],
    'TRY': ['₺'],
    'PLN': ['zł'],
    'CZK': ['Kč'],
  };

  /// 다른 나라 통화로 오해할 일이 없는 기호 (외화 금액 찾기에 쓴다).
  static const _uniqueSymbols = {
    '€': 'EUR',
    '£': 'GBP',
    '₫': 'VND',
    '₽': 'RUB',
    '₮': 'MNT',
    '₹': 'INR',
    '₱': 'PHP',
    '฿': 'THB',
    '₩': 'KRW',
    '￦': 'KRW',
    '원': 'KRW',
    '円': 'JPY',
    '₺': 'TRY',
    'zł': 'PLN',
    'Kč': 'CZK',
  };

  static final _symbolCache = <String, RegExp>{};

  /// [code] 통화의 기호·단위가 붙은 금액 ("31,101원", "₫1.250.000", "Rp 25.000").
  static RegExp _symbolAmount(String code) =>
      _symbolCache.putIfAbsent(code, () {
        final syms = (_symbols[code] ?? const <String>[])
            .map(RegExp.escape)
            .join('|');
        if (syms.isEmpty) return RegExp(r'(?!)');
        return RegExp(
          '(?:$syms)[  ]?(?<a>$_amt)'
          '|(?<b>$_amt)[  ]?(?:$syms)(?![A-Za-z])',
          caseSensitive: false,
        );
      });

  static String _amountOf(RegExpMatch m) => m.groupNames.contains('a')
      ? (m.namedGroup('a') ?? m.namedGroup('b')!)
      : (m[2] ?? m[3]!);

  static double? _value(String raw, String code) {
    final v = ReceiptParser.parseAmount(
      raw,
      decimals: Currency.byCode(code).decimals,
    );
    return v == null || v <= 0 ? null : v;
  }

  static const _issuers = [
    'KB국민',
    '국민',
    '신한',
    '삼성',
    '현대',
    '하나',
    '우리',
    '롯데',
    'BC',
    '비씨',
    'NH농협',
    '농협',
    '씨티',
    'IBK',
    '기업',
    '카카오뱅크',
    '카카오',
    '토스',
    '케이뱅크',
    '트래블월렛',
    '트래블로그',
    'SC제일',
    '수협',
    '광주',
    '전북',
    '제주',
    // 다른 나라 카드사·은행·간편결제 (결제수단 칸 이름용)
    'Visa', 'Mastercard', 'Amex', 'JCB', 'UnionPay', '银联',
    '楽天', '三井住友', 'イオン', 'セゾン', 'エポス',
    '招商银行', '工商银行', '建设银行', '中国银行', '支付宝', '微信支付',
    'Vietcombank', 'Techcombank', 'BIDV', 'VPBank', 'VietinBank', 'MB Bank',
    'Сбер', 'Т-Банк', 'Тинькофф', 'Альфа', 'ВТБ',
    'Sparkasse', 'N26', 'DKB', 'Commerzbank', 'Deutsche Bank',
    'Хаан банк', 'Голомт', 'Khan Bank', 'Golomt',
    'BNP', 'Société Générale', 'Crédit Agricole', 'Boursorama', 'Revolut',
    'KBZ', 'AYA', 'CB Bank',
    'BDO', 'BPI', 'Metrobank', 'GCash', 'Maya',
    'BCA', 'Mandiri', 'BNI', 'BRI',
    'Maybank', 'CIMB', 'Public Bank', 'RHB',
    'HDFC', 'ICICI', 'SBI', 'Axis',
    'Wise', 'Chase', 'Citi', 'Capital One', 'Barclays', 'HSBC',
  ];

  static final _cardDigits = RegExp(r'\(?(\d{4}|\d\*\d\*)\)?');
  static final _maskedName = RegExp(r'[가-힣]\*[가-힣]?(님)?');
  static final _dateTime = RegExp(
    r'\d{1,2}/\d{1,2}(\s+\d{1,2}:\d{2})?|\d{1,2}:\d{2}|\d{1,2}월\s?\d{1,2}일',
  );

  static const _noiseWords = [
    '승인',
    '해외',
    '일시불',
    '할부',
    '누적',
    '잔액',
    '사용',
    '결제',
    '카드',
    '체크',
    '신용',
    '원화',
    '약',
    '님',
    '금액',
    '가맹점',
    '이용',
    '알림',
    '실적인정',
    '매입',
    '확정',
    '이용내역',
    'approved',
    'approval',
    'card',
    'のお知らせ',
    'お知らせ',
    '金額',
  ];

  static final _textDate = RegExp(r'(\d{1,2})/(\d{1,2})\s+(\d{1,2}):(\d{2})');

  /// 카드 앱 이용내역 화면의 "2026. 09. 28" · "2026.09.28" · "2026-09-28".
  static final _fullDate = RegExp(
    r'(20\d{2})\s?[./-]\s?(\d{1,2})\s?[./-]\s?(\d{1,2})',
  );

  /// 붙여넣은 이용내역에서 결제가 끝났음을 뜻하는 말.
  static final _settled = RegExp(
    r'매입|확정|결제완료|이용완료|確定|入账|入賬|posted|settled|'
    r'thành công|проведен|списан|gebucht|débité|berhasil|selesai',
    caseSensitive: false,
  );

  /// 바로 앞에 이 말이 있는 금액은 결제 금액이 아니다 (누적 1,234,000원 등).
  static final _notPayment = RegExp(
    r'누적|잔액|한도|가능|'
    r'bal|avail|limit|'
    r'残高|累計|限度|余额|餘額|可用|额度|累计|'
    r'số dư|\bSD\b|hạn mức|'
    r'остаток|баланс|доступно|лимит|'
    r'saldo|kontostand|verfügbar|'
    r'solde|disponible|plafond|'
    r'baki|balanse|natitira|'
    r'үлдэгдэл|хязгаар|'
    r'လက်ကျန်|'
    r'शेष|उपलब्ध',
    caseSensitive: false,
  );

  static int _gap(Match a, Match b) =>
      a.start > b.end ? a.start - b.end : b.start - a.end;

  /// 원화 금액 (예: 31,528원). 내 나라 통화가 원화일 때 붙여넣기에서만 쓴다.

  /// [useTextDate] 가 true 면 (붙여넣은 문구처럼 도착 시각을 모를 때)
  /// 알림 글자 속 "월/일 시:분" 이나 "2026. 09. 28" 을 결제 시각으로 쓴다.
  /// 사용자가 직접 붙여넣은 것이므로 카드 앱 이용내역처럼 원화로 확정된
  /// 해외 결제(매입금액)도 내 나라 통화 금액으로 읽는다.
  CardPayment? parse(CardNotification n, {bool useTextDate = false}) {
    final text = '${n.title}\n${n.text}'.trim();
    if (_rejected.hasMatch(text)) return null;
    String? currency;
    double? amount;
    RegExpMatch? amountMatch;
    RegExpMatch? foreign;
    // 외화 금액: 통화 코드(USD 12.50), 없으면 다른 나라와 헷갈리지 않는
    // 기호(€12.50, 7,150원).
    final foreignCandidates = <(RegExpMatch, String)>[
      for (final m in _currencyAmount.allMatches(text))
        if (m[1] ?? m[4]! case final code
            when code != homeCurrency && _isCurrency(code))
          (m, code),
    ];
    if (foreignCandidates.isEmpty) {
      for (final code in {..._uniqueSymbols.values}) {
        if (code == homeCurrency) continue;
        for (final m in _symbolAmount(code).allMatches(text)) {
          final written = text.substring(m.start, m.end);
          // 그 통화만 쓰는 기호가 실제로 찍혔을 때만 ("\$" 는 여러 나라 기호).
          if (_uniqueSymbols.entries.any(
            (e) => e.value == code && written.contains(e.key),
          )) {
            foreignCandidates.add((m, code));
          }
        }
      }
      foreignCandidates.sort((a, b) => a.$1.start - b.$1.start);
    }
    for (final (m, code) in foreignCandidates) {
      final value = _value(_amountOf(m), code);
      if (value == null) continue;
      currency = code;
      amount = value;
      amountMatch = foreign = m;
      break;
    }

    // 붙여넣기는 사용자가 고른 문구라 "승인" 같은 말이 없어도 읽는다
    // (카드 앱 이용내역 화면에는 승인 표시가 없다).
    final settled = useTextDate && (_settled.hasMatch(text) || foreign != null);
    if (!_approved.hasMatch(text) && !settled) return null;

    // 내 나라 통화 금액 후보. 누적·잔액·한도 금액은 결제 금액이 아니다.
    final homeMatches =
        [
              ..._currencyAmount
                  .allMatches(text)
                  .where((m) => (m[1] ?? m[4]) == homeCurrency),
              ..._symbolAmount(homeCurrency).allMatches(text),
            ]
            .where(
              (m) => !_notPayment.hasMatch(
                text.substring(m.start < 12 ? 0 : m.start - 12, m.start),
              ),
            )
            .toList();

    RegExpMatch? home;
    if (foreign != null) {
      // 외화와 원화(내 나라 통화)가 함께 있으면 실제 청구된 원화를 쓴다.
      // 여러 건이 붙어 있을 수 있어 외화 바로 옆의 금액만 짝으로 본다.
      for (final m in homeMatches) {
        final gap = m.start > foreign.end
            ? m.start - foreign.end
            : foreign.start - m.end;
        if (gap <= 6 && (home == null || gap < _gap(home, foreign))) home = m;
      }
    } else if (useTextDate) {
      // 외화가 없으면 내 나라 통화 금액 (매입금액이 있으면 그것).
      final purchase = text.indexOf(
        RegExp(
          r'매입금액|ご利用金額|消费金额|số tiền|сумма|betrag|montant|amount'
          r'|jumlah|halaga|дүн|राशि',
          caseSensitive: false,
        ),
      );
      homeMatches.sort((a, b) {
        if (purchase >= 0) {
          final pa = a.start > purchase ? 0 : 1;
          final pb = b.start > purchase ? 0 : 1;
          if (pa != pb) return pa - pb;
        }
        return a.start - b.start;
      });
      home = homeMatches.firstOrNull;
    }
    if (home != null) {
      final value = _value(_amountOf(home), homeCurrency);
      if (value != null) {
        currency = homeCurrency;
        amount = value;
        amountMatch = home;
      }
    }
    if (currency == null || amount == null) return null;

    final merchant = _merchant(text, amountMatch!);
    var spentAt = n.postedAt;
    final full = useTextDate ? _fullDate.firstMatch(text) : null;
    if (full != null) {
      final y = int.parse(full[1]!);
      final month = int.parse(full[2]!);
      final day = int.parse(full[3]!);
      final parsed = DateTime(y, month, day, 12);
      if (parsed.month == month && parsed.day == day) spentAt = parsed;
    }
    final d = useTextDate && full == null ? _textDate.firstMatch(text) : null;
    if (d != null) {
      final month = int.parse(d[1]!);
      final day = int.parse(d[2]!);
      // 연말에 받은 1월 알림처럼 미래가 되면 작년으로 본다.
      var year = n.postedAt.year;
      if (month > n.postedAt.month + 1) year -= 1;
      final parsed = DateTime(
        year,
        month,
        day,
        int.parse(d[3]!),
        int.parse(d[4]!),
      );
      if (parsed.month == month && parsed.day == day) spentAt = parsed;
    }
    return CardPayment(
      currency: currency,
      amount: amount,
      spentAt: spentAt,
      merchant: merchant,
      card: _card(text),
      category: ReceiptParser.guessCategory([merchant]),
      withForeign: foreign != null,
    );
  }

  static bool _isCurrency(String code) =>
      Currency.common.any((c) => c.code == code) ||
      const {
        'MOP',
        'INR',
        'AED',
        'SAR',
        'QAR',
        'EGP',
        'ZAR',
        'MXN',
        'BRL',
        'ARS',
        'CLP',
        'PEN',
        'COP',
        'NOK',
        'SEK',
        'DKK',
        'PLN',
        'HUF',
        'ISK',
        'RUB',
        'KZT',
        'UZS',
        'LAK',
        'KHR',
        'MMK',
        'NPR',
        'LKR',
        'MVR',
        'BND',
        'FJD',
        'ILS',
        'JOD',
        'MAD',
        'KES',
        'TZS',
        'RON',
        'BGN',
        'HRK',
        'GEL',
      }.contains(code);

  /// 카드사 이름과 (있으면) 카드 끝자리. 제목과 본문에 모두 이름이 있으면
  /// 끝자리가 붙은 쪽을 쓴다.
  String _card(String text) {
    String? withoutDigits;
    for (final issuer in _issuers) {
      // 한국 카드사만 "카드"를 붙인다 (신한 → 신한카드, Vietcombank 는 그대로).
      final korean =
          RegExp(r'[가-힣]').hasMatch(issuer) ||
          const {'BC', 'IBK', 'SC제일'}.contains(issuer);
      final name = !korean || issuer.endsWith('카드') ? issuer : '$issuer카드';
      // 영문 이름은 단어 단위로 찾는다 ("BCA" 안의 "BC" 는 아님).
      final ascii = RegExp(r'^[\x00-\x7F]+$').hasMatch(issuer);
      final pattern = ascii
          ? RegExp('(?<![A-Za-z])${RegExp.escape(issuer)}(?![A-Za-z])')
          : RegExp(RegExp.escape(issuer));
      for (final m in pattern.allMatches(text)) {
        final after = text
            .substring(m.end)
            .replaceFirst(RegExp(r'^(카드|체크|Pay|페이)?\s*'), '');
        final digits = _cardDigits.matchAsPrefix(after);
        if (digits != null) return '$name(${digits[1]})';
        withoutDigits ??= name;
      }
    }
    return withoutDigits ?? '';
  }

  /// 금액·날짜·이름·카드 표시를 지운 뒤 남은 글자 중 가맹점으로 보이는 것.
  /// "at STARBUCKS", "tại HIGHLANDS", "chez X", "bei X", "di X" 처럼
  /// 가맹점 앞에 붙는 말.
  static final _merchantAfter = RegExp(
    r'(?:^|\s)(?:at|tai|tại|chez|bei|di|sa|в)\s+([^\n.;,|()]+)',
    caseSensitive: false,
  );

  String _merchant(String text, Match amountMatch) {
    final after = _merchantAfter.firstMatch(text);
    if (after != null) {
      var name = after[1]!;
      final cut = _notPayment.firstMatch(name);
      if (cut != null) name = name.substring(0, cut.start);
      name = name.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (RegExp(r'\p{L}{2,}', unicode: true).hasMatch(name)) {
        return name.length > 40 ? name.substring(0, 40) : name;
      }
    }
    final lines = text
        .replaceRange(amountMatch.start, amountMatch.end, ' ')
        .replaceAll(_currencyAmount, ' ')
        .replaceAll(_symbolAmount(homeCurrency), ' ')
        .split(RegExp(r'[\n|]'));
    final candidates = <String>[];
    for (var line in lines) {
      line = line
          .replaceAll(RegExp(r'\[[^\]]*\]|【[^】]*】'), ' ')
          .replaceAll(_maskedName, ' ')
          .replaceAll(RegExp(r'[\d,]+\s?원'), ' ')
          .replaceAll(_dateTime, ' ')
          .replaceAll(RegExp(r'\([^)]*\)'), ' ');
      for (final issuer in _issuers) {
        line = line.replaceAll(issuer, ' ');
      }
      final cut = _notPayment.firstMatch(line);
      if (cut != null) line = line.substring(0, cut.start);
      line = line
          .replaceAll(_approved, ' ')
          .replaceAll(_settled, ' ')
          .replaceAll(
            RegExp(
              r'\b(at|on|via|your|you|made|an?|the|with|using|card|ending|'
              r'a/c|acct|xx+\d*|for|of|is|has|been|bank|chez|carte|par|de|'
              r'bei|karte|kartenzahlung|di|kartu|kad|anda|sa|ka|ng|tai|tại|'
              r'thẻ)\b',
              caseSensitive: false,
            ),
            ' ',
          );
      for (final w in _noiseWords) {
        line = line.replaceAll(
          RegExp(RegExp.escape(w), caseSensitive: false),
          ' ',
        );
      }
      line = line
          .replaceAll(RegExp(r'[\d,.:/*]+'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (RegExp(r'\p{L}{2,}', unicode: true).hasMatch(line)) {
        candidates.add(line);
      }
    }
    if (candidates.isEmpty) return '';
    // 영문 가맹점명이 가장 흔하므로 라틴 문자가 많은 후보를 고른다.
    candidates.sort((a, b) => _latin(b).compareTo(_latin(a)));
    final best = candidates.first;
    return best.length > 40 ? best.substring(0, 40) : best;
  }

  static int _latin(String s) => RegExp(r'[A-Za-z]').allMatches(s).length;
}
