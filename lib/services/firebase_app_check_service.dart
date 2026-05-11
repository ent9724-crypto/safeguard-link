import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import '../config.dart';

class FirebaseAppCheckService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized || !AppConfig.enableAppCheck) {
      return;
    }

    try {
      await Firebase.initializeApp();
      
      // Configure App Check based on platform
      if (kDebugMode && AppConfig.allowDebugMode) {
        // Debug mode - use debug provider
        await FirebaseAppCheck.instance.activate(
          webProvider: ReCaptchaV3Provider('YOUR_RECAPTCHA_SITE_KEY'),
          androidProvider: AndroidProvider.debug,
          appleProvider: AppleProvider.debug,
        );
      } else {
        // Production mode - use real providers
        await FirebaseAppCheck.instance.activate(
          webProvider: ReCaptchaV3Provider('YOUR_RECAPTCHA_SITE_KEY'),
          androidProvider: AndroidProvider.playIntegrity,
          appleProvider: AppleProvider.deviceCheck,
        );
      }

      _initialized = true;
      
      if (AppConfig.enableDebugLogs) {
        print('Firebase App Check initialized successfully');
      }
    } catch (e) {
      if (AppConfig.enableDebugLogs) {
        print('Failed to initialize Firebase App Check: $e');
      }
      // In production, we might want to handle this more gracefully
      if (!AppConfig.isTest) {
        rethrow;
      }
    }
  }

  static Future<String?> getAppCheckToken() async {
    if (!AppConfig.enableAppCheck || !_initialized) {
      return null;
    }

    try {
      final token = await FirebaseAppCheck.instance.getToken();
      return token;
    } catch (e) {
      if (AppConfig.enableDebugLogs) {
        print('Failed to get App Check token: $e');
      }
      return null;
    }
  }

  static bool get isInitialized => _initialized;
}
