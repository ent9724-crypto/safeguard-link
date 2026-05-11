import 'package:flutter/services.dart';
import '../config.dart';

class GuardianVibrationService {
  static void triggerGuardianVibration() {
    // Trigger Guardian Vibration pattern for Malaysian IC detection
    if (AppConfig.isTest) {
      print('Guardian Vibration triggered - Malaysian IC detected');
      return;
    }
    
    // Vibration pattern: 3 short pulses, pause, 2 long pulses
    HapticFeedback.lightImpact(); // First pulse
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.lightImpact(); // Second pulse
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      HapticFeedback.lightImpact(); // Third pulse
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      HapticFeedback.heavyImpact(); // First long pulse
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      HapticFeedback.heavyImpact(); // Second long pulse
    });
  }
}
