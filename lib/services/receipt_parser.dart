import '../models/category.dart';
import '../models/currency.dart';

/// OCR 이 읽은 한 줄과 화면 위치. 같은 높이의 줄을 한 행으로 묶는 데 쓴다.
class OcrLine {
  const OcrLine(this.text, {this.top = 0, this.bottom = 0, this.left = 0});

  final String text;
  final double top;
  final double bottom;
  final double left;

  double get centerY => (top + bottom) / 2;
  double get height => (bottom - top).abs();
}

class ReceiptItem {
  const ReceiptItem(this.name, this.price);

  final String name;
  final double price;

  @override
  String toString() => '$name $price';
}

/// 영수증에서 읽어 낸 내용. 사용자가 확인 화면에서 고친 뒤 저장한다.
class ReceiptDraft {
  const ReceiptDraft({
    this.amount,
    this.currency,
    this.date,
    this.merchant = '',
    this.category,
    this.items = const [],
    this.paymentMethod = '',
    this.totalByWord = false,
  });

  /// 합계 금액. 합계 단어 줄에서 읽지 못했으면 null (사용자가 직접 입력).
  final double? amount;

  /// 영수증에 찍힌 통화. 통화 표시를 찾지 못했으면 null (사용자가 직접 고름).
  final String? currency;

  /// 날짜(와 읽을 수 있으면 시간). 못 읽으면 null.
  final DateTime? date;
  final String merchant;
  final ExpenseCategory? category;
  final List<ReceiptItem> items;

  /// 카드 알림에서 읽은 카드 이름 (영수증에서는 비어 있음).
  final String paymentMethod;

  /// 합계 단어("TOTAL", "합계"...) 가 있는 줄에서 금액을 읽었는지.
  /// 아니면 가장 큰 금액으로 짐작한 것이다.
  final bool totalByWord;

  bool get isEmpty => amount == null && date == null && merchant.isEmpty;
}

/// 여러 나라 영수증 글자에서 합계·통화·날짜·가맹점·품목을 찾는다.
///
/// 규칙 기반이라 완벽하지 않으므로 결과는 항상 확인 화면을 거친다.
class ReceiptParser {
  ReceiptParser({required this.tripCurrency, this.tripStart, this.tripEnd});

  /// 여행 기본 통화. 영수증에 통화 표시가 없거나 애매할 때 쓴다.
  final String tripCurrency;
  final DateTime? tripStart;
  final DateTime? tripEnd;

  ReceiptDraft parse(List<OcrLine> lines) {
    final rows = groupRows(lines);
    if (rows.isEmpty) return const ReceiptDraft();
    final all = rows.join('\n');

    var currency = detectCurrency(all);
    // 영수증에 통화 표시(₩, ￦, 원, \$, RM...)가 있어야 통화를 확인한 것으로 본다.
    final currencyFound = _currenciesIn(all).isNotEmpty;
    final decimals = Currency.byCode(currency).decimals;
    final amount = _findTotal(rows, decimals);
    // 합계 줄에 통화 표시가 있으면 그것이 실제 결제 통화다
    // (유로 환산 금액이 함께 찍힌 체코 영수증 등).
    final onTotal = _currenciesIn(_totalRow ?? '');
    if (onTotal.isNotEmpty) {
      currency = onTotal.contains(tripCurrency) ? tripCurrency : onTotal.first;
    }
    final date = _findDate(all, currency);
    final merchant = _findMerchant(rows);
    final items = _findItems(rows, decimals, amount);
    final category = guessCategory([merchant, ...items.map((i) => i.name)]);

    // 합계 단어 줄에서 읽은 금액만 쓴다. 짐작한 금액이나 통화는 비워 두고
    // 사용자가 직접 입력하게 한다.
    final byWord = _totalRow != null;
    return ReceiptDraft(
      amount: byWord ? amount : null,
      currency: currencyFound ? currency : null,
      date: date,
      merchant: merchant,
      category: category,
      items: items,
      totalByWord: byWord,
    );
  }

