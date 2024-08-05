import 'package:flutter/material.dart';

import '../services/analytics/analytics_service.dart';
import '../services/analytics/crashalytics_service.dart';
import 'widgets/notification_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.crashlyticsService,
    required this.analyticsService,
  });

  final ICrashlyticsService crashlyticsService;
  final IAnalyticsService analyticsService;

  @override
  Widget build(BuildContext context) {
    // Testar crashalytics service
    try {
      throw Exception();
    } catch (e, s) {
      crashlyticsService.recordError(e, s);
      crashlyticsService.log('Message de log');
    }

    // Test analytics

    analyticsService.logEvent('openedPage', {
      'pageName': 'HomePage',
    });
    analyticsService.logScreenView(screenClass: 'HomePage', screenName: 'home');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications Example'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NotificationWidget(
              title: 'Welcome to Push Notifications',
              message: 'This is an example of push notifications in Flutter.',
            ),
          ],
        ),
      ),
    );
  }
}
