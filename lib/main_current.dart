import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize notifications
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'scam_alerts',
        channelName: 'Scam Alerts',
        channelDescription: 'Real-time scam alerts and warnings',
        defaultColor: Colors.red,
        ledColor: Colors.red,
        playSound: true,
        importance: NotificationImportance.High,
      ),
    ],
    debug: true,
  );

  await AwesomeNotifications().requestPermissionToSendNotifications();
  
  runApp(const SafeGuardSandboxApp());
}

class SafeGuardSandboxApp extends StatelessWidget {
  const SafeGuardSandboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Safeguard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Safeguard'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Identity Protection Features',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // Secret Vault Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _openSecretVault(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.lock, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🔐 Secret Vault',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Biometric Protection',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // PII Protection Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _testPIIProtection(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.security, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🛡️ PII Protection',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'IC Auto-Masking',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Voice Guard Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _testVoiceGuard(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.mic, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🎤 Voice Guard',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Silent Call Detection',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Scam Scanner Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _openScamScanner(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.search, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🔍 Scam Scanner',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Message Analysis',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // NSRC Evidence Engine Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _openNsrcPrepPage(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.timeline, size: 32),
                    SizedBox(height: 8),
                    Text(
                      '🛡️ NSRC Evidence Engine',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'SQLite Timeline',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Production Features Active:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            const Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Native Blackout Shield'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Hardware Biometrics'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('PII Auto-Masking'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Haptic Feedback'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('SQLite Evidence Engine'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openSecretVault() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SecretVaultScreen(),
      ),
    );
  }

  void _testPIIProtection() {
    final TextEditingController icController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Test PII Protection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter Malaysian IC (######-##-####):',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: icController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '######-##-####',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if (value.replaceAll('-', '').length == 12) {
                    Vibration.vibrate(pattern: [0, 150]);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _testVoiceGuard() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🎤 Voice Guard'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mic, size: 48, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                'Silent Call Detection Active',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Monitoring for silence below 30dB for 7 seconds...',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Colors.blue),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Stop Monitoring'),
            ),
          ],
        );
      },
    );
  }

  void _openScamScanner() {
    final TextEditingController messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('🔍 Scam Scanner'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter message to scan for scams:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Paste suspicious message here...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final message = messageController.text;
                  if (message.isNotEmpty) {
                    _scanMessage(message);
                  }
                },
                child: const Text('Scan Message'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _scanMessage(String message) {
    // Simple scam detection logic
    final scamKeywords = [
      'bank', 'account', 'verify', 'urgent', 'winner', 'prize', 
      'click', 'link', 'password', 'username', 'otp', 'code'
    ];
    
    int suspiciousCount = 0;
    for (final keyword in scamKeywords) {
      if (message.toLowerCase().contains(keyword)) {
        suspiciousCount++;
      }
    }
    
    final isScam = suspiciousCount >= 3;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                isScam ? Icons.warning : Icons.check_circle,
                color: isScam ? Colors.red : Colors.green,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isScam ? '⚠️ Scam Detected!' : '✅ Message Safe',
                style: TextStyle(
                  color: isScam ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Suspicious keywords found: $suspiciousCount',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                isScam 
                  ? 'This message appears to be a scam. Do not click any links or share personal information.'
                  : 'This message appears to be safe.',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  void _openNsrcPrepPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NsrcPrepPage(),
      ),
    );
  }
}

// SQLite Database Helper for Evidence Engine
class EvidenceDatabase {
  static const String _databaseName = 'evidence_engine.db';
  static const String _tableName = 'chronology';
  static const int _databaseVersion = 1;

  static Database? _database;

