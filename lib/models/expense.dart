import '../l10n/app_localizations.dart';
import 'category.dart';
import 'currency.dart';

/// 지출 내역이 어디서 들어왔는지. 2·3단계에서 영수증/카드 알림이 추가된다.
enum ExpenseSource {
  manual('manual'),
  receipt('receipt'),
  cardNotification('card');

  const ExpenseSource(this.id);

  final String id;

  String label(AppLocalizations l) => switch (this) {
    manual => l.sourceManual,
    receipt => l.sourceReceipt,
    cardNotification => l.sourceCard,
  };

  static ExpenseSource fromId(String id) => ExpenseSource.values.firstWhere(
    (s) => s.id == id,
    orElse: () => ExpenseSource.manual,
  );
}

class Expense {
  const Expense({
    required this.id,
    required this.tripId,
    required this.spentAt,
    required this.category,
    required this.currency,
    required this.amount,
    this.merchant = '',
    this.paymentMethod = '',
    this.memo = '',
    this.source = ExpenseSource.manual,
    this.homeCurrency = 'KRW',
    this.homeRate,
    this.rateDate,
    this.rateSource,
  });

  final String id;
  final String tripId;

  /// 현지 결제 일시 (여행지 기기 시간 기준).
  final DateTime spentAt;
  final ExpenseCategory category;
  final String currency;
  final double amount;
  final String merchant;
  final String paymentMethod;
  final String memo;
  final ExpenseSource source;

  /// 환산 통화 (사용자 국적의 통화). 국적을 바꾸면 다시 환산한다.
  final String homeCurrency;

  /// 1 [currency] 당 [homeCurrency]. 오프라인 등으로 아직 조회하지 못했으면 null.
  final double? homeRate;

  /// 실제로 적용된 환율의 기준일 (주말·공휴일이면 직전 영업일).
  final DateTime? rateDate;
  final String? rateSource;

  bool get hasRate => homeRate != null;

  /// 환산 금액 ([homeCurrency] 소수 자릿수로 반올림). 환율이 없으면 null.
  double? get homeAmount => homeRate == null
      ? null
      : roundTo(amount * homeRate!, Currency.byCode(homeCurrency).decimals);

  static double roundTo(double v, int decimals) {
    final f = decimals == 0 ? 1 : (decimals == 1 ? 10 : 100);
    return (v * f).round() / f;
  }

  Expense copyWith({
    DateTime? spentAt,
    ExpenseCategory? category,
    String? currency,
    double? amount,
    String? merchant,
    String? paymentMethod,
    String? memo,
    String? homeCurrency,
    double? homeRate,
    DateTime? rateDate,
    String? rateSource,
    bool clearRate = false,
  }) => Expense(
    id: id,
    tripId: tripId,
    spentAt: spentAt ?? this.spentAt,
    category: category ?? this.category,
    currency: currency ?? this.currency,
    amount: amount ?? this.amount,
    merchant: merchant ?? this.merchant,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    memo: memo ?? this.memo,
    source: source,
    homeCurrency: homeCurrency ?? this.homeCurrency,
    homeRate: clearRate ? null : (homeRate ?? this.homeRate),
    rateDate: clearRate ? null : (rateDate ?? this.rateDate),
    rateSource: clearRate ? null : (rateSource ?? this.rateSource),
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'trip_id': tripId,
    'spent_at': spentAt.toIso8601String(),
    'category': category.id,
    'currency': currency,
    'amount': amount,
    'merchant': merchant,
    'payment_method': paymentMethod,
    'memo': memo,
    'source': source.id,
    'home_currency': homeCurrency,
    // 1.0 때는 원화만 있어서 열 이름이 krw_rate 다. 지금은 homeCurrency 기준 환율.
    'krw_rate': homeRate,
    'rate_date': rateDate?.toIso8601String(),
    'rate_source': rateSource,
  };

  factory Expense.fromMap(Map<String, Object?> m) => Expense(
    id: m['id'] as String,
    tripId: m['trip_id'] as String,
    spentAt: DateTime.parse(m['spent_at'] as String),
    category: ExpenseCategory.fromId(m['category'] as String),
    currency: m['currency'] as String,
    amount: (m['amount'] as num).toDouble(),
    merchant: (m['merchant'] as String?) ?? '',
    paymentMethod: (m['payment_method'] as String?) ?? '',
    memo: (m['memo'] as String?) ?? '',
    source: ExpenseSource.fromId((m['source'] as String?) ?? 'manual'),
    homeCurrency: (m['home_currency'] as String?) ?? 'KRW',
    homeRate: (m['krw_rate'] as num?)?.toDouble(),
    rateDate: m['rate_date'] == null
        ? null
        : DateTime.parse(m['rate_date'] as String),
    rateSource: m['rate_source'] as String?,
  );
}
