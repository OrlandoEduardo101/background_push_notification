import 'package:background_push_notification/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'services/analytics/analytics_service.dart';
import 'services/analytics/crashalytics_service.dart';
import 'services/notifications/firebase_messaging_listener.dart';
import 'services/notifications/local_push_notification_service.dart';
import 'ui/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final firebaseMessagingListener = FirebaseMessagingListener();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init firebase and FCM
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  firebaseMessagingListener.setOnbackgroundMessage();
  await firebaseMessagingListener.registerNotification();

  // Init local pushes
  final ILocalPushNotificationService localPushNotificationService =
      LocalPushNotificationService(flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);

  localPushNotificationService.initialize();
  localPushNotificationService.requestPermissions();

  CrashlyticsService.initializeCrashlytics();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Push Notifications',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        crashlyticsService: CrashlyticsService(FirebaseCrashlytics.instance),
        analyticsService: AnalyticsService(FirebaseAnalytics.instance),
      ),
    );
  }
}
