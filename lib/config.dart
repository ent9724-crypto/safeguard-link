class AppConfig {
  // Set to false for production, true for testing
  static const bool isTest = false;
  
  // API endpoints
  static const String _testBaseUrl = 'https://test-api.safeguard-link.com';
  static const String _prodBaseUrl = 'https://api.safeguard-link.com';
  
  static String get baseUrl => isTest ? _testBaseUrl : _prodBaseUrl;
  
  // Firebase configuration
  static const String _testProjectId = 'safeguard-link-test';
  static const String _prodProjectId = 'safeguard-link-prod';
  
  static String get projectId => isTest ? _testProjectId : _prodProjectId;
  
  // App Check configuration
  static const bool enableAppCheck = !isTest; // Only enable in production
  
  // Debug settings
  static const bool enableDebugLogs = isTest;
  
  // Mock data settings
  static const bool useMockData = isTest;
  
  // API timeouts
  static const Duration testTimeout = Duration(seconds: 30);
  static const Duration prodTimeout = Duration(seconds: 15);
  
  static Duration get apiTimeout => isTest ? testTimeout : prodTimeout;
  
  // Security settings
  static const bool enforceStrictSecurity = !isTest;
  static const bool allowDebugMode = isTest;
}
