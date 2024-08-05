import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import 'local_push_notification_service.dart';

String notificationToken = "";

class InitFirebase {
  static final InitFirebase _inst = InitFirebase._internal();

  InitFirebase._internal();

  factory InitFirebase() {
    return _inst;
  }

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound("@raw/sos"),
    playSound: true,
    enableVibration: true,
  );

  final ILocalPushNotificationService localPushNotificationService = LocalPushNotificationService.getInstance();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  Future<void> createAndroidChannel(bool isSosSound) async {
    channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
      sound: isSosSound ? const RawResourceAndroidNotificationSound("sos") : null,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> updateFirebaseToken(String token) async {
    notificationToken = token;
    log('notificationToken: $notificationToken');
  }

  Future<String> get getFirebaseToken async => (await messaging.getToken()) ?? "";
}
