import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/services/card_notification_parser.dart';

void main() {
  final at = DateTime(2026, 10, 3, 14, 22);
  final parser = CardNotificationParser();

  CardPayment? parse(String text, {String title = ''}) => parser.parse(
    CardNotification(id: 'x', title: title, text: text, postedAt: at),
  );

  test('신한카드 해외승인 (한 줄)', () {
    final p = parse(
      '신한카드(1234)승인 홍*동 12.50USD(US) 10/03 14:22 STARBUCKS COFFEE 누적1,234,000원',
    )!;
    expect(p.currency, 'USD');
    expect(p.amount, 12.5);
    expect(p.merchant, 'STARBUCKS COFFEE');
    expect(p.card, '신한카드(1234)');
    expect(p.spentAt, at, reason: '알림이 도착한 기기 시각을 쓴다');
    expect(p.category, ExpenseCategory.snack);
  });

  test('KB국민카드 여러 줄 + 천 단위 엔화', () {
    final p = parse(
      'KB국민카드1234승인\n홍*동님\nJPY 1,280 해외\n10/03 14:22\nICHIRAN SHIBUYA',
    )!;
    expect(p.currency, 'JPY');
    expect(p.amount, 1280);
    expect(p.merchant, 'ICHIRAN SHIBUYA');
    expect(p.card, 'KB국민카드(1234)');
  });

  test('카카오톡 알림톡: 제목이 카드사 이름', () {
    final p = parse(
      '[Web발신]\n삼성1234승인 홍*동\nEUR 45.00 해외\n10/03 14:22 MUSEO DEL PRADO',
      title: '삼성카드',
    )!;
    expect(p.currency, 'EUR');
    expect(p.amount, 45);
    expect(p.merchant, 'MUSEO DEL PRADO');
    expect(p.card, '삼성카드(1234)');
    expect(p.category, ExpenseCategory.sightseeing);
  });

  test('취소·거절·원화 결제·광고는 기록하지 않는다', () {
    expect(parse('신한카드(1234)승인취소 홍*동 12.50USD STARBUCKS'), isNull);
    expect(parse('현대카드 승인거절 USD 99.00 한도초과'), isNull);
    expect(parse('하나1*2*승인 홍*동 12,000원 일시불 10/03 14:22 GS25'), isNull);
    expect(parse('(광고) 해외결제 승인 시 USD 10 캐시백!'), isNull);
    expect(parse('오늘 저녁 뭐 먹어?'), isNull);
  });

  test('붙여넣은 문구는 글자 속 날짜·시간을 쓴다', () {
    final p = parser.parse(
      CardNotification(
        id: 'p',
        text: '현대카드 승인 홍*동 THB 450.00 해외 10/01 19:30 GRAB TAXI',
        postedAt: DateTime(2026, 10, 4, 8),
      ),
      useTextDate: true,
    )!;
    expect(p.spentAt, DateTime(2026, 10, 1, 19, 30));
    expect(p.merchant, 'GRAB TAXI');
    expect(p.category, ExpenseCategory.transport);
  });
}
