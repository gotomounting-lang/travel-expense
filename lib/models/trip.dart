import '../util/dates.dart';

class Trip {
  const Trip({
    required this.id,
    required this.title,
    required this.currency,
    required this.startDate,
    required this.endDate,
    this.country = '',
  });

  final String id;
  final String title;
  final String country;

  /// 예전 여행에 저장된 여행지 통화. 새 여행은 비워 둔다.
  /// 여러 나라를 도는 여행에는 의미가 없어서 앱은 더 이상 쓰지 않는다
  /// (사용자 결정 2026-10-05). 지출 통화는 영수증 표시로 건마다 정한다.
  final String currency;
  final DateTime startDate;
  final DateTime endDate;

  Trip copyWith({
    String? title,
    String? country,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
  }) => Trip(
    id: id,
    title: title ?? this.title,
    country: country ?? this.country,
    currency: currency ?? this.currency,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'country': country,
    'currency': currency,
    'start_date': formatYmd(startDate),
    'end_date': formatYmd(endDate),
  };

  factory Trip.fromMap(Map<String, Object?> m) => Trip(
    id: m['id'] as String,
    title: m['title'] as String,
    country: (m['country'] as String?) ?? '',
    currency: m['currency'] as String,
    startDate: DateTime.parse(m['start_date'] as String),
    endDate: DateTime.parse(m['end_date'] as String),
  );
}
