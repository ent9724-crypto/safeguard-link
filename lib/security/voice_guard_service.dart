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

  final AudioRecorder _recorder = AudioRecorder();
  bool _isMonitoring = false;
  bool _isSilentAlertActive = false;
  Timer? _monitoringTimer;
  Timer? _silenceTimer;
  final StreamController<double> _audioLevelController = StreamController<double>.broadcast();
  
  // Silence detection parameters
  static const double _silenceThreshold = 0.01; // Very low audio level
  static const Duration _silenceDuration = Duration(seconds: 5);
  static const Duration _monitoringInterval = Duration(milliseconds: 500);
  
  Stream<double> get audioLevelStream => _audioLevelController.stream;
  bool get isMonitoring => _isMonitoring;
  bool get isSilentAlertActive => _isSilentAlertActive;

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
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: 'voice_guard_recording.wav',
      );
      
      _isMonitoring = true;
      _startSilenceDetection();
      debugPrint('Voice Guard monitoring started');
    } catch (e) {
      debugPrint('Error starting voice monitoring: $e');
    }
  }

  Future<void> stopMonitoring() async {
    if (!_isMonitoring) return;

    try {
      await _recorder.stop();
      _monitoringTimer?.cancel();
      _silenceTimer?.cancel();
      _isMonitoring = false;
      _isSilentAlertActive = false;
      debugPrint('Voice Guard monitoring stopped');
    } catch (e) {
      debugPrint('Error stopping voice monitoring: $e');
    }
  }

  void _startSilenceDetection() {
    _monitoringTimer = Timer.periodic(_monitoringInterval, (timer) async {
      if (!_isMonitoring) return;

      try {
        final amplitude = await _recorder.getAmplitude();
        final currentLevel = amplitude.current;
        
        // Broadcast audio level for UI updates
        _audioLevelController.add(currentLevel);
        
        // Check for silence
        if (currentLevel < _silenceThreshold) {
          _onSilenceDetected();
        } else {
          _onSoundDetected();
        }
      } catch (e) {
        debugPrint('Error checking audio level: $e');
      }
    });
  }

  void _onSilenceDetected() {
    if (_silenceTimer == null) {
      _silenceTimer = Timer(_silenceDuration, () {
        _triggerSilenceAlert();
      });
    }
  }

  void _onSoundDetected() {
    _silenceTimer?.cancel();
    _silenceTimer = null;
  }

  void _triggerSilenceAlert() {
    if (_isSilentAlertActive) return;
    
    _isSilentAlertActive = true;
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
    _audioLevelController.close();
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
  double _currentAudioLevel = 0.0;
  bool _showSilenceAlert = false;
  StreamSubscription<double>? _audioLevelSubscription;

  @override
  void initState() {
    super.initState();
    _audioLevelSubscription = _voiceGuard.audioLevelStream.listen((level) {
      if (mounted) {
        setState(() {
          _currentAudioLevel = level;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioLevelSubscription?.cancel();
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
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _currentAudioLevel.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: _currentAudioLevel < 0.01 ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Audio Level: ${(_currentAudioLevel * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: _currentAudioLevel < 0.01 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (_currentAudioLevel < 0.01)
                  const Text(
                    '⚠️ SILENCE',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '• Detects silence patterns used in voice cloning scams\n'
              '• Alerts after 5+ seconds of suspicious silence\n'
              '• Protects against AI voice fraud attempts',
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
