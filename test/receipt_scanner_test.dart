import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/services/receipt_parser.dart';
import 'package:travel_expense/services/receipt_scanner.dart';

void main() {
  final now = DateTime(2026, 10, 4, 18);
  ReceiptDraft read(String text, {String trip = 'USD'}) {
    final lines = text.split('\n');
    final draft = ReceiptParser(tripCurrency: trip).parse([
      for (var i = 0; i < lines.length; i++)
        OcrLine(lines[i], top: i * 30.0, bottom: i * 30.0 + 20),
    ]);
    return ReceiptScanner.withCardHistory(draft, text, 'KRW', now: now);
  }

  test('카드 앱 이용내역 사진: 원화와 외화가 함께 있으면 원화', () {
    final d = read(
      // ML Kit 은 글자 덩어리(가맹점, 금액)별로 줄을 내준다.
      '22:04 | 본인 | 일시불\n'
      'LIDL HU 357 Budapest Budape\n'
      'st HUN\n'
      '31,101원\n'
      '(7,150HUF)',
    );
    expect(d.amount, 31101);
    expect(d.currency, 'KRW');
    expect(d.merchant, contains('LIDL'));
  });

  test('같은 줄로 읽혀도 원화', () {
    final d = read('LIDL HU 357 Budapest 31,101원 (7,150HUF)');
    expect(d.amount, 31101);
    expect(d.currency, 'KRW');
  });

  test('외화만 있으면 외화', () {
    final d = read('LIDL HU 357 Budapest\n7,150 HUF', trip: 'HUF');
    expect(d.amount, 7150);
    expect(d.currency, 'HUF');
  });

  test('합계를 읽은 일반 영수증은 그대로', () {
    final d = read('CAFE\nLatte 4.50\nTOTAL \$10.65', trip: 'USD');
    expect(d.amount, 10.65);
    expect(d.currency, 'USD');
  });
}
