import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../models/trip.dart';
import 'receipt_parser.dart';

enum ReceiptImageSource { camera, gallery }

/// 영수증 사진을 받아 기기 안에서 OCR 하고, 분석이 끝나면 사진 파일을 지운다.
///
/// 사진과 글자는 기기 밖으로 나가지 않는다 (Google ML Kit 기기 내 모델).
/// 카메라로 찍은 사진은 앨범에 저장되지 않고 앱 임시 폴더에만 잠깐 있다가
/// 분석 직후 삭제된다. 앨범에서 고른 경우 앱이 받은 사본만 지우고
/// 사용자 앨범의 원본은 건드리지 않는다.
class ReceiptScanner {
  ReceiptScanner({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// 사진을 고르지 않고 취소하면 null. [onAnalyzing] 은 사진을 받고
  /// 분석을 시작할 때 한 번 불린다 (진행 표시용).
  Future<ReceiptDraft?> scan(
    Trip trip,
    ReceiptImageSource source, {
    VoidCallback? onAnalyzing,
  }) async {
    final photo = await _picker.pickImage(
      source: source == ReceiptImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      // 크기 조절 옵션을 쓰면 플러그인이 사본을 하나 더 만들기 때문에,
      // 지울 파일이 하나만 남도록 원본 그대로 받는다.
      requestFullMetadata: false,
    );
    if (photo == null) return null;
    onAnalyzing?.call();

    try {
      final image = InputImage.fromFilePath(photo.path);
      final parser = ReceiptParser(
        tripCurrency: trip.currency,
        tripStart: trip.startDate,
        tripEnd: trip.endDate,
      );
      // 여행지 글자 모델로 먼저 읽고, 합계 단어를 못 찾으면 다른 글자 모델로
      // 다시 읽는다 (예: 미국 여행 중 받은 한국어 영수증).
      ReceiptDraft? first;
      for (final script in scriptsFor(trip.currency)) {
        final draft = parser.parse(await _read(image, script));
        if (draft.totalByWord) return draft;
        first ??= draft;
      }
      return first;
    } finally {
      await _deletePhoto(photo.path);
    }
  }

  Future<List<OcrLine>> _read(
    InputImage image,
    TextRecognitionScript script,
  ) async {
    final recognizer = TextRecognizer(script: script);
    try {
      final text = await recognizer.processImage(image);
      return [
        for (final block in text.blocks)
          for (final line in block.lines)
            OcrLine(
              line.text,
              top: line.boundingBox.top,
              bottom: line.boundingBox.bottom,
              left: line.boundingBox.left,
            ),
      ];
    } finally {
      await recognizer.close();
    }
  }

  /// 시도할 글자 모델 순서: 여행지 글자 먼저, 그다음 한국어·일본어·중국어·영문.
  static List<TextRecognitionScript> scriptsFor(String currency) => {
    scriptFor(currency),
    TextRecognitionScript.korean,
    TextRecognitionScript.japanese,
    TextRecognitionScript.chinese,
    TextRecognitionScript.latin,
  }.toList();

  /// 여행지 통화로 영수증 글자 종류를 고른다. 한·중·일 모델도 영문·숫자를 읽는다.
  static TextRecognitionScript scriptFor(String currency) => switch (currency) {
    'JPY' => TextRecognitionScript.japanese,
    'CNY' || 'TWD' || 'HKD' || 'MOP' => TextRecognitionScript.chinese,
    'KRW' => TextRecognitionScript.korean,
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
