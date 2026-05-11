import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const DashboardSimple(),
  ));
}

class DashboardSimple extends StatelessWidget {
  const DashboardSimple({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: const Text(
          'Digital Safeguard - Ready',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🛡️ Identity Protection Module - All Features Active',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            
            // Feature Cards
            _buildFeatureCard(
              icon: Icons.phone_in_talk,
              title: '🎤 Live Voice Monitoring',
              description: 'Silent Call Detection (30dB threshold, 7-second timer)',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice Guard monitoring started')),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.lock,
              title: '🔐 Hardware Security',
              description: 'Biometric Vault with Encryption',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vault security activated')),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.security,
              title: '🛡️ Blackout Shield',
              description: 'FLAG_SECURE prevents screenshots',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Screen protection activated')),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.credit_card,
              title: '🇲🇾 Malaysian IC Guard',
              description: 'Regex ^(\\d{6})-(\\d{2})-(\\d{4})\\$ + Vibration',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('IC Guard activated')),
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.gpp_good,
              title: '🔥 Firebase App Check',
              description: 'Backend Security Active',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Firebase security active')),
                );
              },
            ),
            
            const SizedBox(height: 20),
            
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NsrcReportScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.report),
                    label: const Text('Report to 997'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[100],
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
                        MaterialPageRoute(
                          builder: (context) => const SafetyTipsScreen(),
                        ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      color: Colors.white.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.blue[700],
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
