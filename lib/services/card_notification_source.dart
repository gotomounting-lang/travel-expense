import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'card_notification_parser.dart';

/// 안드로이드 알림 리스너가 모아 둔 카드 결제 알림을 가져온다.
///
/// iOS 는 다른 앱의 알림을 읽을 수 없어서 [isSupported] 가 false 이고,
/// 모든 호출이 아무것도 하지 않는다.
class CardNotificationSource {
  CardNotificationSource({bool? supported})
    : isSupported = supported ?? Platform.isAndroid;

  final bool isSupported;

  static const _methods = MethodChannel('travel_expense/card_notifications');
  static const _events = EventChannel(
    'travel_expense/card_notifications/events',
  );

  /// 사용자가 시스템 설정에서 알림 접근을 허용했는지.
  Future<bool> isEnabled() async {
    if (!isSupported) return false;
    return await _methods.invokeMethod<bool>('isEnabled') ?? false;
  }

  /// 알림 접근 허용 화면을 연다.
  Future<void> openSettings() async {
    if (!isSupported) return;
    await _methods.invokeMethod<void>('openSettings');
  }

  /// 아직 기록하지 않은 알림.
  Future<List<CardNotification>> pending() async {
    if (!isSupported) return const [];
    final raw = await _methods.invokeListMethod<Map<Object?, Object?>>(
      'pending',
    );
    return [for (final m in raw ?? const []) CardNotification.fromMap(m)];
  }

  /// 기록했거나 쓸모없는 알림을 기기 보관함에서 지운다.
  Future<void> remove(Iterable<String> ids) async {
    if (!isSupported || ids.isEmpty) return;
    await _methods.invokeMethod<void>('remove', {'ids': ids.toList()});
  }

  /// 앱이 켜져 있는 동안 새 알림이 들어오면 신호를 보낸다.
  Stream<void> get onNew => isSupported
      ? _events.receiveBroadcastStream().map((_) {})
      : const Stream.empty();
}
