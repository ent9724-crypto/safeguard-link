import 'package:flutter/material.dart';

class ScamTips extends StatelessWidget {
  const ScamTips({super.key});

  static const List<Map<String, dynamic>> _tips = [
    {
      'title': 'Verify Caller Identity',
      'icon': Icons.verified_user,
      'color': Colors.blue,
      'description': 'Always verify who you are talking to before sharing personal information.',
      'warning': 'Scammers pose as government officials, bank staff, or family.',
    },
    {
      'title': 'Government Agencies Never Ask for Money',
      'icon': Icons.account_balance,
      'color': Colors.red,
      'description': 'Real government agencies will never ask you to transfer money immediately.',
      'warning': 'KWSP, LHDN, PDRM, and other agencies do not request urgent payments.',
    },
    {
      'title': 'Check URLs Manually',
      'icon': Icons.link,
      'color': Colors.orange,
      'description': 'Type website URLs directly instead of clicking links in messages.',
      'warning': 'Scammers use fake websites that look real to steal your data.',
    },
    {
      'title': 'Use Official Reporting Channels',
      'icon': Icons.gpp_good,
      'color': Colors.green,
      'description': 'Report scams through official channels like 997 or JanganKenaScam.',
      'warning': 'Do not share evidence with unofficial groups or individuals.',
    },
    {
      'title': 'Protect Personal Information',
      'icon': Icons.lock,
      'color': Colors.purple,
      'description': 'Never share IC numbers, bank details, passwords, or OTP codes.',
      'warning': 'Your personal data can be used to steal your identity and money.',
    },
    {
      'title': 'Question Urgency',
      'icon': Icons.timer,
      'color': Colors.amber,
      'description': 'Scammers create fake urgency to make you act without thinking.',
      'warning': 'Take time to verify. Real emergencies allow proper verification.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: const Text(
          'Scam Protection Tips',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lightbulb,
                    color: Colors.green,
                    size: 48,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '🛡️ Stay Safe from Scams',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Learn to recognize and avoid common scam tactics',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Tips List
            Expanded(
              child: ListView.builder(
                itemCount: _tips.length,
                itemBuilder: (context, index) {
                  final tip = _tips[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
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
                                  style: const TextStyle(
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
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (tip['color'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (tip['color'] as Color).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: tip['color'] as Color,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tip['warning'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: tip['color'] as Color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Emergency Contact
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.phone_in_talk,
                    color: Colors.red,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Need Immediate Help?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Call 997 - National Scam Response Centre',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
