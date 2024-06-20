// ignore_for_file: public_member_api_docs, unawaited_futures, prefer_final_locals, prefer_single_quotes, avoid_void_async, require_trailing_commas

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_messaging_listener.dart';
import 'local_push_notification_service.dart';

class FirebaseBackgroundMessageHandler {
  @pragma('vm:entry-point')
  static Future<void> handle(RemoteMessage message) async {
    await Firebase.initializeApp();
    FirebaseMessagingListener().enableIOSNotifications();
    triggerNotification(message);
  }

  @pragma('vm:entry-point')
  static void triggerNotification(RemoteMessage message) async {
    final ILocalPushNotificationService localPushNotificationService = LocalPushNotificationService.getInstance();

    final data = message.data;

    final dataMessage = data
      ..addAll({
        'title': message.notification?.title,
        'body': message.notification?.body,
      });

    final payload = {};

    await localPushNotificationService.localPushNotification(
        message.notification?.title ?? '', message.notification?.body ?? '', json.encode(payload), 0);

    // InitFirebase().createAndroidChannel(false);
  }
}
