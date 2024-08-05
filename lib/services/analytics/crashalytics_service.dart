import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

abstract class ICrashlyticsService {
  Future<void> log(String message);
  Future<void> recordError(dynamic exception, StackTrace stack);
  Future<void> setCustomKey(String key, String value);
}

class CrashlyticsService implements ICrashlyticsService {
  final FirebaseCrashlytics _crashlytics;

  CrashlyticsService(this._crashlytics);

  @override
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  @override
  Future<void> recordError(dynamic exception, StackTrace stack) async {
    await _crashlytics.recordError(exception, stack);
  }

  @override
  Future<void> setCustomKey(String key, String value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  static void initializeCrashlytics() {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
