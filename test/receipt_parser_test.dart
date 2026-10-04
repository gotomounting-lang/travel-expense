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
