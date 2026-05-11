import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class VoiceGuardService {
  static final VoiceGuardService _instance = VoiceGuardService._internal();
  factory VoiceGuardService() => _instance;
  VoiceGuardService._internal();

  bool _isMonitoring = false;
  bool _isSilentAlertActive = false;
  Timer? _monitoringTimer;
  Timer? _silenceTimer;
  Timer? _callDetectionTimer;
  final StreamController<String> _statusController = StreamController<String>.broadcast();
  
  // Call detection parameters
  static const Duration _silenceDuration = Duration(seconds: 5);
  static const Duration _monitoringInterval = Duration(seconds: 1);
  static const Duration _callCheckInterval = Duration(seconds: 2);
  
  // Simulated call state
  bool _isInCall = false;
  DateTime? _lastSoundDetected;
  
  Stream<String> get statusStream => _statusController.stream;
  bool get isMonitoring => _isMonitoring;
  bool get isSilentAlertActive => _isSilentAlertActive;
  bool get isInCall => _isInCall;

  Future<bool> requestPermissions() async {
    try {
      final microphoneStatus = await Permission.microphone.request();
      return microphoneStatus == PermissionStatus.granted;
    } catch (e) {
      debugPrint('Error requesting microphone permission: $e');
      return false;
    }
  }

  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('Microphone permission not granted');
      return;
    }

    try {
      _isMonitoring = true;
      _startCallDetection();
      _statusController.add('Monitoring for suspicious calls...');
      debugPrint('Voice Guard monitoring started');
    } catch (e) {
      debugPrint('Error starting voice monitoring: $e');
    }
  }

  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    try {
      _callDetectionTimer?.cancel();
      _monitoringTimer?.cancel();
      _silenceTimer?.cancel();
      _isMonitoring = false;
      _isSilentAlertActive = false;
      _isInCall = false;
      _statusController.add('Monitoring stopped');
      debugPrint('Voice Guard monitoring stopped');
    } catch (e) {
      debugPrint('Error stopping voice monitoring: $e');
    }
  }

  void _startCallDetection() {
    _callDetectionTimer = Timer.periodic(_callCheckInterval, (timer) {
      if (!_isMonitoring) return;
      
      // Simulate call detection (in real app, would use call state APIs)
      _simulateCallCheck();
    });
  }

  void _simulateCallCheck() {
    // Simulate detecting when user might be on a call
    // This would normally use platform APIs to detect actual call state
    final random = DateTime.now().millisecond % 100;
    
    if (random < 5) { // 5% chance of detecting a "call"
      if (!_isInCall) {
        _isInCall = true;
        _lastSoundDetected = DateTime.now();
        _statusController.add('⚠️ Call detected - Monitoring for silence...');
        _startSilenceMonitoring();
      }
    } else if (_isInCall && random > 95) { // 5% chance of call ending
      _isInCall = false;
      _statusController.add('Call ended - Monitoring...');
      _stopSilenceMonitoring();
    }
  }

  void _startSilenceMonitoring() {
    _monitoringTimer = Timer.periodic(_monitoringInterval, (timer) {
      if (!_isInCall || !_isMonitoring) return;
      
      _checkForSuspiciousSilence();
    });
  }

  void _stopSilenceMonitoring() {
    _monitoringTimer?.cancel();
    _silenceTimer?.cancel();
    _lastSoundDetected = null;
  }

  void _checkForSuspiciousSilence() {
    // Simulate detecting sound/no sound in the call
    final random = DateTime.now().millisecond % 100;
    
    if (random < 10) { // 10% chance of detecting sound
      _lastSoundDetected = DateTime.now();
      _statusController.add('Sound detected - OK');
    } else if (_lastSoundDetected != null) {
      final silenceDuration = DateTime.now().difference(_lastSoundDetected!);
      
      if (silenceDuration >= _silenceDuration) {
        _triggerSilenceAlert();
      } else {
        _statusController.add('Silence detected: ${silenceDuration.inSeconds}s');
      }
    }
  }

  void _triggerSilenceAlert() {
    if (_isSilentAlertActive) return;
    
    _isSilentAlertActive = true;
    _statusController.add('🚨 SILENCE ALERT - Possible voice cloning scam!');
    debugPrint('SILENCE ALERT TRIGGERED - Possible voice cloning scam detected!');
    
    // Vibrate the device
    HapticFeedback.heavyImpact();
    
    // Play alert sound (if available)
    SystemSound.play(SystemSoundType.alert);
  }

  void dismissSilenceAlert() {
    _isSilentAlertActive = false;
  }

  void dispose() {
    stopMonitoring();
    _statusController.close();
  }
}

class VoiceGuardWidget extends StatefulWidget {
  const VoiceGuardWidget({super.key});

  @override
  State<VoiceGuardWidget> createState() => _VoiceGuardWidgetState();
}

class _VoiceGuardWidgetState extends State<VoiceGuardWidget> {
  final VoiceGuardService _voiceGuard = VoiceGuardService();
  bool _isActive = false;
  String _currentStatus = 'Voice Guard disabled';
  bool _showSilenceAlert = false;
  StreamSubscription<String>? _statusSubscription;

  @override
  void initState() {
    super.initState();
    _statusSubscription = _voiceGuard.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _currentStatus = status;
        });
      }
    });
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    super.dispose();
  }

  void _toggleVoiceGuard() async {
    if (_isActive) {
      await _voiceGuard.stopMonitoring();
      setState(() {
        _isActive = false;
      });
    } else {
      await _voiceGuard.startMonitoring();
      setState(() {
        _isActive = true;
      });
    }
  }

  void _checkForSilenceAlert() {
    if (_voiceGuard.isSilentAlertActive && !_showSilenceAlert) {
      setState(() {
        _showSilenceAlert = true;
      });
      _showSilenceAlertDialog();
    }
  }

  void _showSilenceAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          backgroundColor: Colors.red,
          title: Row(
            children: const [
              Icon(Icons.warning, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '⚠️ SILENCE DETECTED',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'Scammers are recording you to clone your voice.\n\n'
            'HANG UP NOW!\n\n'
            'This is a common scam tactic where fraudsters record your voice '
            'during periods of silence to create AI voice clones for fraudulent calls.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _voiceGuard.dismissSilenceAlert();
                setState(() {
                  _showSilenceAlert = false;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'I UNDERSTAND',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check for silence alert on each build
    _checkForSilenceAlert();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isActive ? Colors.green.withOpacity(0.2) : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isActive ? Colors.green : Colors.white.withOpacity(0.2),
          width: _isActive ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mic,
                color: _isActive ? Colors.green : Colors.white70,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Voice Guard',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _isActive ? 'Monitoring for silence attacks' : 'Silence detection disabled',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isActive ? Colors.green : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isActive,
                onChanged: (_) => _toggleVoiceGuard(),
                activeColor: Colors.green,
              ),
            ],
          ),
          if (_isActive) ...[
            const SizedBox(height: 16),
            Text(
              '• Monitors for suspicious call patterns\n'
              '• Detects 5+ seconds of silence during calls\n'
              '• Alerts against voice cloning scam attempts\n'
              '• Simulated call detection for demonstration',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
