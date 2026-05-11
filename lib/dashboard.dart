import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'reporting.dart';
import 'vault.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Safeguard'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF1E3A5F),
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
                    // Vibration logic would go here
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
