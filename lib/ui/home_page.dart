import 'package:flutter/material.dart';

import 'widgets/notification_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
