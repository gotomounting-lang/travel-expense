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
  });

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

  static final _approved = RegExp(
    r'승인|approved|approval|承認|批准|已消费|消費',
    caseSensitive: false,
  );
  static final _rejected = RegExp(
    r'취소|거절|거부|실패|한도초과|cancel|declin|reject|refund|\(광고\)',
    caseSensitive: false,
  );

  static final _currencyAmount = RegExp(
    r'\b([A-Z]{3})\s?(\d{1,3}(?:,\d{3})+(?:\.\d+)?|\d+(?:\.\d+)?)'
    r'|(\d{1,3}(?:,\d{3})+(?:\.\d+)?|\d+(?:\.\d+)?)\s?([A-Z]{3})\b',
  );

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
    'approved',
    'approval',
    'card',
  ];

  static final _textDate = RegExp(r'(\d{1,2})/(\d{1,2})\s+(\d{1,2}):(\d{2})');

  /// [useTextDate] 가 true 면 (붙여넣은 문구처럼 도착 시각을 모를 때)
  /// 알림 글자 속 "월/일 시:분" 을 결제 시각으로 쓴다.
  CardPayment? parse(CardNotification n, {bool useTextDate = false}) {
    final text = '${n.title}\n${n.text}'.trim();
    if (!_approved.hasMatch(text) || _rejected.hasMatch(text)) return null;

    String? currency;
    double? amount;
    Match? amountMatch;
    for (final m in _currencyAmount.allMatches(text)) {
      final code = m[1] ?? m[4]!;
      if (code == homeCurrency || !_isCurrency(code)) continue;
      final raw = m[2] ?? m[3]!;
      final value = double.tryParse(raw.replaceAll(',', ''));
      if (value == null || value <= 0) continue;
      currency = code;
      amount = value;
      amountMatch = m;
      break;
    }
    if (currency == null || amount == null) return null;

    final merchant = _merchant(text, amountMatch!);
    var spentAt = n.postedAt;
    final d = useTextDate ? _textDate.firstMatch(text) : null;
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
      final name = issuer.endsWith('카드') ? issuer : '$issuer카드';
      for (final m in RegExp(RegExp.escape(issuer)).allMatches(text)) {
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
  String _merchant(String text, Match amountMatch) {
    final lines = text
        .replaceRange(amountMatch.start, amountMatch.end, ' ')
        .split(RegExp(r'[\n|]'));
    final candidates = <String>[];
    for (var line in lines) {
      line = line
          .replaceAll(RegExp(r'\[[^\]]*\]'), ' ')
          .replaceAll(_maskedName, ' ')
          .replaceAll(RegExp(r'[\d,]+\s?원'), ' ')
          .replaceAll(_dateTime, ' ')
          .replaceAll(RegExp(r'\([^)]*\)'), ' ');
      for (final issuer in _issuers) {
        line = line.replaceAll(issuer, ' ');
      }
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
