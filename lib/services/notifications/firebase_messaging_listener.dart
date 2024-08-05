import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_background_message_handler.dart';
import 'init_firebase.dart';

class FirebaseMessagingListener {
  Future<void> listenToken() async {
    notificationToken = await InitFirebase().getFirebaseToken;
    InitFirebase().updateFirebaseToken(notificationToken);
    FirebaseMessaging.instance.onTokenRefresh.listen((value) {
      InitFirebase().updateFirebaseToken(value);
    });
  }

  Future<void> registerNotification() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await enableIOSNotifications();

      FirebaseBackgroundMessageHandler.triggerNotification(
        message,
      );
    });
  }

  @pragma('vm:entry-point')
  void setOnbackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(
      FirebaseBackgroundMessageHandler.handle,
    );
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}
