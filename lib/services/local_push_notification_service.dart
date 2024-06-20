import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse response) async {
  log('onDidReceiveBackgroundNotificationResponse: $response');

  if (response.payload.toString().toLowerCase().contains("notificação")) {
    await Future.delayed(const Duration(milliseconds: 2000));
    log('Som de notificação');
  }
}

void Function(
  int eventId,
  int positionId,
  Map<String, dynamic> eventAttributes,
  String eventType,
  String deviceName,
)? onTapMessage;

void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  log('notificationResponse: $notificationResponse');
  final payload = json.decode(notificationResponse.payload ?? '{}');
  log('payload: $payload');
}

abstract class ILocalPushNotificationService {
  Future<bool?> initialize();
  Future<void> localPushNotification(String title, String body, String payload, int id);
  Future<void> requestPermissions();
  set setOnTapMessage(
      void Function(
        int eventId,
        int positionId,
        Map<String, dynamic> eventAttributes,
        String eventType,
        String deviceName,
      ) value);
}

class LocalPushNotificationService implements ILocalPushNotificationService {
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static final LocalPushNotificationService _inst = LocalPushNotificationService._internal();

  LocalPushNotificationService._internal();

  factory LocalPushNotificationService({required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin}) {
    _inst.flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;
    return _inst;
  }

  static LocalPushNotificationService getInstance() => _inst;

  @override
  set setOnTapMessage(
          void Function(
            int eventId,
            int positionId,
            Map<String, dynamic> eventAttributes,
            String eventType,
            String deviceName,
          ) value) =>
      onTapMessage = value;

  @override
  Future<bool?> initialize() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const ios = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.allowAnnouncement,
          },
        )
      ],
    );

    return await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: ios,
      ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    );
  }

  @pragma('vm:entry-point')
  @override
  Future<void> localPushNotification(String title, String body, String payload, int id) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const String darwinNotificationCategoryPlain = 'plainCategory';
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var isAlarm = body.toLowerCase().contains('alarm') ||
        title.toLowerCase().contains('alarm') ||
        body.toLowerCase().contains('sos') ||
        title.toLowerCase().contains('sos');

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel', 'channel Notification',
      channelDescription: 'Notifications tracking',
      importance: Importance.max,
      priority: Priority.max,
      icon: "@mipmap/ic_launcher",
      playSound: true,
      enableVibration: true,
      visibility: NotificationVisibility.public,
      // // actions: [playAudioAction],
      ticker: 'ticker',
      vibrationPattern: vibrationPattern,
      showWhen: true,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      category: AndroidNotificationCategory.alarm,
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails, iOS: iosDetails);
    // Criar a ação personalizada para reproduzir o áudio

    await flutterLocalNotificationsPlugin.show(
      id++,
      title.isNotEmpty ? utf8.decode(title.codeUnits) : null,
      body.trim(),
      notificationDetails,
      payload: payload,
    );
    if (body.toString().toLowerCase().contains("alarm")) {
      await Future.delayed(const Duration(milliseconds: 2000));
      log('play_audio_action');
    }
  }

  @override
  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (!(await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false)) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }
}