  // ---- 행 묶기 ----

  /// 세로 위치가 겹치는 줄을 왼쪽부터 이어 붙여 한 행으로 만든다.
  /// (품목 이름과 가격이 서로 다른 줄로 인식되는 경우가 많다.)
  static List<String> groupRows(List<OcrLine> lines) {
    final sorted = lines.where((l) => l.text.trim().isNotEmpty).toList()
      ..sort((a, b) => a.centerY.compareTo(b.centerY));
    final rows = <List<OcrLine>>[];
    for (final line in sorted) {
      final last = rows.isEmpty ? null : rows.last;
      if (last != null) {
        final ref = last.first;
        final tolerance =
            (ref.height < line.height ? ref.height : line.height) * 0.5;
        if ((line.centerY - ref.centerY).abs() <= tolerance && tolerance > 0) {
          last.add(line);
          continue;
        }
      }
      rows.add([line]);
    }
    return [
      for (final row in rows)
        (row..sort((a, b) => a.left.compareTo(b.left)))
            .map((l) => l.text.trim())
            .join(' '),
    ];
  }

  // ---- 금액 ----

  static final _number = RegExp(
    r'\d{1,3}(?:[,.]\d{3})+(?:[.,]\d{1,2})?|\d+(?:[.,]\d{1,2})?',
  );

  /// "1,234.56" "1.234,56" "1 280" "¥1,280" 같은 금액 문자열을 숫자로 바꾼다.
  static double? parseAmount(String raw, {int decimals = 2}) {
    var s = raw.replaceAll(RegExp(r'\s'), '');
    if (s.isEmpty) return null;
    if (decimals == 0) {
      // 소수가 없는 통화: 끝의 ".00" 만 떼고 나머지 구분자는 천 단위.
      s = s.replaceFirst(RegExp(r'[.,]\d{1,2}$'), '');
      return double.tryParse(s.replaceAll(RegExp(r'[.,]'), ''));
    }
    final lastSep = s.lastIndexOf(RegExp(r'[.,]'));
    if (lastSep < 0) return double.tryParse(s);
    final tail = s.length - lastSep - 1;
    if (tail == 1 || tail == 2) {
      final intPart = s.substring(0, lastSep).replaceAll(RegExp(r'[.,]'), '');
      return double.tryParse('$intPart.${s.substring(lastSep + 1)}');
    }
    return double.tryParse(s.replaceAll(RegExp(r'[.,]'), ''));
  }

