import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveScamTickerWidget extends StatefulWidget {
  const LiveScamTickerWidget({super.key});

  @override
  State<LiveScamTickerWidget> createState() => _LiveScamTickerWidgetState();
}

class _LiveScamTickerWidgetState extends State<LiveScamTickerWidget> with TickerProviderStateMixin {
  static const Color alertRed = Color(0xFFB71C1C);
  
  final List<String> _scamAlerts = [
    '⚠️ EPF ALERT: Beware of fake WhatsApp messages claiming "Emergency Account 3" withdrawal fees. KWSP never asks for upfront payment.',
    '⚠️ INVESTMENT WARNING: WhatsApp groups promising "Syariah-compliant" 300% returns are 100% scams. Verify on BNM Consumer Alert List.',
    '⚠️ TAX REFUND SCAM: Fake LHDN emails are circulating. Do not click links to "Claim your 2025 tax refund." Log in only via official MyTax portal.',
  ];
  
  int _currentAlertIndex = 0;
  late AnimationController _scrollController;
  late Animation<double> _scrollAnimation;
  Timer? _alertRotationTimer;
  Timer? _scrollTimer;
  double _scrollPosition = 0.0;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _initializeScrolling();
    _startAlertRotation();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _alertRotationTimer?.cancel();
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _initializeScrolling() {
    _scrollController = AnimationController(
      duration: const Duration(seconds: 15), // Slow scroll for readability
      vsync: this,
    );

    _scrollAnimation = Tween<double>(
      begin: 0.0,
      end: -1.0,
    ).animate(CurvedAnimation(
      parent: _scrollController,
      curve: Curves.linear,
    ));

    _scrollAnimation.addListener(() {
      setState(() {
        _scrollPosition = _scrollAnimation.value * 800; // Update position based on animation
      });
    });

    _scrollAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scrollController.reset();
        _startScrolling();
      }
    });

    // Start scrolling after a brief delay
    Timer(const Duration(seconds: 2), () {
      _startScrolling();
    });
  }

  void _startScrolling() {
    if (!_isScrolling) {
      _isScrolling = true;
      _scrollController.forward();
    }
  }

  void _startAlertRotation() {
    _alertRotationTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      setState(() {
        _currentAlertIndex = (_currentAlertIndex + 1) % _scamAlerts.length;
        _scrollController.reset();
        _isScrolling = false;
        
        // Restart scrolling after brief pause
        Timer(const Duration(seconds: 2), () {
          _startScrolling();
        });
      });
    });
  }

  void _showNSRCDialog() {
    HapticFeedback.lightImpact();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: alertRed,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text(
              'NSRC Live Alert',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'This is a live alert from the National Scam Response Centre (NSRC). Would you like to read the full warning on JanganKenaScam.com?',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _launchJanganKenaScam();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: alertRed,
            ),
            child: const Text(
              'Read Full Warning',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchJanganKenaScam() async {
    final Uri url = Uri.parse('https://www.jangankenascam.com');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open JanganKenaScam.com'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening website: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: alertRed,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: alertRed.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showNSRCDialog,
          borderRadius: BorderRadius.circular(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: AnimatedBuilder(
              animation: _scrollAnimation,
              builder: (context, child) {
                return Stack(
                  children: [
                    // First instance of text (scrolling)
                    Positioned(
                      left: _scrollPosition,
                      top: 0,
                      bottom: 0,
                      child: _buildAlertText(),
                    ),
                    // Second instance of text (for seamless loop)
                    Positioned(
                      left: _scrollPosition + 800, // Offset for seamless loop
                      top: 0,
                      bottom: 0,
                      child: _buildAlertText(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertText() {
    return GestureDetector(
      onTap: _showNSRCDialog,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.priority_high,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _scamAlerts[_currentAlertIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
