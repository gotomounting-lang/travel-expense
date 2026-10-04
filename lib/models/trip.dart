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

  /// 여행지 기본 통화. 새 지출 입력 시 기본값으로 쓴다.
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