  /// 합계를 뜻하는 말 (나라별 영수증 표기). 앞쪽 목록일수록 최종 합계에 가깝다.
  static const _totalWords = [
    // 영어
    'grand total', 'total due', 'total amount', 'amount due', 'balance due',
    'total to pay', 'total', 'to pay',
    // 한국어
    '총합계', '판매총액', '총판매금액', '총결제금액', '총결재금액', '결제금액',
    '결재금액', '결제 금액', '승인금액', '승인 금액', '청구금액', '받을금액',
    '사용금액', '사용 금액', '이용금액', '거래금액',
    // 나라별 카드전표의 결제 금액
    'sale amount', 'purchase amount', 'amount paid', 'total amount paid',
    'ご利用金額', 'お支払金額', 'お支払い金額', '利用金額', '決済金額',
    '消费金额', '消費金額', '交易金额', '交易金額', '支付金额', '实付金额',
    'số tiền thanh toán', 'tổng thanh toán',
    'сумма покупки', 'сумма оплаты',
    'zahlbetrag', 'kartenzahlung',
    'montant payé', 'montant ttc',
    'total bayar', 'total belanja', 'jumlah bayaran', 'jumlah dibayar',
    'kabuuang halaga',
    'нийт төлөх',
    'ပေးချေငွေ',
    'भुगतान राशि',
    '총액', '총 금액', '총금액', '합계', '합 계',
    // 일본어
    '合計', '合 計', '総合計', '総計', 'お買上計', 'お買上げ計', 'ご請求', 'お会計',
    'お支払', '税込合計',
    // 중국어
    '合计', '总计', '總計', '总额', '總額', '总金额', '總金額', '应付', '應付',
    '应收', '實付', '实付', '实收', '實收', '小票金额',
    // 동남아
    'tổng cộng', 'tổng tiền', 'tổng', 'thanh toán', 'thành tiền',
    'รวมทั้งสิ้น', 'ยอดรวม', 'รวมเงิน', 'รวม', 'jumlah besar', 'jumlah',
    'kabuuan',
    // 유럽
    'gesamtbetrag', 'gesamt', 'summe', 'zu zahlen', 'endbetrag',
    'totale complessivo', 'totale', 'total ttc', 'net à payer', 'à payer',
    'importe total', 'total a pagar', 'valor total', 'a pagar',
    'totaal', 'te betalen', 'totalt', 'att betala', 'i alt', 'å betale',
    'yhteensä', 'celkem', 'k úhradě', 'razem', 'do zapłaty', 'suma',
    'összesen', 'végösszeg', 'fizetendő', 'ukupno', 'za plaćanje',
    'total de plată', 'σύνολο', 'πληρωτέο', 'итого', 'всего', 'к оплате',
    'toplam', 'genel toplam',
    // 몽골·미얀마·인도
    'нийт дүн', 'нийт', 'төлөх', 'စုစုပေါင်း', 'ပေးရန်', 'कुल योग', 'कुल राशि',
    // 중동·남아시아
    'الإجمالي', 'المجموع', 'סה"כ', 'कुल',
    // 그 밖의 "금액" (합계 단어가 없을 때만 쓴다)
    'amount', 'montant', 'importe', 'importo', 'betrag', 'сумма', 'số tiền',
    'halaga', 'дүн', 'राशि', 'ငွေပမာဏ', '金额', '金額',
  ];

  /// "합계"가 아니라 그보다 약한 "금액" 단어. 진짜 합계 단어가 있으면 무시한다.
  static const _weakTotalWords = [
    'amount',
    'montant',
    'importe',
    'importo',
    'betrag',
    'сумма',
    'số tiền',
    'halaga',
    'дүн',
    'राशि',
    'ငွေပမာဏ',
    '金额',
    '金額',
    'jumlah',
    'รวม',
    'tổng',
    'suma',
    'a pagar',
    'to pay',
  ];

  static const _notTotalWords = [
    'subtotal',
    'sub total',
    'sub-total',
    'sous-total',
    'subtotale',
    'zwischensumme',
    'tussentotaal',
    'промежуточный',
    'tax',
    'vat',
    'gst',
    'mwst',
    'ust',
    'tva',
    'iva',
    'btw',
    'moms',
    'dph',
    'ptu',
    'áfa',
    'kdv',
    'ндс',
    'φπα',
    'ppn',
    'thuế',
    'change',
    'cash',
    'tendered',
    'tip',
    'gratuity',
    'discount',
    'points',
    'saving',
    'saved',
    'rückgeld',
    'gegeben',
    'monnaie',
    'rendu',
    'cambio',
    'resto',
    'wechselgeld',
    'sdacha',
    'reszta',
    'сдача',
    '小計',
    '小计',
    '税',
    'お釣',
    'おつり',
    '釣銭',
    '找零',
    '找赎',
    '现金',
    '現金',
    '预付',
    'お預',
    '預り',
    '소계',
    '부가세',
    '과세',
    '면세',
    '거스름',
    '받은금액',
    '승인번호',
    '카드번호',
    '주문번호',
    '가맹점번호',
    '사업자',
    'approval',
    'auth code',
    'auth no',
    'card no',
    '承認番号',
    'カード番号',
    '伝票番号',
    '授权号',
    '授權號',
    '卡号',
    '卡號',
    'mã giao dịch',
    'số thẻ',
    'код авторизации',
    'номер карты',
    'genehmigungsnr',
    'kartennr',
    'autorisation',
    'n° carte',
    'kode otorisasi',
    'no. kartu',
    'no. kad',
    '할인',
    '포인트',
    'tiền thừa',
    'sukli',
    'buwis',
    'cukai',
    'pajak',
    'जीएसटी',
    'хариулт',
    'нөат',
    'tiền khách đưa',
    'เงินทอน',
    'ภาษี',
    'kembalian',
    'tunai',
  ];

