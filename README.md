
# Background Push Notification with Firebase FCM in Flutter

This repository is an example of using Firebase Cloud Messaging (FCM) for handling background push notifications in a Flutter application. The project demonstrates how to set up and integrate FCM to receive and display notifications even when the app is not in the foreground.

## Features

- **FCM Integration**: Set up Firebase in a Flutter app.
- **Background Notifications**: Handle notifications when the app is in the background.
- **Platform Specific Setup**: Configure both Android and iOS for FCM.

## Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/OrlandoEduardo101/background_push_notification.git
   cd background_push_notification
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files.

4. **Run the App**:
   ```bash
   flutter run
   ```

## Configuration

Ensure you have followed the Firebase setup instructions for both Android and iOS:
- **Android**: Update `android/build.gradle` and `android/app/build.gradle`.
- **iOS**: Update `ios/Runner/Info.plist` and configure capabilities.

## Code Explanation

### `lib/main.dart`

The entry point of the application. It initializes Firebase and sets up the main widget.

### `lib/firebase_options.dart`

Contains Firebase configuration generated from the Firebase Console. This file is essential for initializing Firebase services in the app.

### `lib/notification_service.dart`

Handles notification-related functionalities:
- **Initialization**: Initializes the FCM instance and requests notification permissions.
- **Foreground Notification Handling**: Listens for notifications when the app is in the foreground and displays them.
- **Background Notification Handling**: Configures background message handling using `FirebaseMessaging.onBackgroundMessage`.

### Example Code Snippets

#### Initializing Firebase
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

#### Notification Service
```dart
class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle message
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Handle background message
  }
}
```

## Usage

The example includes basic code for receiving and displaying notifications. Customize the notification handling code in the `lib` directory as per your needs.

## Conclusion

This example serves as a starting point for integrating FCM with Flutter to handle background notifications. Refer to the [Firebase documentation](https://firebase.google.com/docs/cloud-messaging) for more detailed instructions and advanced configurations.

For more details, check the [repository](https://github.com/OrlandoEduardo101/background_push_notification).
