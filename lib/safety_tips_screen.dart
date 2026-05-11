import 'package:flutter/material.dart';

class SafetyTipsScreen extends StatefulWidget {
  const SafetyTipsScreen({super.key});

  @override
  State<SafetyTipsScreen> createState() => _SafetyTipsScreenState();
}

class _SafetyTipsScreenState extends State<SafetyTipsScreen> {
  final List<Map<String, String>> _tips = [
    {
      'title': 'Verify Before Trust',
      'icon': Icons.verified_user,
      'description': 'Always verify the identity of callers before sharing personal information.',
      'color': Colors.blue,
    },
    {
      'title': 'Government Agencies Don\'t Ask for Money',
      'icon': Icons.account_balance,
      'description': 'Real government agencies will never ask you to transfer money or provide bank details over the phone.',
      'color': Colors.red,
    },
    {
      'title': 'Check URLs Manually',
      'icon': Icons.link,
      'description': 'Don\'t click on suspicious links. Type the URL directly into your browser to check.',
      'color': Colors.orange,
    },
    {
      'title': 'Use Official Channels',
      'icon': Icons.verified,
      'description': 'Report scams through official channels like 997 or JanganKenaScam.com.',
      'color': Colors.green,
    },
    {
      'title': 'Protect Your Personal Data',
      'icon': Icons.lock,
      'description': 'Never share your IC number, bank details, or passwords with unknown parties.',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: const Text(
          'Panduan Keselamatan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              '🛡️ Panduan Keselamatan (Safety Guide)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Tips Grid
            ..._tips.map((tip) => Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          tip['icon'] as IconData,
                          color: tip['color'] as Color,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tip['title'] as String,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tip['description'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
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
}