  bool _hasAny(String row, List<String> words) {
    final lower = row.toLowerCase();
    return words.any((w) => containsWord(lower, w));
  }

  static final _wordCache = <String, RegExp>{};

  /// 영문 단어는 단어 경계로 찾고 ('taxi' 안의 'tax' 는 아님),
  /// 한·중·일 글자는 그대로 포함 여부를 본다.
  static bool containsWord(String lowerText, String word) {
    final w = word.toLowerCase();
    if (!RegExp(r'^[\x00-\x7F]+$').hasMatch(w)) return lowerText.contains(w);
    final re = _wordCache.putIfAbsent(
      w,
      () => RegExp('(?<![a-z0-9])${RegExp.escape(w)}(?![a-z0-9])'),
    );
    return re.hasMatch(lowerText);
  }

  /// 띄어 쓴 천 단위 금액 (체코·폴란드 등: "2 118 Kč").
  static final _spacedNumber = RegExp(
    r'(?<![\d.,])\d{1,3}(?:[ \u00a0]\d{3})+(?:[.,]\d{1,2})?(?![\d.,])',
  );

  static final _hyphenNumber = RegExp(r'\d+(?:[ ]?-[ ]?\d+)+');

  List<double> _amountsIn(String row, int decimals, {bool spaced = false}) {
    // 날짜·시간·전화번호처럼 보이는 부분은 빼고 숫자를 찾는다.
    final cleaned = row
        .replaceAll(_dateLike, ' ')
        .replaceAll(RegExp(r'\b\d{1,2}:\d{2}(:\d{2})?\b'), ' ')
        // 전화번호·사업자번호처럼 '-' 로 이어진 숫자 ("201-81- 21515").
        .replaceAll(_hyphenNumber, ' ');
    // 천 단위 구분 없이 7자리 넘게 이어진 숫자는 승인번호·사업자번호다
    // (금액이면 "1,000,000" 처럼 찍힌다).
    final noIds = cleaned.replaceAll(RegExp(r'(?<![\d.,])\d{7,}(?![\d])'), ' ');
    if (spaced) {
      final m = _spacedNumber.allMatches(noIds).lastOrNull;
      final v = m == null ? null : parseAmount(m[0]!, decimals: decimals);
      if (v != null && v > 0) return [v];
    }
    return [
      for (final m in _number.allMatches(noIds))
        if (parseAmount(m.group(0)!, decimals: decimals) case final v?)
          if (v > 0) v,
    ];
  }

  /// 금액·통화 표시 말고 다른 글자가 거의 없는 행 (예: "\$10.65", "623.00 CZK").
  static bool _isAmountOnly(String row) {
    final letters = row
        .replaceAll(RegExp(r'\b[A-Z]{3}\b'), '')
        .replaceAll(RegExp(r'Kč|zł|Ft|円|元|원', caseSensitive: false), '')
        .replaceAll(RegExp(r'[^\p{L}]', unicode: true), '');
    return letters.length <= 2 && RegExp(r'\d').hasMatch(row);
  }

  /// 합계 금액을 읽은 줄 (합계 단어 줄, 금액이 옆 줄이면 그 줄까지).
  String? _totalRow;

  /// OCR 이 자주 틀리는 합계 표기를 바로잡는다 ("Totai", "T0TAL" → total)
  /// "Incl GST" 처럼 세금 포함을 뜻하는 말은 세금 줄이 아니므로 지운다.
  static String _normalizeTotalRow(String row) => row
      .replaceAll(RegExp(r'\bt[o0]ta[il1|]\b', caseSensitive: false), 'total')
      .replaceAll(
        RegExp(
          r'\b(?:incl|inkl|including|inclusive|included|incl\.)\.?\s*(?:of\s+)?'
          r'(?:[g6]st|vat|tax|mwst|ust|tva|iva|ppn|sst|btw|moms)\b',
          caseSensitive: false,
        ),
        ' ',
      );

