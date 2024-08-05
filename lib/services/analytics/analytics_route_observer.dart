import 'dart:developer';

import 'package:flutter/material.dart';

import 'analytics_service.dart';

class AnalyticsRouteObserver extends NavigatorObserver {
  final IAnalyticsService analyticsService;

  AnalyticsRouteObserver({required this.analyticsService});
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    log('New route pushed: ${route.settings.name}');
    _logCurrentScreen(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    log('Route popped: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    log('Route replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    log('Route removed: ${route.settings.name}');
  }

  void _logCurrentScreen(Route<dynamic>? route) {
    if (route?.settings is MaterialPage) {
      final settings = route!.settings as MaterialPage;
      final screenName = settings.name;
      final screenClass = settings.child.runtimeType;
      final parameters = settings.arguments as Map<String, String>?;
      log('Current screen: $screenName, Class: $screenClass');
      analyticsService.logScreenView(
        screenName: screenName,
        screenClass: screenName,
        parameters: parameters,
      );
    }
  }
}
