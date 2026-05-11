import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinService {
  static final PinService _instance = PinService._internal();
  factory PinService() => _instance;
  PinService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _pinKey = 'guardian_pin';
  static const String _attemptsKey = 'pin_attempts';
  static const String _lockoutKey = 'pin_lockout';

  Future<void> savePin(String pin) async {
    try {
      await _storage.write(key: _pinKey, value: pin);
      await _storage.delete(key: _attemptsKey);
      await _storage.delete(key: _lockoutKey);
      debugPrint('PIN saved successfully');
    } catch (e) {
      debugPrint('Error saving PIN: $e');
      rethrow;
    }
  }

  Future<String?> getPin() async {
    try {
      return await _storage.read(key: _pinKey);
    } catch (e) {
      debugPrint('Error reading PIN: $e');
      return null;
    }
  }

  Future<bool> hasPin() async {
    final pin = await getPin();
    return pin != null && pin.isNotEmpty;
  }

  Future<bool> verifyPin(String enteredPin) async {
    try {
      // Check if account is locked out
      if (await isLockedOut()) {
        throw Exception('Account is temporarily locked. Please try again later.');
      }

      final storedPin = await getPin();
      if (storedPin == null) {
        throw Exception('No PIN set. Please set a PIN first.');
      }

      if (enteredPin == storedPin) {
        // Reset attempts on successful verification
        await _storage.delete(key: _attemptsKey);
        await _storage.delete(key: _lockoutKey);
        return true;
      } else {
        // Increment failed attempts
        await _incrementFailedAttempts();
        return false;
      }
    } catch (e) {
      debugPrint('Error verifying PIN: $e');
      rethrow;
    }
  }

  Future<void> _incrementFailedAttempts() async {
    try {
      final attemptsStr = await _storage.read(key: _attemptsKey) ?? '0';
      final attempts = int.parse(attemptsStr) + 1;
      await _storage.write(key: _attemptsKey, value: attempts.toString());

      // Lock out after 3 failed attempts for 5 minutes
      if (attempts >= 3) {
        final lockoutUntil = DateTime.now().add(const Duration(minutes: 5));
        await _storage.write(key: _lockoutKey, value: lockoutUntil.toIso8601String());
        debugPrint('Account locked out for 5 minutes due to too many failed attempts');
      }
    } catch (e) {
      debugPrint('Error incrementing failed attempts: $e');
    }
  }

  Future<bool> isLockedOut() async {
    try {
      final lockoutStr = await _storage.read(key: _lockoutKey);
      if (lockoutStr == null) return false;

      final lockoutUntil = DateTime.parse(lockoutStr);
      if (DateTime.now().isAfter(lockoutUntil)) {
        // Lockout period has expired
        await _storage.delete(key: _lockoutKey);
        await _storage.delete(key: _attemptsKey);
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error checking lockout status: $e');
      return false;
    }
  }

  Future<Duration?> getRemainingLockoutTime() async {
    try {
      final lockoutStr = await _storage.read(key: _lockoutKey);
      if (lockoutStr == null) return null;

      final lockoutUntil = DateTime.parse(lockoutStr);
      final remaining = lockoutUntil.difference(DateTime.now());
      
      return remaining.isNegative ? null : remaining;
    } catch (e) {
      debugPrint('Error getting remaining lockout time: $e');
      return null;
    }
  }

  Future<int> getFailedAttempts() async {
    try {
      final attemptsStr = await _storage.read(key: _attemptsKey) ?? '0';
      return int.parse(attemptsStr);
    } catch (e) {
      debugPrint('Error getting failed attempts: $e');
      return 0;
    }
  }

  Future<void> clearPin() async {
    try {
      await _storage.delete(key: _pinKey);
      await _storage.delete(key: _attemptsKey);
      await _storage.delete(key: _lockoutKey);
      debugPrint('PIN cleared successfully');
    } catch (e) {
      debugPrint('Error clearing PIN: $e');
      rethrow;
    }
  }

  Future<bool> validatePinFormat(String pin) {
    return Future.value(pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin));
  }
}