  double? _findTotal(List<String> rawRows, int decimals) {
    _totalRow = null;
    final rows = rawRows.map(_normalizeTotalRow).toList();
    // 1) 합계 키워드가 있는 행의 마지막 금액. 아래쪽 행(최종 합계)일수록 우선.
    // 진짜 합계 단어가 있는 행이 하나라도 있으면 "금액" 같은 약한 단어 행은 뺀다.
    bool strong(String row) => _totalWords
        .where((w) => !_weakTotalWords.contains(w))
        .any((w) => containsWord(row.toLowerCase(), w));
    final hasStrong = rows.any((r) => strong(r) && !_hasAny(r, _notTotalWords));
    double? best;
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (!_hasAny(row, _totalWords) || _hasAny(row, _notTotalWords)) continue;
      if (hasStrong && !strong(row)) continue;
      var amounts = _amountsIn(row, decimals, spaced: true);
      var amountRow = row;
      // 키워드와 금액이 줄바꿈으로 나뉜 경우 바로 아래, 그다음 바로 위 행을
      // 본다. 다른 글자가 섞인 행("Claude Opus 4.5")은 금액만 있는 행이 아니다.
      for (final j in [i + 1, i - 1]) {
        if (amounts.isNotEmpty) break;
        if (j < 0 || j >= rows.length || !_isAmountOnly(rows[j])) continue;
        amounts = _amountsIn(rows[j], decimals, spaced: true);
        amountRow = '$row ${rows[j]}';
      }
      if (amounts.isEmpty) continue;
      final v = amounts.last;
      if (best == null || v >= best) {
        best = v;
        _totalRow = amountRow;
      }
    }
    if (best != null) return best;

