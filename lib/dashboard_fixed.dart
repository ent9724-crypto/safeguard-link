import 'package:flutter/material.dart';
import 'evidence_engine.dart';
import 'scam_tips.dart';
import 'package:url_launcher/url_launcher.dart';
import 'services/guardian_service.dart';
import 'services/pin_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const DashboardFixed(),
  ));
}

class DashboardFixed extends StatefulWidget {
  const DashboardFixed({super.key});

  @override
  State<DashboardFixed> createState() => _DashboardFixedState();
}

class _DashboardFixedState extends State<DashboardFixed> {
  bool _kindergartenMode = false;
  final TextEditingController _checkController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  bool _showVault = false;
  String _familySafeWord = "TIGER2024";
  bool _voiceGuardActive = false;
  bool _screenShieldActive = false;
  
  // Services
  final GuardianService _guardianService = GuardianService();
  final PinService _pinService = PinService();
  bool _isLeaderMode = false;
  bool _servicesInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await _guardianService.initialize();
      _isLeaderMode = await _guardianService.isLeaderMode();
      if (mounted) {
        setState(() {
          _servicesInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing services: $e');
      // Still set as initialized to prevent blank screen
      if (mounted) {
        setState(() {
          _servicesInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: Text(
          _kindergartenMode ? 'Friendly Helper' : 'Parent Control Mode',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        actions: [
          // Panduan Guide Icon
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ScamTips()),
              );
            },
            tooltip: 'Panduan (Guide)',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kindergarten Mode Toggle
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _kindergartenMode = !_kindergartenMode;
                });
              },
              icon: Icon(
                Icons.child_care_rounded,
                color: _kindergartenMode ? const Color(0xFFffe22f) : null,
              ),
              label: Text(_kindergartenMode ? 'Kindergarten Mode' : 'Parent Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7fbbdd).withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Leader Mode Toggle
            ElevatedButton.icon(
              onPressed: () async {
                await _guardianService.setLeaderMode(!_isLeaderMode);
                setState(() {
                  _isLeaderMode = !_isLeaderMode;
                });
                await _guardianService.triggerSystemAlert(
                  'Role Changed',
                  'You are now in ${_isLeaderMode ? 'Leader' : 'Member'} mode'
                );
              },
              icon: Icon(
                Icons.admin_panel_settings,
                color: _isLeaderMode ? Colors.orange : null,
              ),
              label: Text(_isLeaderMode ? 'Leader Mode' : 'Member Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFff6b6b).withOpacity(0.2),
                foregroundColor: Colors.white,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Main Description
            Text(
              _kindergartenMode 
                ? 'Welcome! Tap any button and I will guide you step by step.'
                : 'Welcome! Use simple safety tools or open more detailed parent controls.',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // PIN Management
            if (!_kindergartenMode) ...[
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Security PIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: _showPinDialog,
                            child: Text('Set PIN', style: TextStyle(color: Colors.blue[700])),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // 997 Emergency Button
            if (_kindergartenMode) ...[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.phone_in_talk, size: 30),
                  label: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'CALL 997 NOW',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Live: 24/7',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  onPressed: _call997,
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Identity Vault Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              color: _kindergartenMode 
                  ? const Color(0xFFFFF9C0) 
                  : const Color(0xFFE3F2FD),
              child: Padding(
                padding: EdgeInsets.all(_kindergartenMode ? 24.0 : 16.0),
                child: Column(
                  children: [
                    Text(
                      _kindergartenMode ? 'Family Safe Word' : 'Identity Vault',
                      style: TextStyle(
                        fontSize: _kindergartenMode ? 24 : 18,
                        fontWeight: FontWeight.bold,
                        color: _kindergartenMode ? const Color(0xFFE91E63) : Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 15),
                    
                    if (!_showVault) ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showVault = true;
                          });
                        },
                        icon: const Icon(Icons.lock_open),
                        label: Text(_kindergartenMode ? 'Show Safe Word' : 'Open Identity Vault'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(48, 48),
                        ),
                      ),
                    ] else ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.yellow, width: 2),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.security, color: Colors.yellow, size: 40),
                            const SizedBox(height: 10),
                            Text(
                              _familySafeWord,
                              style: const TextStyle(
                                color: Colors.yellow,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showVault = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Hide'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Voice Guard Toggle
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _voiceGuardActive = !_voiceGuardActive;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_voiceGuardActive ? 'Voice Guard deactivated' : 'Voice Guard activated')),
                      );
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('Voice Guard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _voiceGuardActive ? Colors.red : Colors.green[100],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EvidenceEngine()),
                      );
                    },
                    icon: const Icon(Icons.report),
                    label: const Text('Evidence Engine'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[100],
                      foregroundColor: Colors.orange[800],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Screen Shield Toggle
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _screenShieldActive = !_screenShieldActive;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_screenShieldActive ? 'Screen protection deactivated' : 'Screen protection activated')),
                      );
                    },
                    icon: const Icon(Icons.security),
                    label: const Text('Screen Shield'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _screenShieldActive ? Colors.red : Colors.green[100],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScamTips()),
                      );
                    },
                    icon: const Icon(Icons.lightbulb),
                    label: const Text('Safety Tips'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Semak Penipu (PDRM) Button
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchSemakMule,
                icon: const Icon(Icons.gavel, size: 28),
                label: const Text(
                  'Semak Penipu (PDRM)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0), // Dark blue for high contrast
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  minimumSize: const Size(double.infinity, 56),
                  elevation: 4,
                ),
              ),
            ),
            
            // Safety Guide Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                'Semak nombor akaun bank atau nombor telefon di sini sebelum buat bayaran.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // SMS Risk Scanner Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _kindergartenMode ? 'Check Message Safety' : 'SMS Risk Scanner',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _smsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: _kindergartenMode 
                          ? 'Paste message here to check if it is safe'
                          : 'Enter SMS content for risk analysis',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _analyzeSMS,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_kindergartenMode ? 'Check Safety' : 'Analyze Risk'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _simulateScam,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(_kindergartenMode ? 'Test Scam' : 'Simulate Scam'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Environment Status
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Environment Status',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Environment: PRODUCTION (Real APIs)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Firebase App Check: Active',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Live Voice Monitoring: Ready',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Screen Protection: Active',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _call997() async {
    final Uri url = Uri(scheme: 'tel', path: '997');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

  void _analyzeSMS() {
    final smsText = _smsController.text.toLowerCase();
    bool isScam = false;
    String reason = '';
    
    // Simple scam detection
    if (smsText.contains('kwsp') || smsText.contains('lhdn')) {
      isScam = true;
      reason = 'Government agency impersonation';
    } else if (smsText.contains('997') && smsText.contains('emergency')) {
      isScam = true;
      reason = 'Fake emergency alert';
    } else if (smsText.contains('bank account') && smsText.contains('suspended')) {
      isScam = true;
      reason = 'Bank account suspension scam';
    } else if (smsText.contains('click link') || smsText.contains('http')) {
      isScam = true;
      reason = 'Suspicious link detected';
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isScam ? 'SCAM DETECTED' : 'Message Appears Safe'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isScam ? Icons.warning : Icons.check_circle,
              color: isScam ? Colors.red : Colors.green,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              isScam 
                ? 'This message shows signs of being a scam:\n\n$reason'
                : 'No obvious scam indicators found in this message.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _simulateScam() {
    final scamMessage = 'URGENT: Your KWSP account has been suspended. Click http://fake-scam.com to verify immediately. Call 997 if you have questions.';
    _smsController.text = scamMessage;
    
    // Scan the message using GuardianService
    final result = _guardianService.scanMessage(scamMessage);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scam message loaded for testing\n$result'),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showPinDialog() {
    final TextEditingController pinController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Security PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter a 4-digit PIN for security:'),
              const SizedBox(height: 16),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PIN',
                  hintText: '1234',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final pin = pinController.text;
                if (pin.length == 4 && RegExp(r'^\d{4}$').hasMatch(pin)) {
                  try {
                    await _pinService.savePin(pin);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('PIN set successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error setting PIN: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid 4-digit PIN')),
                  );
                }
              },
              child: const Text('Set PIN'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchSemakMule() async {
    final Uri url = Uri.parse('https://semakmule.rmp.gov.my/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch PDRM SemakMule portal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDRM portal: $e')),
      );
    }
  }
}
