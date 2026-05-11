import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafetyPauseWidget extends StatefulWidget {
  final String actionTitle;
  final String actionDescription;
  final VoidCallback onProceed;
  final VoidCallback onCancel;

  const SafetyPauseWidget({
    super.key,
    required this.actionTitle,
    required this.actionDescription,
    required this.onProceed,
    required this.onCancel,
  });

  @override
  State<SafetyPauseWidget> createState() => _SafetyPauseWidgetState();
}

class _SafetyPauseWidgetState extends State<SafetyPauseWidget> with TickerProviderStateMixin {
  static const int countdownSeconds = 60; // 1 minute for testing
  int _remainingSeconds = countdownSeconds;
  bool _canProceed = false;
  late Timer _countdownTimer;
  late AnimationController _tipAnimationController;
  late AnimationController _pulseAnimationController;
  int _currentTipIndex = 0;
  
  final List<String> _safetyTips = [
    'Did you hear a Family Safe Word?',
    'Official banks will never ask for your PIN',
    'Verify the recipient\'s identity before transferring',
    'Scammers create urgency to rush your decisions',
    'Call the official bank hotline to confirm transfers',
    'Never share OTP codes with anyone',
    'Government agencies don\'t request payments via WhatsApp',
    'Check for spelling errors in sender names',
    'Real banks use secure domains (bankname.com.my)',
    'Pause and think: Is this request normal?',
  ];

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _startTipRotation();
    _startPulseAnimation();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    _tipAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _canProceed = true;
          timer.cancel();
          HapticFeedback.lightImpact();
        }
      });
    });
  }

  void _startTipRotation() {
    _tipAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _tipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentTipIndex = (_currentTipIndex + 1) % _safetyTips.length;
        });
        _tipAnimationController.reset();
        _tipAnimationController.forward();
      }
    });
    
    _tipAnimationController.forward();
  }

  void _startPulseAnimation() {
    _pulseAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimationController.repeat(reverse: true);
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade300, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.red.shade700,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SAFETY PAUSE',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.actionTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Action Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You are about to:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.actionDescription,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Countdown Timer
              AnimatedBuilder(
                animation: _pulseAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimationController.value * 0.1),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _canProceed ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _canProceed ? Colors.green.shade300 : Colors.orange.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _canProceed ? 'READY TO PROCEED' : 'SAFETY COUNTDOWN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _canProceed ? Colors.green.shade700 : Colors.orange.shade700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _formatTime(_remainingSeconds),
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: _canProceed ? Colors.green.shade700 : Colors.orange.shade700,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Rotating Safety Tips
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 1),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 24),
                        const SizedBox(width: 12),
                        const Text(
                          'Safety Tip:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _safetyTips[_currentTipIndex],
                        key: ValueKey(_currentTipIndex),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Action Buttons
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _canProceed ? widget.onProceed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed ? Colors.green : Colors.grey,
                        foregroundColor: Colors.white,
                        elevation: _canProceed ? 8 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _canProceed ? Icons.check_circle : Icons.lock,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _canProceed ? 'PROCEED' : 'WAIT ${_formatTime(_remainingSeconds)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: widget.onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        side: BorderSide(color: Colors.red.shade300, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to show Safety Pause
Future<void> showSafetyPause({
  required BuildContext context,
  required String actionTitle,
  required String actionDescription,
  required VoidCallback onProceed,
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: SafetyPauseWidget(
        actionTitle: actionTitle,
        actionDescription: actionDescription,
        onProceed: () {
          Navigator.pop(context);
          onProceed();
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