    // 2) 키워드가 없으면 (거스름돈·현금 행을 뺀) 가장 큰 금액.
    // 사업자번호("1088962-P") 같은 글자 붙은 숫자는 금액이 아니다.
    // 소수 통화에서 소수점 있는 금액이 있으면 그것만 본다.
    final rowsForAmounts = [
      for (final row in rows)
        if (!_hasAny(row, _notTotalWords))
          row
              .replaceAll(_hyphenNumber, ' ')
              .replaceAll(
                RegExp(r'[\p{L}\d]*\d[-\p{L}][\p{L}\d-]*', unicode: true),
                ' ',
              ),
    ];
    var candidates = [
      for (final row in rowsForAmounts) ..._amountsIn(row, decimals),
    ].where((v) => v < 100000000).toList();
    if (decimals > 0) {
      final withCents = [
        for (final row in rowsForAmounts)
          for (final m in RegExp(
            r'(?<![\d.,])\d[\d,.]*[.,]\d{2}(?![\d.,])',
          ).allMatches(row))
            if (parseAmount(m[0]!, decimals: decimals) case final v?)
              if (v > 0 && v < 100000000) v,
      ];
      if (withCents.isNotEmpty) candidates = withCents;
    }
    if (candidates.isEmpty) return null;
    candidates.sort();
    return candidates.last;
  }

  // ---- 통화 ----

  static const _symbols = {
    'NT\$': 'TWD',
    'HK\$': 'HKD',
    'S\$': 'SGD',
    'A\$': 'AUD',
    'NZ\$': 'NZD',
    'US\$': 'USD',
    'C\$': 'CAD',
    'R\$': 'BRL',
    'MOP\$': 'MOP',
    'RMB': 'CNY',
    'KČ': 'CZK',
    'ZŁ': 'PLN',
    '€': 'EUR',
    '£': 'GBP',
    '₩': 'KRW',
    '￦': 'KRW',
    '฿': 'THB',
    '₫': 'VND',
    '₱': 'PHP',
    '₹': 'INR',
    '₺': 'TRY',
    '₽': 'RUB',
    '₮': 'MNT',
    '₸': 'KZT',
    '円': 'JPY',
    '元': 'CNY',
    'บาท': 'THB',
    'ĐỒNG': 'VND',
  };

  /// 영수증에 찍힌 통화. 여행지(현지) 통화 표시가 있으면 그것을 먼저 고른다.
  String detectCurrency(String text) {
    final found = _currenciesIn(text);
    if (found.contains(tripCurrency)) return tripCurrency;
    return found.isEmpty ? tripCurrency : found.first;
  }

  /// 글자 속 통화 코드·기호를 나온 순서대로.
  List<String> _currenciesIn(String text) {
    final upper = text.toUpperCase();
    final found = <String>[];
    for (final m in RegExp(r'\b([A-Z]{3})\b').allMatches(upper)) {
      final code = m[1]!;
      if (Currency.common.any((c) => c.code == code)) found.add(code);
    }
    for (final e in _symbols.entries) {
      if (upper.contains(e.key)) {
        // '元' 은 대만·홍콩·마카오 영수증에도 쓰인다.
        if (e.key == '元' && ['TWD', 'HKD', 'MOP'].contains(tripCurrency)) {
          found.add(tripCurrency);
        } else {
          found.add(e.value);
        }
      }
    }
    // 'RM 12.50', 'Rp 25.000' 처럼 숫자 바로 앞의 표시만 본다 ("TERMINAL" 의 RM 은 아님).
    if (RegExp(r'\bRM\s?\d').hasMatch(upper)) found.add('MYR');
    // '원' 은 금액 단위로 쓰일 때만 ("17,600원", "금액(원)", "단위: 원").
    // "회원", "원두" 의 원은 아님.
    if (RegExp(r'\d\s?원|\(\s*원\s*\)|단위\s*[:：]?\s*원').hasMatch(text)) {
      found.add('KRW');
    }
    if (RegExp(r'\bRP\.?\s?\d').hasMatch(upper)) found.add('IDR');
    if (text.contains('¥') || text.contains('￥')) {
      found.add(tripCurrency == 'CNY' ? 'CNY' : 'JPY');
    }
    if (text.contains('\$')) {
      // 달러·페소 나라는 모두 '\$' 를 쓴다.
      const dollars = [
        'USD',
        'TWD',
        'HKD',
        'SGD',
        'AUD',
        'NZD',
        'CAD',
        'MXN',
        'MOP',
        'ARS',
        'CLP',
        'COP',
      ];
      found.add(dollars.contains(tripCurrency) ? tripCurrency : 'USD');
    }
    return found;
  }

  // ---- 날짜 ----

  static final _dateLike = RegExp(
    r'(\d{4})\s*[-/.年]\s*(\d{1,2})\s*[-/.月]\s*(\d{1,2})\s*日?'
    r'|(\d{1,2})\s*[-/.]\s*(\d{1,2})\s*[-/.]\s*(\d{4}|\d{2})\b',
  );
  static const _months = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  /// "15 Dec 17", "15-Dec-2017", "Dec 15, 2017" 처럼 영문 달 이름이 있는 날짜.
  static final _namedDate = RegExp(
    r'\b(\d{1,2})[\s\-/.]*(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?[\s\-/.,]*(\d{4}|\d{2})\b'
    r'|\b(jan|feb|mar|apr|may|jun|jul|aug|sep|oct|nov|dec)[a-z]*\.?\s*(\d{1,2}),?\s*(\d{4})\b',
    caseSensitive: false,
  );
  static final _time = RegExp(r'\b([01]?\d|2[0-3]):([0-5]\d)(?::[0-5]\d)?\b');

  DateTime? _findDate(String text, String currency) {
    final candidates = <DateTime>[];
    for (final m in _dateLike.allMatches(text)) {
      if (m[1] != null) {
        _addDate(
          candidates,
          int.parse(m[1]!),
          int.parse(m[2]!),
          int.parse(m[3]!),
        );
      } else {
        final a = int.parse(m[4]!);
        final b = int.parse(m[5]!);
        var y = int.parse(m[6]!);
        // "6.15.00" 같은 번호 조각은 날짜가 아니다 (두 자리 연도는 2010년 이후만).
        if (y < 100) {
          if (y < 10) continue;
          y += 2000;
        }
        // 앞 숫자가 12 보다 크면 일/월, 뒤가 크면 월/일. 애매하면 미국 달러만 월/일.
        final monthFirst = a <= 12 && (b > 12 || currency == 'USD');
        if (monthFirst) {
          _addDate(candidates, y, a, b);
        } else {
          _addDate(candidates, y, b, a);
        }
      }
    }
    for (final m in _namedDate.allMatches(text)) {
      final day = int.parse(m[1] ?? m[5]!);
      final month = _months[(m[2] ?? m[4]!).toLowerCase()]!;
      var y = int.parse(m[3] ?? m[6]!);
      if (y < 100) y += 2000;
      _addDate(candidates, y, month, day, front: true);
    }
    if (candidates.isEmpty) return null;
    // 여행 기간 안의 날짜를 우선한다.
    final inTrip = candidates.where(_inTrip);
    var date = inTrip.isNotEmpty ? inTrip.first : candidates.first;

    final t = _time.firstMatch(text);
    if (t != null) {
      date = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(t[1]!),
        int.parse(t[2]!),
      );
    }
    return date;
  }

  void _addDate(List<DateTime> out, int y, int m, int d, {bool front = false}) {
    if (y < 2000 || y > 2100 || m < 1 || m > 12 || d < 1 || d > 31) return;
    final date = DateTime(y, m, d);
    if (date.month != m) return; // 2월 30일 같은 날짜
    // 달 이름이 쓰인 날짜는 숫자만 있는 것보다 확실하다.
    front ? out.insert(0, date) : out.add(date);
  }

  bool _inTrip(DateTime d) {
    if (tripStart == null || tripEnd == null) return false;
    return !d.isBefore(tripStart!.subtract(const Duration(days: 1))) &&
        !d.isAfter(tripEnd!.add(const Duration(days: 1)));
  }

  // ---- 가맹점 ----

  static const _headerNoise = [
    'receipt',
    'invoice',
    'tax invoice',
    'welcome',
    'thank',
    'tel',
    'phone',
    'www',
    'http',
    '@',
    '領収',
    '领收',
    '收据',
    '收據',
    '発票',
    '发票',
    '영수증',
    '레시피',
    'レシート',
    '電話',
    '电话',
    '사업자',
    '주소',
    'address',
  ];

  static final _letter = RegExp(r'\p{L}', unicode: true);

  String _findMerchant(List<String> rows) {
    for (final row in rows.take(6)) {
      final text = row.trim();
      final letters = _letter.allMatches(text).length;
      if (letters < 2) continue;
      if (_hasAny(text, _headerNoise)) continue;
      if (_dateLike.hasMatch(text) || _time.hasMatch(text)) continue;
      return text.length > 40 ? text.substring(0, 40) : text;
    }
    return '';
  }

  // ---- 품목 ----

  static final _trailingPrice = RegExp(
    r'^(.*?[^\d\s.,x×@*].*?)\s*[¥￥$€£₩￦฿₫]?\s*(\d[\d,.]*)\s*[円元원]?\s*$',
  );

  List<ReceiptItem> _findItems(List<String> rows, int decimals, double? total) {
    final items = <ReceiptItem>[];
    for (final row in rows) {
      if (_hasAny(row, _totalWords) || _hasAny(row, _notTotalWords)) continue;
      if (_dateLike.hasMatch(row) || _hasAny(row, _headerNoise)) continue;
      final m = _trailingPrice.firstMatch(row.trim());
      if (m == null) continue;
      final name = m[1]!.replaceAll(RegExp(r'[\s*:]+$'), '').trim();
      final price = parseAmount(m[2]!, decimals: decimals);
      if (name.length < 2 || price == null || price <= 0) continue;
      if (total != null && price > total) continue;
      items.add(ReceiptItem(name, price));
      if (items.length >= 20) break;
    }
    return items;
  }

  // ---- 카테고리 ----

  static const _categoryWords = <ExpenseCategory, List<String>>{
    ExpenseCategory.snack: [
      'cafe',
      'café',
      'coffee',
      'starbucks',
      'latte',
      'bakery',
      'dessert',
      'ice cream',
      'gelato',
      'donut',
      'tea',
      'snack',
      '7-eleven',
      'lawson',
      'familymart',
      'family mart',
      'ministop',
      'カフェ',
      'コーヒー',
      '珈琲',
      'ローソン',
      'ファミリーマート',
      'セブン',
      '咖啡',
      '奶茶',
      '甜品',
      '面包',
      '便利店',
      '카페',
      '커피',
      '편의점',
      '베이커리',
    ],
    ExpenseCategory.food: [
      'restaurant',
      'ramen',
      'sushi',
      'burger',
      'pizza',
      'kitchen',
      'bistro',
      'grill',
      'izakaya',
      'noodle',
      'dining',
      'steak',
      'bbq',
      'pho',
      'food',
      'レストラン',
      'ラーメン',
      '寿司',
      '居酒屋',
      '食堂',
      '定食',
      'うどん',
      'そば',
      '餐厅',
      '餐廳',
      '饭',
      '飯',
      '面馆',
      '麺',
      '火锅',
      '식당',
      '레스토랑',
      '라멘',
    ],
    ExpenseCategory.souvenir: [
      'souvenir',
      'gift',
      'omiyage',
      '土産',
      'みやげ',
      'おみやげ',
      '纪念品',
      '紀念品',
      '特产',
      '特產',
      '기념품',
      '선물',
    ],
    ExpenseCategory.shopping: [
      'mall',
      'department',
      'duty free',
      'uniqlo',
      'don quijote',
      'donki',
      'drug',
      'pharmacy',
      'outlet',
      'store',
      'market',
      'boutique',
      'ドン・キホーテ',
      '免税',
      '百貨店',
      'ドラッグ',
      '薬局',
      '商场',
      '商場',
      '百货',
      '药妆',
      '면세',
      '백화점',
      '마트',
      '약국',
    ],
    ExpenseCategory.transport: [
      'taxi',
      'metro',
      'railway',
      'subway',
      'train',
      'bus',
      'uber',
      'grab',
      'airport',
      'parking',
      'fuel',
      'gas station',
      'suica',
      'pasmo',
      'ferry',
      'タクシー',
      '駅',
      '鉄道',
      '乗車',
      '出租车',
      '地铁',
      '地鐵',
      '车票',
      '택시',
      '지하철',
      '버스',
      '교통',
    ],
    ExpenseCategory.lodging: [
      'hotel',
      'hostel',
      'inn',
      'resort',
      'airbnb',
      'motel',
      'guest house',
      'ホテル',
      '旅館',
      '宿',
      '酒店',
      '饭店',
      '民宿',
      '호텔',
      '숙박',
      '게스트하우스',
    ],
    ExpenseCategory.sightseeing: [
      'museum',
      'museo',
      'musée',
      'museu',
      'entrada',
      'eintritt',
      'billet',
      'ticket',
      'admission',
      'entrance',
      'tour',
      'zoo',
      'aquarium',
      'park',
      'gallery',
      'tower',
      'castle',
      'temple',
      '入場',
      '入館',
      '美術館',
      '博物館',
      '水族館',
      'チケット',
      '门票',
      '門票',
      '景区',
      '입장',
      '박물관',
      '미술관',
      '투어',
    ],
  };

  static ExpenseCategory? guessCategory(Iterable<String> texts) {
    final joined = texts.join(' ').toLowerCase();
    if (joined.trim().isEmpty) return null;
    ExpenseCategory? best;
    var bestHits = 0;
    for (final e in _categoryWords.entries) {
      final hits = e.value.where((w) => containsWord(joined, w)).length;
      if (hits > bestHits) {
        best = e.key;
        bestHits = hits;
      }
    }
    return best;
  }
}
