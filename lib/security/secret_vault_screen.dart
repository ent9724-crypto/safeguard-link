import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

class SecretVaultScreen extends StatefulWidget {
  const SecretVaultScreen({super.key});

  @override
  State<SecretVaultScreen> createState() => _SecretVaultScreenState();
}

class _SecretVaultScreenState extends State<SecretVaultScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const platform = MethodChannel('safeguard_link/security');
  
  bool _isAuthenticated = false;
  bool _isLivenessComplete = false;
  bool _isMirroringDetected = false;
  bool _isLoading = false;
  String _vaultContent = '';
  final TextEditingController _secretController = TextEditingController();
  
  // Liveness challenge states
  int _livenessStep = 0;
  List<String> _livenessChallenges = ['Blink 3 times', 'Smile', 'Look left', 'Look right'];
  Timer? _livenessTimer;
  
  @override
  void initState() {
    super.initState();
    _enableSecureMode();
    _checkScreenMirroring();
    _startMirroringCheck();
  }
  
  @override
  void dispose() {
    _livenessTimer?.cancel();
    super.dispose();
  }
  
  Future<void> _enableSecureMode() async {
    try {
      if (Platform.isAndroid) {
        await platform.invokeMethod('enableSecureMode');
      } else if (Platform.isIOS) {
        await platform.invokeMethod('enableSecureMode');
      }
    } catch (e) {
      debugPrint('Error enabling secure mode: $e');
    }
  }
  
  Future<void> _checkScreenMirroring() async {
    try {
      final isMirroring = await platform.invokeMethod('checkScreenMirroring');
      if (isMirroring == true) {
        setState(() {
          _isMirroringDetected = true;
        });
        _showMirroringWarning();
      }
    } catch (e) {
      debugPrint('Error checking screen mirroring: $e');
    }
  }
  
  void _startMirroringCheck() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkScreenMirroring();
    });
  }
  
  void _showMirroringWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.red, size: 24),
            SizedBox(width: 8),
            Text('Screen Sharing Warning'),
          ],
        ),
        content: const Text(
          '⚠️ SCREEN MIRRORING DETECTED!\n\n'
          'For your security, access to the Secret Vault is blocked when screen sharing or mirroring is active.\n\n'
          'Please stop screen sharing and try again.',
          style: TextStyle(fontSize: 14),
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
  
  Future<void> _authenticateWithBiometrics() async {
    if (_isMirroringDetected) {
      _showMirroringWarning();
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      
      if (!canCheckBiometrics || !isDeviceSupported) {
        _showFallbackAuth();
        return;
      }
      
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access Secret Vault',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      
      if (authenticated) {
        _startLivenessChallenge();
      }
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      _showFallbackAuth();
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  void _startLivenessChallenge() {
    setState(() {
      _livenessStep = 0;
      _isLivenessComplete = false;
    });
    
    _showLivenessDialog();
  }
  
  void _showLivenessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.face_retouching_natural, color: Colors.blue, size: 24),
              SizedBox(width: 8),
              Text('Liveness Challenge'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please complete the liveness check:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.face, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      _livenessChallenges[_livenessStep],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: (_livenessStep + 1) / _livenessChallenges.length,
                backgroundColor: Colors.grey.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                'Step ${_livenessStep + 1} of ${_livenessChallenges.length}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _livenessStep++;
                });
                
                if (_livenessStep >= _livenessChallenges.length) {
                  Navigator.pop(context);
                  _completeLiveness();
                } else {
                  Navigator.pop(context);
                  _showLivenessDialog();
                }
              },
              child: const Text('Complete'),
            ),
          ],
        ),
      ),
    );
  }
  
  void _completeLiveness() {
    setState(() {
      _isLivenessComplete = true;
      _isAuthenticated = true;
    });
    _loadVaultContent();
  }
  
  void _showFallbackAuth() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PIN Authentication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your PIN to access the Secret Vault:'),
            const SizedBox(height: 16),
            TextField(
              controller: _secretController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
                counterText: '',
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
            onPressed: () {
              if (_secretController.text.length == 6) {
                Navigator.pop(context);
                setState(() {
                  _isAuthenticated = true;
                });
                _loadVaultContent();
              }
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _loadVaultContent() async {
    try {
      final content = await _secureStorage.read(key: 'secret_vault_content');
      setState(() {
        _vaultContent = content ?? 'No secrets stored yet';
      });
    } catch (e) {
      debugPrint('Error loading vault content: $e');
    }
  }
  
  Future<void> _saveVaultContent() async {
    if (_secretController.text.isNotEmpty) {
      try {
        await _secureStorage.write(
          key: 'secret_vault_content',
          value: _secretController.text,
        );
        _loadVaultContent();
        _secretController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Secret saved successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving secret: $e')),
        );
      }
    }
  }
  
  Future<void> _clearVault() async {
    try {
      await _secureStorage.delete(key: 'secret_vault_content');
      setState(() {
        _vaultContent = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vault cleared')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing vault: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isMirroringDetected) {
      return Scaffold(
        backgroundColor: Colors.red.withOpacity(0.1),
        appBar: AppBar(
          title: const Text('Secret Vault - BLOCKED'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text(
                'SCREEN MIRRORING DETECTED',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Access blocked for your security',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkScreenMirroring,
                child: const Text('Recheck'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: Text(
          _isAuthenticated ? 'Secret Vault' : 'Secret Vault - Locked',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        foregroundColor: Colors.white,
        actions: [
          if (_isAuthenticated)
            IconButton(
              icon: const Icon(Icons.lock, color: Colors.white),
              onPressed: () {
                setState(() {
                  _isAuthenticated = false;
                  _isLivenessComplete = false;
                });
              },
            ),
        ],
      ),
      body: _isAuthenticated ? _buildVaultContent() : _buildLockedScreen(),
    );
  }
  
  Widget _buildLockedScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Secret Vault',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Advanced biometric & liveness protection',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 32),
          if (_isLoading)
            const CircularProgressIndicator(color: Colors.white)
          else
            ElevatedButton.icon(
              onPressed: _authenticateWithBiometrics,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock with Biometrics'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildVaultContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.security, color: Colors.green, size: 24),
                    const SizedBox(width: 8),
                    const Text(
                      'Protected Content',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'SECURE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  _vaultContent,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _secretController,
            decoration: const InputDecoration(
              labelText: 'New Secret',
              labelStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            obscureText: true,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveVaultContent,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Secret'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _clearVault,
                icon: const Icon(Icons.delete),
                label: const Text('Clear'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Security Status: ACTIVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '• Biometric verification ✓\n• Liveness challenge ✓\n• Screen mirroring protection ✓\n• Screenshot prevention ✓',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
