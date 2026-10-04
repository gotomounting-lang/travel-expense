import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/models/category.dart';
import 'package:travel_expense/services/receipt_parser.dart';

/// 줄마다 높이 20 으로 위에서부터 쌓은 OCR 결과를 만든다.
List<OcrLine> lines(List<String> texts) => [
  for (var i = 0; i < texts.length; i++)
    OcrLine(texts[i], top: i * 30.0, bottom: i * 30.0 + 20),
];

void main() {
  group('parseAmount', () {
    test('천 단위·소수 구분자', () {
      expect(ReceiptParser.parseAmount('1,234.56'), 1234.56);
      expect(ReceiptParser.parseAmount('1.234,56'), 1234.56);
      expect(ReceiptParser.parseAmount('12.5'), 12.5);
      expect(ReceiptParser.parseAmount('1,280'), 1280);
      expect(ReceiptParser.parseAmount('1,280', decimals: 0), 1280);
      expect(ReceiptParser.parseAmount('1.280', decimals: 0), 1280);
      expect(ReceiptParser.parseAmount('980.00', decimals: 0), 980);
    });
  });

  test('일본 편의점 영수증', () {
    final draft =
        ReceiptParser(
          tripCurrency: 'JPY',
          tripStart: DateTime(2026, 10, 1),
          tripEnd: DateTime(2026, 10, 5),
        ).parse(
          lines([
            'ローソン 新宿駅前店',
            '電話 03-1234-5678',
            '2026年10月3日(土) 21:14',
            '領収書',
            'おにぎり 鮭 ¥180',
            'カフェラテ ¥220',
            '小計 ¥400',
            '消費税 ¥32',
            '合計 ¥432',
            'お預り ¥1,000',
            'お釣り ¥568',
          ]),
        );
    expect(draft.amount, 432);
    expect(draft.currency, 'JPY');
    expect(draft.date, DateTime(2026, 10, 3, 21, 14));
    expect(draft.merchant, 'ローソン 新宿駅前店');
    expect(draft.category, ExpenseCategory.snack);
    expect(draft.items.map((i) => i.price), [180, 220]);
  });

  test('미국 식당 영수증: 품목과 가격이 다른 줄로 인식돼도 한 행으로 묶는다', () {
    final ocr = [
      const OcrLine('JOE\'S PIZZA', top: 0, bottom: 20, left: 50),
      const OcrLine('10/02/2026 7:45 PM', top: 30, bottom: 50),
      const OcrLine('Pepperoni Slice', top: 60, bottom: 80),
      const OcrLine('4.50', top: 62, bottom: 82, left: 300),
      const OcrLine('Soda', top: 90, bottom: 110),
      const OcrLine('2.25', top: 91, bottom: 111, left: 300),
      const OcrLine('Subtotal 6.75', top: 120, bottom: 140),
      const OcrLine('Tax 0.60', top: 150, bottom: 170),
      const OcrLine('TOTAL', top: 180, bottom: 200),
      const OcrLine('\$7.35', top: 181, bottom: 201, left: 300),
    ];
    final draft = ReceiptParser(tripCurrency: 'USD').parse(ocr);
    expect(draft.amount, 7.35);
    expect(draft.currency, 'USD');
    expect(draft.date, DateTime(2026, 10, 2, 7, 45));
    expect(draft.merchant, "JOE'S PIZZA");
    expect(draft.category, ExpenseCategory.food);
    expect(draft.items.map((i) => '$i'), ['Pepperoni Slice 4.5', 'Soda 2.25']);
  });

  test('유럽 영수증: 쉼표 소수점, 일/월 날짜', () {
    final draft = ReceiptParser(tripCurrency: 'EUR').parse(
      lines([
        'Museo del Prado',
        '05/10/2026 11:02',
        'Entrada general 15,00 €',
        'TOTAL 15,00 €',
      ]),
    );
    expect(draft.amount, 15);
    expect(draft.currency, 'EUR');
    expect(draft.date, DateTime(2026, 10, 5, 11, 2));
    expect(draft.category, ExpenseCategory.sightseeing);
  });

  test('합계 키워드가 없으면 거스름돈 행을 뺀 가장 큰 금액', () {
    final draft = ReceiptParser(tripCurrency: 'THB').parse(
      lines(['Taxi', '2026-10-01', 'Fare 250', 'Cash 500', 'Change 250']),
    );
    expect(draft.amount, 250);
    expect(draft.category, ExpenseCategory.transport);
  });

  test('체코 영수증: Kč, 띄어 쓴 천 단위, Celkem, DPH 표는 합계가 아님', () {
    final draft = ReceiptParser(tripCurrency: 'EUR').parse(
      lines([
        'Pivovar Strahov',
        '25.6.2025 15:04:04 Stůl: 4',
        '1 x Tatarský biftek (345 Kč) 345 Kč',
        '2 x Vepřová žebra (425 Kč) 850 Kč',
        'DPH Základ Daň Celkem',
        '12% 1303,57 156,43 1460',
        '21% 543,80 114,20 658',
        'Celkem 2 118 Kč',
        '88,25 €',
      ]),
    );
    expect(draft.amount, 2118);
    expect(draft.currency, 'CZK');
    expect(draft.date, DateTime(2025, 6, 25, 15, 4));
  });

  test('체코 영수증: TOTAL CZK, 유로 환산 줄이 있어도 코루나', () {
    final draft = ReceiptParser(tripCurrency: 'EUR').parse(
      lines([
        'provozovna Restaurace U Pinkasu',
        '11.07.2019 15:38:02',
        '2.0x Pivo Plzen 12% 0.47L 110.00',
        'CZK 623.00',
        'EUR 24.20',
        'DPH CZK Zaklad Dan Celkem',
        '15% 398.20 59.80 458.00',
        'TOTAL CZK 623.00',
      ]),
    );
    expect(draft.amount, 623);
    expect(draft.currency, 'CZK');
  });

  test('합계 금액이 TOTAL 보다 한 줄 위에 찍힌 영수증', () {
    final draft = ReceiptParser(tripCurrency: 'GBP').parse(
      lines([
        'Location: Edinburgh, Scotland',
        '2026-02-05 17:35:07',
        'Claude Opus 4.5 \$10.07',
        'Output tokens 3,811',
        'Claude Sonnet 4.5 \$0.58',
        '\$10.65',
        'TOTAL',
        '==========',
        'CASHIER: Claude Opus 4.5',
      ]),
    );
    expect(draft.amount, 10.65);
    expect(draft.currency, 'USD');
  });

  test('TOTAL 아래 구분선이 인식되지 않아도 아랫줄 글자 속 숫자는 합계가 아니다', () {
    final draft = ReceiptParser(tripCurrency: 'GBP').parse(
      lines([
        'Claude Opus 4.5 \$10.07',
        'Cache read 9,971,315',
        '\$10.65',
        'TOTAL',
        'CASHIER: Claude Opus 4.5',
        'Thank you for building!',
      ]),
    );
    expect(draft.amount, 10.65);
  });

  group('나라별 합계 단어와 현지 통화', () {
    double? total(String trip, List<String> rows) =>
        ReceiptParser(tripCurrency: trip).parse(lines(rows)).amount;

    test('한국: 판매총액·총합계·결재금액·승인금액, 할인·부가세·받은금액은 아님', () {
      for (final word in ['판매총액', '총합계', '결재금액', '승인금액', '청구금액']) {
        expect(
          total('KRW', [
            '아메리카노 4,500',
            '케이크 7,000',
            '할인 -1,000',
            '부가세 950',
            '$word 10,500',
            '받은금액 20,000',
          ]),
          10500,
          reason: word,
        );
      }
    });

    test('일본 合計, 독일 Summe, 태국 รวมทั้งสิ้น, 러시아 Итого', () {
      expect(
        total('JPY', ['おにぎり 150', '小計 1,180', '合計 ¥1,298', 'お預り 2,000']),
        1298,
      );
      expect(
        total('EUR', [
          'Brezel 2,50',
          'MwSt 0,57',
          'Summe EUR 8,40',
          'Gegeben 10,00',
        ]),
        8.4,
      );
      expect(
        total('THB', ['Pad Thai 120', 'รวมทั้งสิ้น 240', 'เงินทอน 60']),
        240,
      );
      expect(total('RUB', ['Кофе 250', 'Итого 520', 'Сдача 480']), 520);
    });

    test('통화 표시가 없으면 여행지(현지) 통화, 합계 줄의 통화를 우선', () {
      final local = ReceiptParser(tripCurrency: 'VND')
          .parse(lines(['Phở bò 65.000', 'Tổng cộng 130.000']));
      expect(local.currency, 'VND');
      expect(local.amount, 130000);
      // "TERMINAL" 의 RM 을 말레이시아 링깃으로 보지 않는다.
      final terminal = ReceiptParser(tripCurrency: 'GBP')
          .parse(lines(['TERMINAL 0042', 'TOTAL 12.50']));
      expect(terminal.currency, 'GBP');
    });
  });

  test('글자가 없으면 빈 결과', () {
    final draft = ReceiptParser(tripCurrency: 'USD').parse([]);
    expect(draft.isEmpty, isTrue);
  });

  test('영문 키워드는 단어 단위로 찾는다', () {
    expect(ReceiptParser.containsWord('steak house', 'tea'), isFalse);
    expect(ReceiptParser.containsWord('taxi fare', 'tax'), isFalse);
    expect(ReceiptParser.containsWord('hotel', 'tel'), isFalse);
    expect(ReceiptParser.containsWord('green tea', 'tea'), isTrue);
    expect(ReceiptParser.containsWord('お土産', '土産'), isTrue);
  });
}
