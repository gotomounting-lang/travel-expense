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

  test('원화와 외화가 함께 있으면 실제 청구된 원화를 쓴다', () {
    final p = parse(
      '[Web발신] 우리카드 승인 홍*동 31,101원 (7,150HUF) 일시불 LIDL HU 357 Budapest HUN 누적 474,478원',
    )!;
    expect(p.currency, 'KRW');
    expect(p.amount, 31101);
    expect(p.merchant, contains('LIDL'));
  });

  test('붙여넣은 우리WON 이용내역: 원화 우선, 외화만 있으면 외화', () {
    CardPayment? paste(String text) => parser.parse(
      CardNotification(id: 'p', text: text, postedAt: DateTime(2026, 9, 23)),
      useTextDate: true,
    );
    final both = paste(
      '17:27 | 본인 | 일시불\nZDRAVI S CHUTI BRNO CZE\n6,423원\n(97.9CZK)',
    )!;
    expect(both.currency, 'KRW');
    expect(both.amount, 6423);
    expect(both.merchant, 'ZDRAVI S CHUTI BRNO CZE');

    final foreignOnly = paste(
      '17:21 일시불\nLidl dekuje za nakup Brno CZE\n156.7CZK',
    )!;
    expect(foreignOnly.currency, 'CZK');
    expect(foreignOnly.amount, 156.7);
  });

  group('언어별 카드사·은행 알림 (해외 결제)', () {
    final at = DateTime(2026, 10, 3, 14, 22);
    CardPayment? read(String home, String text) =>
        CardNotificationParser(homeCurrency: home)
            .parse(CardNotification(id: 'x', text: text, postedAt: at));

    final cases = <(String, String, String, String, double)>[
      // (언어, 내 나라 통화, 알림, 기대 통화, 기대 금액)
      (
        '영어 (미국)',
        'USD',
        'Chase: You made a purchase of EUR 45.00 at MUSEO DEL PRADO',
        'EUR',
        45,
      ),
      ('일본어', 'JPY', '【楽天カード】ご利用のお知らせ ご利用金額 USD 12.50 STARBUCKS', 'USD', 12.5),
      ('중국어', 'CNY', '招商银行 您尾号1234信用卡消费 JPY 1,280 ICHIRAN', 'JPY', 1280),
      (
        '베트남어',
        'VND',
        'Vietcombank: GD -45,00 EUR tai MUSEO DEL PRADO. So du 12.500.000VND',
        'EUR',
        45,
      ),
      (
        '러시아어',
        'RUB',
        'Сбер: Покупка 12,50 EUR MUSEO DEL PRADO. Баланс: 54 321 ₽',
        'EUR',
        12.5,
      ),
      (
        '독일어',
        'EUR',
        'Sparkasse: Kartenzahlung 1.280 JPY bei ICHIRAN',
        'JPY',
        1280,
      ),
      (
        '몽골어',
        'MNT',
        'Хаан банк: Гүйлгээ 45.00 USD STARBUCKS. Үлдэгдэл 1,250,000₮',
        'USD',
        45,
      ),
      (
        '프랑스어',
        'EUR',
        'Paiement par carte de 12,50 USD chez STARBUCKS',
        'USD',
        12.5,
      ),
      ('미얀마어', 'MMK', 'KBZ ငွေပေးချေမှု THB 450.00 GRAB TAXI', 'THB', 450),
      (
        '타갈로그어',
        'PHP',
        'BDO: Nagbayad ka ng KRW 15,000 sa OLIVE YOUNG',
        'KRW',
        15000,
      ),
      (
        '인도네시아어',
        'IDR',
        'BCA: Transaksi kartu SGD 25.50 di JEWEL CHANGI. Saldo Rp 5.000.000',
        'SGD',
        25.5,
      ),
      (
        '말레이어',
        'MYR',
        'Maybank: Transaksi kad anda THB 450.00 di GRAB',
        'THB',
        450,
      ),
      (
        '힌디어 (인도)',
        'INR',
        'HDFC Bank: INR 0 - Txn of USD 45.00 on card xx1234 at STARBUCKS. Avl Bal INR 50,000',
        'USD',
        45,
      ),
    ];
    for (final (lang, home, text, currency, amount) in cases) {
      test(lang, () {
        final p = read(home, text);
        expect(p, isNotNull, reason: text);
        expect(p!.currency, currency, reason: text);
        expect(p.amount, amount, reason: text);
      });
    }

    test('취소·환불 알림은 언어와 관계없이 기록하지 않는다', () {
      expect(read('JPY', 'ご利用取消 USD 12.50 STARBUCKS'), isNull);
      expect(read('VND', 'Giao dịch hoàn tiền 45,00 EUR'), isNull);
      expect(read('RUB', 'Отмена покупки 12,50 EUR'), isNull);
      expect(read('EUR', 'Zahlung storniert 12,50 USD'), isNull);
      expect(read('IDR', 'Transaksi dibatalkan SGD 25.50'), isNull);
    });

    test('자기 나라 통화만 있는 결제는 국내 결제로 건너뛴다', () {
      expect(read('VND', 'Vietcombank: GD -150.000VND tai HIGHLANDS'), isNull);
      expect(read('JPY', 'ご利用金額 1,280円 ローソン'), isNull);
    });

    test('내 나라 통화와 외화가 함께 있으면 내 나라 통화 (청구액)', () {
      final vi = read(
        'VND',
        'Thanh toán 1.250.000₫ (45,00 EUR) MUSEO DEL PRADO',
      );
      expect(vi?.currency, 'VND');
      expect(vi?.amount, 1250000);
      final ja = read('JPY', 'ご利用金額 7,320円 (45.00 EUR) MUSEO DEL PRADO');
      expect(ja?.currency, 'JPY');
      expect(ja?.amount, 7320);
      final de = read('EUR', 'Kartenzahlung 8,75 € (1.280 JPY) ICHIRAN');
      expect(de?.currency, 'EUR');
      expect(de?.amount, 8.75);
    });
  });
}
