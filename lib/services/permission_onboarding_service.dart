import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class PermissionOnboardingService {
  static const String _onboardingCompletedKey = 'permission_onboarding_completed';
  
  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompletedKey);
  }

  static Future<Map<Permission, PermissionStatus>> checkAllPermissions() async {
    return {
      Permission.microphone: await Permission.microphone.status,
      Permission.phone: await Permission.phone.status,
      Permission.camera: await Permission.camera.status,
      Permission.storage: await Permission.storage.status,
      Permission.notification: await Permission.notification.status,
    };
  }

  static Future<Map<Permission, bool>> requestAllPermissions() async {
    final results = <Permission, bool>{};
    
    // Request microphone permission
    results[Permission.microphone] = await _requestPermission(
      Permission.microphone,
      'Microphone Access',
      'We need access to your microphone to detect unusual audio patterns and protect you from AI voice cloning attacks.',
    );
    
    // Request phone permission
    results[Permission.phone] = await _requestPermission(
      Permission.phone,
      'Phone Access',
      'We need access to your calls to detect potential AI cloning scams and protect you during conversations.',
    );
    
    // Request camera permission
    results[Permission.camera] = await _requestPermission(
      Permission.camera,
      'Camera Access',
      'We need camera access for identity verification and to ensure your account security.',
    );
    
    // Request storage permission
    results[Permission.storage] = await _requestPermission(
      Permission.storage,
      'Storage Access',
      'We need storage access to save security settings and protect your data locally.',
    );
    
    // Request notification permission
    results[Permission.notification] = await _requestPermission(
      Permission.notification,
      'Notification Access',
      'We need notification access to alert you immediately about potential security threats.',
    );
    
    return results;
  }

  static Future<bool> _requestPermission(
    Permission permission,
    String title,
    String rationale,
  ) async {
    final status = await permission.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }
    
    if (status.isPermanentlyDenied) {
      // User has permanently denied - need to guide to settings
      return false;
    }
    
    return false;
  }

  static String getPermissionExplanation(Permission permission, {bool isMalay = false}) {
    switch (permission) {
      case Permission.microphone:
        return isMalay 
          ? 'Kami perlukan akses mikrofon anda untuk mengesan corak audio yang luar biasa dan melindungi anda daripada serangan kloning suara AI.'
          : 'We need access to your microphone to detect unusual audio patterns and protect you from AI voice cloning attacks.';
      
      case Permission.phone:
        return isMalay
          ? 'Kami perlukan akses panggilan anda untuk mengesan penipuan kloning AI yang berpotensi dan melindungi anda semasa perbualan.'
          : 'We need access to your calls to detect potential AI cloning scams and protect you during conversations.';
      
      case Permission.camera:
        return isMalay
          ? 'Kami perlukan akses kamera untuk pengesahan identiti dan memastikan keselamatan akaun anda.'
          : 'We need camera access for identity verification and to ensure your account security.';
      
      case Permission.storage:
        return isMalay
          ? 'Kami perlukan akses storan untuk menyimpan tetapan keselamatan dan melindungi data anda secara tempatan.'
          : 'We need storage access to save security settings and protect your data locally.';
      
      case Permission.notification:
        return isMalay
          ? 'Kami perlukan akses pemberitahuan untuk memberi amaran kepada anda dengan segera tentang ancaman keselamatan yang berpotensi.'
          : 'We need notification access to alert you immediately about potential security threats.';
      
      default:
        return isMalay
          ? 'Kami perlukan kebenaran ini untuk fungsi keselamatan aplikasi.'
          : 'We need this permission for the app\'s security functionality.';
    }
  }

  static String getPermissionTitle(Permission permission, {bool isMalay = false}) {
    switch (permission) {
      case Permission.microphone:
        return isMalay ? 'Akses Mikrofon' : 'Microphone Access';
      case Permission.phone:
        return isMalay ? 'Akses Panggilan' : 'Phone Access';
      case Permission.camera:
        return isMalay ? 'Akses Kamera' : 'Camera Access';
      case Permission.storage:
        return isMalay ? 'Akses Storanj' : 'Storage Access';
      case Permission.notification:
        return isMalay ? 'Akses Pemberitahuan' : 'Notification Access';
      default:
        return isMalay ? 'Kebenaran Diperlukan' : 'Permission Required';
    }
  }
}