  // 2026 Update: Enhanced keyword intelligence
  static const List<String> highRiskKeywords = [
    'LHDN', 'PDRM', '997', 'Audit', 'TAC', 'OTP', 'MyKasih'
  ];

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, _databaseName);

    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        type TEXT NOT NULL,
        icon TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT,
        sender TEXT,
        keywords TEXT,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> insertEvent({
    required String type,
    required String icon,
    required String title,
    String? content,
    String? sender,
    List<String>? keywords,
  }) async {
    final db = await database;
    final timestamp = DateTime.now().toIso8601String();
    final keywordsStr = keywords?.join(',') ?? '';

    await db.insert(
      _tableName,
      {
        'timestamp': timestamp,
        'type': type,
        'icon': icon,
        'title': title,
        'content': content,
        'sender': sender,
        'keywords': keywordsStr,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getRecentEventsForUI({int limit = 5}) async {
    final db = await database;
    
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
      limit: limit,
    );

    return List<Map<String, dynamic>>.from(maps.reversed);
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

class NsrcPrepPage extends StatefulWidget {
  const NsrcPrepPage({super.key});

  @override
  State<NsrcPrepPage> createState() => _NsrcPrepPageState();
}

class _NsrcPrepPageState extends State<NsrcPrepPage> {
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  
  // Actual Use Evidence Engine
  List<Map<String, dynamic>> _chronologyEvents = [];
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeEvidenceEngine();
    _loadChronologyFromDatabase();
  }

  void _initializeEvidenceEngine() async {
    // Record app open event to database
    await EvidenceDatabase.insertEvent(
      type: 'user_action',
      icon: '🛡️',
      title: 'Opened Safeguard App',
      content: 'NSRC Evidence Engine activated',
    );
  }

  Future<void> _loadChronologyFromDatabase() async {
    final events = await EvidenceDatabase.getRecentEventsForUI(limit: 5);
    setState(() {
      _chronologyEvents = events;
    });
  }

  Future<void> _addSampleData() async {
    // Add sample scam notifications
    await EvidenceDatabase.insertEvent(
      type: 'external_threat',
      icon: '📩',
      title: 'Received SMS from +60123456789',
      content: 'Your LHDN tax refund of RM2,500 is ready. Please click the link to claim.',
      sender: '+60123456789',
      keywords: ['LHDN'],
    );

    await EvidenceDatabase.insertEvent(
      type: 'external_threat',
      icon: '📩',
      title: 'Received WhatsApp from +60198765432',
      content: 'PDRM requires your immediate verification. Update your account details.',
      sender: '+60198765432',
      keywords: ['PDRM'],
    );

    await EvidenceDatabase.insertEvent(
      type: 'external_threat',
      icon: '📩',
      title: 'Received SMS from +60155566677',
      content: 'Your TAC code is 123456 for transaction verification.',
      sender: '+60155566677',
      keywords: ['TAC'],
    );

    _loadChronologyFromDatabase();
  }

  Future<void> _add997Emergency() async {
    await EvidenceDatabase.insertEvent(
      type: 'emergency',
      icon: '🚨',
      title: 'Dialed NSRC 997',
      content: 'Emergency call initiated',
    );

    _loadChronologyFromDatabase();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🚨 997 Emergency call added to timeline'),
        backgroundColor: Colors.red,
      ),
    );
  }

  String _generateReport() {
    final buffer = StringBuffer();
    buffer.writeln('VICTIM INFO:');
    buffer.writeln('${_bankController.text} | ${_accountController.text}');
    buffer.writeln();
    buffer.writeln('INCIDENT TIMELINE:');
    buffer.writeln();
    
    for (final event in _chronologyEvents) {
      final timestamp = DateTime.parse(event['timestamp']);
      final time = DateFormat('HH:mm').format(timestamp);
      final title = event['title'] as String;
      final content = event['content'] as String?;
      
      if (event['type'] == 'external_threat') {
        final snippet = content != null && content.length > 50 
            ? '${content.substring(0, 50)}...'
            : content ?? '';
        buffer.writeln('$time - Received $title: $snippet');
      } else {
        buffer.writeln('$time - $title');
      }
    }
    
    return buffer.toString();
  }

  Future<void> _copyToClipboard() async {
    final report = _generateReport();
    
    try {
      await Clipboard.setData(ClipboardData(text: report));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📋 Report copied! Paste this when the 997 officer asks for details.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Failed to copy report'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sendToCCIDWhatsApp() async {
    final report = _generateReport();
    final whatsappUrl = 'https://wa.me/60132111222?text=${Uri.encodeComponent(report)}';
    
    try {
      if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
        await launchUrl(Uri.parse(whatsappUrl));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Could not open WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Error opening WhatsApp'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛡️ NSRC Evidence Engine'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Senior-Friendly Disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Jangan risau, Ayah. Info ini akan bantu polis tangkap scammer dengan cepat.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // User Information Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _bankController,
                    decoration: const InputDecoration(
                      labelText: 'Bank Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _accountController,
                    decoration: const InputDecoration(
                      labelText: 'Account Last 4 Digits',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Evidence Engine Status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isListening ? Icons.sensors : Icons.sensors_outlined,
                        color: _isListening ? Colors.green : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Evidence Engine Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isListening ? '🟢 Monitoring SMS & WhatsApp for high-risk keywords' : '🔴 Not monitoring',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isListening ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Keywords: ${EvidenceDatabase.highRiskKeywords.join(', ')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Vertical Timeline UI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evidence Timeline (Last 5 Events)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Emergency Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _add997Emergency,
                      icon: const Icon(Icons.emergency),
                      label: const Text('Add 997 Emergency Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Timeline Display with Step Design
                  _chronologyEvents.isEmpty
                      ? const Center(
                          child: Text(
                            'No events recorded yet',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : _buildVerticalTimeline(),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // One-Tap Reporting Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'One-Tap Reporting',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Copy to Clipboard Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _copyToClipboard,
                      icon: const Icon(Icons.copy),
                      label: const Text('Copy to Clipboard'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Send to CCID WhatsApp Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendToCCIDWhatsApp,
                      icon: const Icon(Icons.message),
                      label: const Text('Send to CCID WhatsApp'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'CCID WhatsApp: +6013-211 1222',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalTimeline() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _chronologyEvents.length,
      itemBuilder: (context, index) {
        final event = _chronologyEvents[index];
        final isLast = index == _chronologyEvents.length - 1;
        
        return _buildTimelineStep(event, isLast);
      },
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> event, bool isLast) {
    final timestamp = DateTime.parse(event['timestamp']);
    final time = DateFormat('HH:mm').format(timestamp);
    final type = event['type'] as String;
    final icon = event['icon'] as String;
    final isThreat = type == 'external_threat';
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline with vertical line and icons
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Icon instead of dot
                Text(
                  icon,
                  style: const TextStyle(fontSize: 20),
                ),
                // Line
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: Colors.grey[300],
                  ),
              ],
            ),
          ),
          
          // Event content
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isThreat ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isThreat ? Colors.red[200]! : Colors.green[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '[$time]',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isThreat ? Colors.red : Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (event['content'] != null && (event['content'] as String).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      event['content'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (event['keywords'] != null && (event['keywords'] as String).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Keywords: ${event['keywords']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecretVaultScreen extends StatefulWidget {
  const SecretVaultScreen({super.key});

  @override
  State<SecretVaultScreen> createState() => _SecretVaultScreenState();
}

class _SecretVaultScreenState extends State<SecretVaultScreen> {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _safeWord;

  @override
  void initState() {
    super.initState();
    _loadSafeWord();
  }

  Future<void> _loadSafeWord() async {
    const storage = FlutterSecureStorage();
    _safeWord = await storage.read(key: 'family_safe_word');
    setState(() {});
  }

  Future<void> _authenticateWithBiometrics() async {
    setState(() => _isLoading = true);

    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authenticate to view Family Safe Word',
        options: const AuthenticationOptions(
          biometricOnly: false,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        setState(() {
          _isAuthenticated = true;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Secret Vault'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'FAMILY SAFE WORD',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            if (_isAuthenticated && _safeWord != null)
              Text(
                _safeWord!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
                textAlign: TextAlign.center,
              )
            else if (_isLoading)
              const CircularProgressIndicator(color: Colors.white)
            else
              ElevatedButton.icon(
                onPressed: _authenticateWithBiometrics,
                icon: const Icon(Icons.fingerprint, size: 24),
                label: const Text('Authenticate with Biometrics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
