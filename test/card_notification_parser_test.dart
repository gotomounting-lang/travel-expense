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

  test('외국인 사용자(USD)는 한국에서 쓴 원화 결제를 기록하고 자기 나라 통화 결제는 건너뛴다', () {
    final parser = CardNotificationParser(homeCurrency: 'USD');
    final at = DateTime(2026, 9, 2, 9);
    final krw = parser.parse(
      CardNotification(
        id: '1',
        text: 'Card approved KRW 15,000 OLIVE YOUNG',
        postedAt: at,
      ),
    );
    expect(krw?.currency, 'KRW');
    expect(krw?.amount, 15000);
    expect(
      parser.parse(
        CardNotification(
          id: '2',
          text: 'Card approved USD 12.50 AMAZON',
          postedAt: at,
        ),
      ),
      isNull,
    );
  });

  test('붙여넣은 카드 앱 이용내역(원화 매입금액)을 읽는다', () {
    CardPayment? paste(String text) => parser.parse(
      CardNotification(
        id: 'p',
        text: text,
        postedAt: DateTime(2026, 10, 4, 15),
      ),
      useTextDate: true,
    );
    final p = paste(
      '실적인정금액\n31,528원\n매입금액\n31,528원\n2026. 09. 28(매입)\n해외일시불\n확정',
    )!;
    expect(p.currency, 'KRW');
    expect(p.amount, 31528);
    expect(p.spentAt, DateTime(2026, 9, 28, 12));
    expect(p.merchant, '');

    // 매입금액이 실적인정금액과 다르면 매입금액을 쓴다.
    expect(paste('실적인정금액 30,000원\n매입금액 31,528원\n확정')!.amount, 31528);
    // 자동 알림에서는 여전히 원화(국내) 결제를 건너뛴다.
    expect(parse('매입금액\n31,528원\n확정'), isNull);
    expect(paste('매입 취소 31,528원'), isNull);
  });
}
