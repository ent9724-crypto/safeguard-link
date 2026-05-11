import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CleanDashboard(),
  ));
}

class CleanDashboard extends StatelessWidget {
  const CleanDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: const Text(
          'Digital Safeguard',
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
              'Welcome! Use simple safety tools or open more detailed parent controls.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            
            // Check Website Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL Scanner - Feature coming soon!')),
                  );
                },
                icon: const Icon(Icons.security_rounded),
                label: const Text('Execute URL Heuristics'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00ACC8),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(48, 48),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Parental Controls Button
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Parental Controls - Feature coming soon!')),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF7fbbdd).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF7fbbdd).withOpacity(0.15),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Color(0xFF7fbbdd),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Parental Controls',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF7fbbdd),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test Features Section
            const Text(
              'Test Features',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            
            // Test Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test Phone Alert - Feature coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.phone_callback_rounded),
                    label: const Text('Test Deepfake Warning'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      foregroundColor: Colors.purple[800],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Test Safety Pause Overlay - Feature coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.security_rounded),
                    label: const Text('Test Safety Pause Overlay'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[100],
                      foregroundColor: Colors.orange[800],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Family Safe Word Vault - Feature coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.lock_rounded),
                    label: const Text('Family Safe Word Vault'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[100],
                      foregroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Secret Vault Screen - Feature coming soon!')),
                      );
                    },
                    icon: const Icon(Icons.security_rounded),
                    label: const Text('Secret Vault Screen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100],
                      foregroundColor: Colors.purple[800],
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
}
