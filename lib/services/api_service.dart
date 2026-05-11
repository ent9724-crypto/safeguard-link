import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'firebase_app_check_service.dart';

class ApiService {
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Mock data for testing
  static final Map<String, dynamic> _mockResponses = {
    '/api/check-url': {
      'is_safe': true,
      'threat_level': 'low',
      'analysis': 'Mock analysis: This URL appears safe in test mode.',
      'timestamp': DateTime.now().toIso8601String(),
    },
    '/api/voice-analysis': {
      'is_ai_clone': false,
      'confidence': 0.95,
      'analysis': 'Mock voice analysis: Human voice detected in test mode.',
      'timestamp': DateTime.now().toIso8601String(),
    },
    '/api/emergency-contacts': {
      'contacts': [
        {'name': 'Police', 'number': '999', 'type': 'emergency'},
        {'name': 'Hospital', 'number': '999', 'type': 'emergency'},
      ]
    },
  };

  static Future<http.Response> get(String endpoint) async {
    if (AppConfig.isTest) {
      return _getMockResponse(endpoint);
    }

    return _makeRequest('GET', endpoint);
  }

  static Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    if (AppConfig.isTest) {
      return _getMockResponse(endpoint, body: body);
    }

    return _makeRequest('POST', endpoint, body: body);
  }

  static Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    if (AppConfig.isTest) {
      return _getMockResponse(endpoint, body: body);
    }

    return _makeRequest('PUT', endpoint, body: body);
  }

  static Future<http.Response> delete(String endpoint) async {
    if (AppConfig.isTest) {
      return _getMockResponse(endpoint);
    }

    return _makeRequest('DELETE', endpoint);
  }

  static Future<http.Response> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final headers = Map<String, String>.from(_defaultHeaders);

    // Add App Check token in production
    if (AppConfig.enableAppCheck) {
      final appCheckToken = await FirebaseAppCheckService.getAppCheckToken();
      if (appCheckToken != null) {
        headers['X-Firebase-AppCheck'] = appCheckToken;
      }
    }

    // Add authorization if user is logged in
    final authToken = await _getAuthToken();
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    http.Response response;

    try {
      switch (method) {
        case 'GET':
          response = await http
              .get(url, headers: headers)
              .timeout(AppConfig.apiTimeout);
          break;
        case 'POST':
          response = await http
              .post(url, headers: headers, body: jsonEncode(body))
              .timeout(AppConfig.apiTimeout);
          break;
        case 'PUT':
          response = await http
              .put(url, headers: headers, body: jsonEncode(body))
              .timeout(AppConfig.apiTimeout);
          break;
        case 'DELETE':
          response = await http
              .delete(url, headers: headers)
              .timeout(AppConfig.apiTimeout);
          break;
        default:
          throw UnsupportedError('HTTP method $method is not supported');
      }

      if (AppConfig.enableDebugLogs) {
        print('API Request: $method $url');
        print('Response Status: ${response.statusCode}');
        if (response.statusCode >= 400) {
          print('Response Body: ${response.body}');
        }
      }

      return response;
    } on SocketException catch (e) {
      if (AppConfig.enableDebugLogs) {
        print('Network error: $e');
      }
      throw ApiException('Network connection failed. Please check your internet connection.');
    } on HttpException catch (e) {
      if (AppConfig.enableDebugLogs) {
        print('HTTP error: $e');
      }
      throw ApiException('HTTP error occurred: ${e.message}');
    } catch (e) {
      if (AppConfig.enableDebugLogs) {
        print('Unexpected error: $e');
      }
      throw ApiException('An unexpected error occurred: $e');
    }
  }

  static Future<http.Response> _getMockResponse(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final mockData = _mockResponses[endpoint];
    
    if (mockData != null) {
      if (AppConfig.enableDebugLogs) {
        print('Mock API Response for $endpoint: $mockData');
      }
      
      return http.Response(
        jsonEncode(mockData),
        200,
        headers: _defaultHeaders,
      );
    }

    // Default mock response for unknown endpoints
    return http.Response(
      jsonEncode({
        'success': true,
        'message': 'Mock response for $endpoint in test mode',
        'timestamp': DateTime.now().toIso8601String(),
      }),
      200,
      headers: _defaultHeaders,
    );
  }

  static Future<String?> _getAuthToken() async {
    // In a real app, this would retrieve the auth token from secure storage
    // For now, return null as we haven't implemented authentication yet
    return null;
  }

  // Specific API methods for the safeguard app
  static Future<Map<String, dynamic>> checkUrlSafety(String url) async {
    try {
      final response = await post('/api/check-url', body: {'url': url});
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Failed to check URL safety: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('URL safety check failed: $e');
    }
  }

  static Future<Map<String, dynamic>> analyzeVoice(String audioPath) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse('${AppConfig.baseUrl}/api/voice-analysis'));
      
      // Add App Check token if enabled
      if (AppConfig.enableAppCheck) {
        final appCheckToken = await FirebaseAppCheckService.getAppCheckToken();
        if (appCheckToken != null) {
          request.headers['X-Firebase-AppCheck'] = appCheckToken;
        }
      }

      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
      
      final streamedResponse = await request.send().timeout(AppConfig.apiTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Voice analysis failed: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Voice analysis failed: $e');
    }
  }

  static Future<Map<String, dynamic>> getEmergencyContacts() async {
    try {
      final response = await get('/api/emergency-contacts');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Failed to get emergency contacts: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Emergency contacts retrieval failed: $e');
    }
  }

  static Future<Map<String, dynamic>> reportIncident(Map<String, dynamic> incident) async {
    try {
      final response = await post('/api/report-incident', body: incident);
      
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw ApiException('Failed to report incident: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Incident reporting failed: $e');
    }
  }
}

class ApiException implements Exception {
  final String message;
  
  ApiException(this.message);
  
  @override
  String toString() => 'ApiException: $message';
}
