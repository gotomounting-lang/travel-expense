import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../models/trip.dart';
import 'card_history_parser.dart';
import 'card_notification_parser.dart';
import 'receipt_parser.dart';

enum ReceiptImageSource { camera, gallery }

/// 사진 분석 결과: 읽은 결제 건들과 결제 건을 하나도 읽지 못한 사진 수.
class ScanResult {
  const ScanResult({
    required this.drafts,
    required this.unreadable,
    required this.photoCount,
    this.firstFailed,
  });

  final List<ReceiptDraft> drafts;
  final int unreadable;
  final int photoCount;

  /// 읽지 못한 사진에서 그나마 읽은 날짜·가맹점 (직접 입력 화면에 채운다).
  final ReceiptDraft? firstFailed;
}

/// 영수증 사진을 받아 기기 안에서 OCR 하고, 분석이 끝나면 사진 파일을 지운다.
///
/// 사진과 글자는 기기 밖으로 나가지 않는다 (Google ML Kit 기기 내 모델).
/// 카메라로 찍은 사진은 앨범에 저장되지 않고 앱 임시 폴더에만 잠깐 있다가
/// 분석 직후 삭제된다. 앨범에서 고른 경우 앱이 받은 사본만 지우고
/// 사용자 앨범의 원본은 건드리지 않는다.
class ReceiptScanner {
  ReceiptScanner({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 사진(앨범에서는 여러 장)을 받아 결제 건을 읽는다. 사진을 고르지 않고
  /// 취소하면 null. [onAnalyzing] 은 사진을 받고 분석을 시작할 때 한 번
  /// 불린다 (진행 표시용). 분석이 끝난 사진은 바로 지운다.
  Future<ScanResult?> scan(
    Trip trip,
    ReceiptImageSource source, {
    VoidCallback? onAnalyzing,
    String? homeCurrency,
  }) async {
    // 크기 조절 옵션을 쓰면 플러그인이 사본을 하나 더 만들기 때문에,
    // 지울 파일이 하나만 남도록 원본 그대로 받는다.
    final photos = source == ReceiptImageSource.camera
        ? [
            ?await _picker.pickImage(
              source: ImageSource.camera,
              requestFullMetadata: false,
            ),
          ]
        : await _picker.pickMultiImage(requestFullMetadata: false);
    if (photos.isEmpty) return null;
    onAnalyzing?.call();

    final drafts = <ReceiptDraft>[];
    var unreadable = 0;
    ReceiptDraft? firstFailed;
    for (final photo in photos) {
      try {
        final (list, single) = await _analyze(photo.path, trip, homeCurrency);
        if (list.isNotEmpty) {
          drafts.addAll(list);
        } else if (single.amount != null) {
          drafts.add(single);
        } else {
          unreadable++;
          firstFailed ??= single;
        }
      } finally {
        await _deletePhoto(photo.path);
      }
    }
    return ScanResult(
      drafts: drafts,
      unreadable: unreadable,
      photoCount: photos.length,
      firstFailed: firstFailed,
    );
  }

  /// 사진 한 장: 카드 이용내역 목록(여러 건)이면 그 목록, 아니면 영수증 한 건.
  Future<(List<ReceiptDraft>, ReceiptDraft)> _analyze(
    String path,
    Trip trip,
    String? homeCurrency,
  ) async {
    final image = InputImage.fromFilePath(path);
    final parser = ReceiptParser(
      tripCurrency: trip.currency,
      tripStart: trip.startDate,
      tripEnd: trip.endDate,
    );
    final homeScript = homeCurrency == null ? null : scriptFor(homeCurrency);
    // 여행지 글자 모델로 먼저 읽고, 합계와 통화를 둘 다 확인하지 못하면
    // 사용자 나라 글자, 그다음 다른 글자 모델로 다시 읽어 가장 잘 읽힌 결과를
    // 쓴다 (예: 미국 여행 중 받은 한국 카드전표).
    // 카드 이용내역 목록은 사용자 카드 앱 화면이라 사용자 나라 글자 모델로도
    // 읽어 보고, 더 많이 읽힌 쪽(같으면 사용자 나라 글자)을 쓴다.
    var bestList = <ReceiptDraft>[];
    ReceiptDraft? best;
    var bestScore = -1;
    var bestConfidence = -1.0;
    final scripts = scriptsFor(trip.currency, homeCurrency);
    for (var i = 0; i < scripts.length; i++) {
      final script = scripts[i];
      final lines = await _read(image, script);
      if (homeCurrency != null) {
        final list = CardHistoryParser(homeCurrency: homeCurrency).parse(lines);
        if (list.length > bestList.length ||
            (list.isNotEmpty &&
                list.length == bestList.length &&
                script == homeScript)) {
          bestList = list;
        }
      }
      final draft = withCardHistory(
        parser.parse(lines),
        ReceiptParser.fixWonSignIfKorean(_lastText),
        homeCurrency,
      );
      final score = scoreOf(draft);
      // 점수가 같으면 글자 모델이 더 확신한 쪽 (예: 한글 영수증을 중국어
      // 모델이 "元"으로 잘못 읽은 결과보다 한국어 모델 결과).
      final confidence = confidenceOf(lines);
      if (score > bestScore ||
          (score == bestScore && confidence > bestConfidence)) {
        best = draft;
        bestScore = score;
        bestConfidence = confidence;
      }
      final homeDone = homeScript == null || scripts.indexOf(homeScript) <= i;
      if (bestList.isNotEmpty && homeDone) break;
      if (bestList.isEmpty && score >= 3) break;
    }
    return (bestList, best!);
  }

  Future<List<OcrLine>> _read(
    InputImage image,
    TextRecognitionScript script,
  ) async {
    final recognizer = TextRecognizer(script: script);
    try {
      final text = await recognizer.processImage(image);
      _lastText = text.text;
      return [
        for (final block in text.blocks)
          for (final line in block.lines)
            OcrLine(
              line.text,
              top: line.boundingBox.top,
              bottom: line.boundingBox.bottom,
              left: line.boundingBox.left,
              confidence: line.confidence,
            ),
      ];
    } finally {
      await recognizer.close();
    }
  }

  String _lastText = '';

  /// 카드 앱 이용내역을 찍은 사진 ("31,101원 (7,150HUF)") 이면 카드 알림과 같은
  /// 규칙으로 읽는다: 내 나라 통화와 외화가 함께 있으면 내 나라 통화(실제 청구액),
  /// 외화만 있고 영수증 합계를 못 찾았으면 외화.
  static ReceiptDraft withCardHistory(
    ReceiptDraft receipt,
    String text,
    String? homeCurrency, {
    DateTime? now,
  }) {
    if (homeCurrency == null || text.trim().isEmpty) return receipt;
    final card = CardNotificationParser(homeCurrency: homeCurrency).parse(
      CardNotification(id: 'ocr', text: text, postedAt: now ?? DateTime.now()),
      useTextDate: true,
    );
    if (card == null || !card.withForeign) return receipt;
    final paired = card.currency == homeCurrency;
    if (!paired && receipt.totalByWord && receipt.amount != null) {
      return receipt;
    }
    return ReceiptDraft(
      amount: card.amount,
      currency: card.currency,
      date: receipt.date ?? card.spentAt,
      merchant: card.merchant.isNotEmpty ? card.merchant : receipt.merchant,
      category: card.category ?? receipt.category,
      paymentMethod: card.card,
      totalByWord: true,
    );
  }

  /// 합계 단어 줄의 금액(2점)과 통화 표시(1점)를 읽었는지.
  static int scoreOf(ReceiptDraft d) =>
      (d.totalByWord && d.amount != null ? 2 : 0) +
      (d.currency != null ? 1 : 0);

  /// 줄 길이로 가중한 글자 모델의 평균 확신도. 확신도가 없으면(iOS) 0.
  static double confidenceOf(List<OcrLine> lines) {
    var sum = 0.0;
    var chars = 0;
    for (final line in lines) {
      final n = line.text.trim().length;
      sum += (line.confidence ?? 0) * n;
      chars += n;
    }
    return chars == 0 ? 0 : sum / chars;
  }

  /// 시도할 글자 모델 순서: 한국어(영문·숫자도 읽는다)를 먼저, 그다음 여행지
  /// 글자, 사용자 나라 글자, 일본어, 영문. 중국어 모델은 한글을 한자로 잘못
  /// 읽으므로 맨 마지막이다 (사용자 결정 2026-10-04).
  static List<TextRecognitionScript> scriptsFor(
    String currency, [
    String? homeCurrency,
  ]) {
    const chinese = TextRecognitionScript.chinese;
    return {
      TextRecognitionScript.korean,
      scriptFor(currency),
      if (homeCurrency != null) scriptFor(homeCurrency),
      TextRecognitionScript.japanese,
      TextRecognitionScript.latin,
    }.where((s) => s != chinese).followedBy([chinese]).toList();
  }

  /// 여행지 통화로 영수증 글자 종류를 고른다. 한·중·일 모델도 영문·숫자를 읽는다.
  static TextRecognitionScript scriptFor(String currency) => switch (currency) {
    'JPY' => TextRecognitionScript.japanese,
    'CNY' || 'TWD' || 'HKD' || 'MOP' => TextRecognitionScript.chinese,
    'KRW' => TextRecognitionScript.korean,
    'INR' || 'NPR' => TextRecognitionScript.devanagiri,
    _ => TextRecognitionScript.latin,
  };

  Future<void> _deletePhoto(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('receipt photo delete failed: $e');
    }
  }
}
