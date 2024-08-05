import 'package:firebase_analytics/firebase_analytics.dart';

abstract class IAnalyticsService {
  Future<void> logEvent(String value, Map<String, Object>? parameters);
  Future<void> logScreenView({
    String? screenClass,
    String? screenName,
    Map<String, Object>? parameters,
    AnalyticsCallOptions? callOptions,
  });
}

class AnalyticsService implements IAnalyticsService {
  final FirebaseAnalytics _analytics ;

  AnalyticsService(this._analytics);

  @override
  Future<void> logEvent(String value, Map<String, Object>? parameters) async {
    await _analytics.logEvent(
      name: value,
      parameters: parameters,
    );
  }

  @override
  Future<void> logScreenView(
      {String? screenClass,
      String? screenName,
      Map<String, Object>? parameters,
      AnalyticsCallOptions? callOptions}) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
      callOptions: callOptions,
      parameters: parameters,
    );
  }
}
