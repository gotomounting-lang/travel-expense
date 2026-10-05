import 'package:flutter_test/flutter_test.dart';
import 'package:travel_expense/services/card_history_parser.dart';
import 'package:travel_expense/services/receipt_parser.dart';

List<OcrLine> lines(List<String> texts) => [
  for (var i = 0; i < texts.length; i++)
    OcrLine(texts[i], top: i * 30.0, bottom: i * 30.0 + 20),
];

void main() {
  final now = DateTime(2026, 10, 4, 18);

  test('삼성월렛 이용내역: 여러 건을 날짜·시간과 함께 읽는다', () {
    final drafts = CardHistoryParser(homeCurrency: 'KRW', now: now).parse(
      lines([
        '10월 | 국내(15건)',
        '128',
        'GS25길동오네뜨점 ₩1,700',
        '2026.10.4. 17:46:32',
        '압구정샌드위치 강동사거리점 ₩7,900',
        '2026.10.4. 17:36:14',
        '씨유(CU) 강동오네뜨점 ₩1,600',
        '2026.10.4. 16:44:20',
        '선사짬뽕 ₩34,000',
        '2026.10.3. 18:42:22',
        '네이버파이낸셜 ₩20,228',
        '2026.10.1. 20:33:16',
        '이스턴웰스 결제 ₩1,200',
        '2026.10.1. 14.',
      ]),
    );
    expect(drafts.map((d) => d.amount), [1700, 7900, 1600, 34000, 20228, 1200]);
    expect(drafts.every((d) => d.currency == 'KRW'), isTrue);
    expect(drafts.first.merchant, 'GS25길동오네뜨점');
    expect(drafts.first.date, DateTime(2026, 10, 4, 17, 46));
    expect(drafts[1].merchant, '압구정샌드위치 강동사거리점');
    expect(drafts[2].merchant, '씨유(CU) 강동오네뜨점');
    expect(drafts.last.date, DateTime(2026, 10, 1, 12));
  });

  test('₩ 를 W 로 읽거나 놓쳐도 목록 전체를 원화로 읽는다', () {
    final drafts = CardHistoryParser(homeCurrency: 'KRW', now: now).parse(
      lines([
        'GS25길동오네뜨점 W1,700',
        '2026.10.4. 17:46:32',
        '압구정샌드위치 강동사거리점 W 7,900',
        '2026.10.4. 17:36:14',
        '투썸플레이스 굽은다. ₩5,800',
        '2026.10.4. 11:09:37',
        '씨유(CU) 강동오네뜨점 900',
        '2026.10.3. 19:25:57',
        '선사짬뽕 W34,000',
        '2026.10.3. 18:42:22',
        '가락골마산아구찜 W35,000',
        '2026.10.3. 12:24:34',
        '커피앤 / 삼성웰스토리 W1,800',
        '2026.10.2. 07:38:46',
        '씨유(CU) 강동해오름점 W1,000',
        '2026.10.2. 07:10:41',
        '네이버파이낸셜 W20,228',
        '2026.10.1. 20:33:16',
        'GS25길동오네뜨점 W1,600',
        '2026.10.1. 17:50:09',
        '삼형제김밥 명일점 W5,500',
        '2026.10.1. 17:45:43',
      ]),
    );
    expect(drafts.map((d) => d.amount), [
      1700,
      7900,
      5800,
      900,
      34000,
      35000,
      1800,
      1000,
      20228,
      1600,
      5500,
    ]);
    expect(drafts.every((d) => d.currency == 'KRW'), isTrue);
    expect(drafts[3].merchant, '씨유(CU) 강동오네뜨점');
    expect(drafts[3].date, DateTime(2026, 10, 3, 19, 25));
  });

  test('영문 W 는 한글이 없으면 원화로 바꾸지 않는다', () {
    expect(ReceiptParser.fixWonSign('W 1700'), '₩1700');
    expect(ReceiptParser.fixWonSignIfKorean('ROW 12 W5'), 'ROW 12 W5');
    expect(ReceiptParser.fixWonSign('WWW 3 KW5'), 'WWW 3 KW5');
  });

  test('해외 결제 내역: 원화와 외화가 함께 있으면 원화', () {
    final drafts = CardHistoryParser(homeCurrency: 'KRW', now: now).parse(
      lines([
        'LIDL HU 357 Budapest 31,101원 (7,150HUF)',
        '2026.09.28 22:04',
        'MUSEO DEL PRADO 70,452원 (45.00EUR)',
        '2026.09.27 11:30',
      ]),
    );
    expect(drafts.map((d) => d.amount), [31101, 70452]);
    expect(drafts.map((d) => d.currency), ['KRW', 'KRW']);
    expect(drafts.first.merchant, 'LIDL HU 357 Budapest');
  });

  test('영수증 한 장(날짜 하나)은 목록으로 보지 않는다', () {
    final drafts = CardHistoryParser(homeCurrency: 'KRW', now: now).parse(
      lines([
        'GS25',
        '2026/10/04(일)',
        '신세계)에스코 1 1,700',
        '합계 ₩1,700',
        '사용금액 1,700원',
      ]),
    );
    expect(drafts, isEmpty);
  });
}
