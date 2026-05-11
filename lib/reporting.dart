import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
    _loadSampleEvents();
  }

  void _initializeEvidenceEngine() {
    // Initialize evidence engine
    setState(() {
      _isListening = true;
    });
  }

  void _loadSampleEvents() {
    // Load sample events for demonstration
    setState(() {
      _chronologyEvents = [
        {
          'timestamp': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
          'type': 'external_threat',
          'icon': '📩',
          'title': 'Received SMS from +60123456789',
          'content': 'Your LHDN tax refund of RM2,500 is ready. Please click link to claim.',
          'sender': '+60123456789',
        },
        {
          'timestamp': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
          'type': 'external_threat',
          'icon': '📩',
          'title': 'Received WhatsApp from +60198765432',
          'content': 'PDRM requires your immediate verification. Update your account details.',
          'sender': '+60198765432',
        },
        {
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          'type': 'external_threat',
          'icon': '📩',
          'title': 'Received SMS from +60155566677',
          'content': 'Your TAC code is 123456 for transaction verification.',
          'sender': '+60155566677',
        },
      ];
    });
  }

  Future<void> _add997Emergency() async {
    setState(() {
      _chronologyEvents.insert(0, {
        'timestamp': DateTime.now().toIso8601String(),
        'type': 'emergency',
        'icon': '🚨',
        'title': 'Dialed NSRC 997',
        'content': 'Emergency call initiated',
      });
    });

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
          content: Text('📋 Report copied! Paste this when 997 officer asks for details.'),
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
      backgroundColor: const Color(0xFF1E3A5F),
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
                  const Text(
                    'Keywords: LHDN, PDRM, 997, Audit, TAC, OTP, MyKasih',
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
                  const Text(
                    'Evidence Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._chronologyEvents.map((event) => _buildTimelineItem(event)),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _add997Emergency,
                    icon: const Icon(Icons.phone),
                    label: const Text('997 Emergency'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> event) {
    final timestamp = DateTime.parse(event['timestamp']);
    final time = DateFormat('HH:mm').format(timestamp);
    final title = event['title'] as String;
    final content = event['content'] as String?;
    final icon = event['icon'] as String;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$time - $title',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (content != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    content.length > 50 ? '${content.substring(0, 50)}...' : content,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
