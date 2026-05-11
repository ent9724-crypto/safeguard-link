import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_service.dart';

class GuardianService {
  static final GuardianService _instance = GuardianService._internal();
  factory GuardianService() => _instance;
  GuardianService._internal();

  final NotificationService _notificationService = NotificationService();
  
  // 2026 Malaysian scam keywords
  static const List<String> _scamKeywords = [
    'KWSP', 'EPF', 'caruman', 'pengeluaran',
    'LHDN', 'income tax', 'cukai pendapatan', 'refund',
    '997', 'NSRC', 'National Scam Response Centre',
    'bank account', 'akaun bank', 'freeze', 'suspended',
    'urgent', 'segera', 'segera', 'immediate action',
    'click here', 'klik sini', 'link', 'pautan',
    'verify', 'sahkan', 'confirm', 'pengesahan',
    'prize', 'hadiah', 'winner', 'menang',
    'delivery', 'penghantaran', 'poslaju', 'courier',
    'customs', 'kastam', 'duti', 'tax',
    'loan', 'pinjaman', 'personal loan', 'pinjaman peribadi',
    'credit card', 'kad kredit', 'blocked', 'disekat',
    'emergency', 'kecemasan', 'account locked', 'akaun dikunci',
  ];

  static const Map<String, String> _scamTypes = {
    'KWSP': 'KWSP/EPF Account',
    'LHDN': 'Tax Refund',
    '997': 'Government Impersonation',
    'bank account': 'Bank Account',
    'urgent': 'Urgent Action',
    'prize': 'Prize/Winnings',
    'delivery': 'Delivery Scam',
    'customs': 'Customs/Tax',
    'loan': 'Loan Offer',
    'credit card': 'Credit Card',
    'emergency': 'Emergency Scam',
  };

  Future<void> initialize() async {
    await _notificationService.initialize();
  }

  Future<void> saveUserRole(String role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
      debugPrint('User role saved: $role');
    } catch (e) {
      debugPrint('Error saving user role: $e');
    }
  }

  Future<String> getUserRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_role') ?? 'Member';
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return 'Member';
    }
  }

  Future<void> setLeaderMode(bool isLeader) async {
    await saveUserRole(isLeader ? 'Leader' : 'Member');
  }

  Future<bool> isLeaderMode() async {
    final role = await getUserRole();
    return role == 'Leader';
  }

  ScanResult scanMessage(String message) {
    final messageLower = message.toLowerCase();
    String detectedScamType = 'Unknown';
    List<String> matchedKeywords = [];

    for (String keyword in _scamKeywords) {
      if (messageLower.contains(keyword.toLowerCase())) {
        matchedKeywords.add(keyword);
        
        // Determine scam type based on keyword
        for (String scamType in _scamTypes.keys) {
          if (keyword.toLowerCase().contains(scamType.toLowerCase())) {
            detectedScamType = _scamTypes[scamType]!;
            break;
          }
        }
      }
    }

    final isScam = matchedKeywords.isNotEmpty;
    
    if (isScam) {
      debugPrint('Scam detected: $detectedScamType');
      debugPrint('Matched keywords: $matchedKeywords');
      
      // Trigger notification
      _triggerScamNotification(detectedScamType, message);
    }

    return ScanResult(
      isScam: isScam,
      scamType: detectedScamType,
      matchedKeywords: matchedKeywords,
      confidence: _calculateConfidence(matchedKeywords, message),
    );
  }

  double _calculateConfidence(List<String> matchedKeywords, String message) {
    if (matchedKeywords.isEmpty) return 0.0;
    
    // Base confidence on number of matched keywords and message characteristics
    double confidence = matchedKeywords.length * 0.2; // 0.2 per keyword
    
    // Boost confidence for urgency indicators
    if (message.toLowerCase().contains('urgent') || 
        message.toLowerCase().contains('segera')) {
      confidence += 0.3;
    }
    
    // Boost confidence for links
    if (message.toLowerCase().contains('http') || 
        message.toLowerCase().contains('www.') ||
        message.toLowerCase().contains('klik sini')) {
      confidence += 0.2;
    }
    
    // Boost confidence for account threats
    if (message.toLowerCase().contains('suspend') || 
        message.toLowerCase().contains('freeze') ||
        message.toLowerCase().contains('lock')) {
      confidence += 0.2;
    }
    
    return confidence.clamp(0.0, 1.0);
  }

  Future<void> _triggerScamNotification(String scamType, String message) async {
    final isLeader = await isLeaderMode();
    
    if (isLeader) {
      await _notificationService.triggerGuardianAlert('Family Member', scamType);
    } else {
      await _notificationService.triggerScamAlert(scamType, message);
    }
  }

  Future<void> triggerManualAlert(String memberName, String threatType) async {
    await _notificationService.triggerGuardianAlert(memberName, threatType);
  }

  Future<void> triggerSystemAlert(String title, String message) async {
    await _notificationService.triggerSystemAlert(title, message);
  }
}

class ScanResult {
  final bool isScam;
  final String scamType;
  final List<String> matchedKeywords;
  final double confidence;

  ScanResult({
    required this.isScam,
    required this.scamType,
    required this.matchedKeywords,
    required this.confidence,
  });

  @override
  String toString() {
    return 'ScanResult(isScam: $isScam, scamType: $scamType, confidence: ${(confidence * 100).toStringAsFixed(1)}%)';
  }
}
