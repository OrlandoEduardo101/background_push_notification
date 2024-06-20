import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
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

  Future<void> initFirebase(BuildContext context) async {
    WidgetsFlutterBinding.ensureInitialized();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('FirebaseMessaging.onMessage: ${message.notification?.title}');

      final data = message.data;

      final payload = {
        'id': int.tryParse(data['eventId'] ?? '-1') ?? -1,
        'positionId': int.tryParse(data['positionId'] ?? '-1') ?? -1,
        'attributes': data['attributes'],
        'type': data['type'],
        'deviceName': message.notification?.title,
      };

      await localPushNotificationService.localPushNotification(
          message.notification?.title ?? '', message.notification?.body ?? '', json.encode(payload), 0);
    });

    createAndroidChannel(false);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> updateFirebaseToken() async {
    log('notificationToken: $notificationToken');
  }
}
