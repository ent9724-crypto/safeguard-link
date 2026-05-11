import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

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
                fontSize:16,
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
