import 'card_notification_parser.dart';
import 'receipt_parser.dart';

/// 카드 앱 이용내역 화면을 찍은 사진·스크린샷에서 결제 여러 건을 읽는다.
///
/// 한 건은 "가맹점 ₩1,700" 처럼 통화가 붙은 금액이 있는 줄에서 시작해
/// 다음 금액 줄 앞까지다 (그 사이의 "2026.10.4. 17:46:32" 같은 날짜 줄 포함).
/// 금액·날짜·원화/외화 규칙은 카드 알림과 같다.
class CardHistoryParser {
  CardHistoryParser({required this.homeCurrency, DateTime? now})
    : now = now ?? DateTime.now();

  final String homeCurrency;
  final DateTime now;

  /// 날짜가 있는 결제 건이 2건 이상일 때만 이용내역 목록으로 본다.
  /// (영수증 한 장에는 보통 통화가 붙은 금액 줄이 여럿이어도 날짜는 하나다.)
  List<ReceiptDraft> parse(List<OcrLine> lines) {
    final rows = ReceiptParser.groupRows(lines);
    final anchors = [
      for (var i = 0; i < rows.length; i++)
        if (CardNotificationParser.hasMarkedAmount(rows[i])) i,
    ];
    final parser = CardNotificationParser(homeCurrency: homeCurrency);
    final out = <ReceiptDraft>[];
    var dated = 0;
    for (var k = 0; k < anchors.length; k++) {
      final start = anchors[k];
      final end = k + 1 < anchors.length ? anchors[k + 1] : rows.length;
      // 금액 줄과 그 아래 줄 몇 개 (다음 건 앞까지).
      final chunk = rows.sublist(start, end.clamp(start + 1, start + 3));
      final text = chunk.join('\n');
      final payment = parser.parse(
        CardNotification(id: 'list', text: text, postedAt: now),
        useTextDate: true,
        listItem: true,
      );
      if (payment == null) continue;
      final hasDate = CardNotificationParser.isDateRow(text);
      if (hasDate) dated++;
      out.add(
        ReceiptDraft(
          amount: payment.amount,
          currency: payment.currency,
          date: hasDate ? payment.spentAt : null,
          merchant: _merchant(rows, start) ?? payment.merchant,
          category: payment.category,
          paymentMethod: payment.card,
          totalByWord: true,
        ),
      );
    }
    return dated >= 2 ? out : const [];
  }

  /// 금액 줄에서 금액을 뺀 글자, 없으면 바로 위 줄 (날짜·금액 줄이 아니면).
  String? _merchant(List<String> rows, int anchor) {
    final letters = RegExp(r'\p{L}{2,}', unicode: true);
    final own = CardNotificationParser.withoutAmounts(rows[anchor]);
    if (letters.hasMatch(own)) return _cut(own);
    if (anchor > 0) {
      final above = rows[anchor - 1];
      if (!CardNotificationParser.isDateRow(above) &&
          !CardNotificationParser.hasMarkedAmount(above) &&
          letters.hasMatch(above)) {
        return _cut(above.trim());
      }
    }
    return null;
  }

  static String _cut(String s) => s.length > 40 ? s.substring(0, 40) : s;
}
