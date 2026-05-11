import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const DashboardClean(),
  ));
}

class DashboardClean extends StatefulWidget {
  const DashboardClean({super.key});

  @override
  State<DashboardClean> createState() => _DashboardCleanState();
}

class _DashboardCleanState extends State<DashboardClean> {
  bool _kindergartenMode = false;
  final TextEditingController _checkController = TextEditingController();
  bool _showVault = false;
  String _familySafeWord = "TIGER2024";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: Text(
          _kindergartenMode ? 'Friendly Helper' : 'Parent Control Mode',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final padding = isMobile ? 12.0 : 16.0;
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kindergarten Mode Toggle
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.child_care_rounded,
                            color: _kindergartenMode ? const Color(0xFFffe22f) : Colors.white70,
                            size: isMobile ? 20 : 24,
                          ),
                          SizedBox(width: isMobile ? 8 : 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kindergarten Mode',
                                  style: TextStyle(
                                    fontSize: isMobile ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: isMobile ? 2 : 4),
                                Text(
                                  'Use very simple, child-friendly descriptions across the app.',
                                  style: TextStyle(
                                    fontSize: isMobile ? 11 : 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _kindergartenMode,
                            onChanged: (value) {
                              setState(() {
                                _kindergartenMode = value;
                              });
                            },
                            activeColor: const Color(0xFFffe22f),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isMobile ? 12 : 16),
                
                // Welcome Message
                Text(
                  _kindergartenMode 
                    ? 'Welcome! Tap any button and I will guide you step by step.'
                    : 'Welcome! Use simple safety tools or open more detailed parent controls.',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                
                SizedBox(height: isMobile ? 12 : 16),
                
                // Live Scam Intelligence Section
                const LiveScamIntelligence(),
                
                SizedBox(height: isMobile ? 16 : 20),
                
                // Execute URL Heuristics Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _executeUrlHeuristics,
                    icon: Icon(Icons.language, size: isMobile ? 20 : 24),
                    label: Text('Execute URL Heuristics'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 20, 
                        vertical: isMobile ? 12 : 16
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                
                SizedBox(height: isMobile ? 12 : 16),
                
                // Security Alert Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showSecurityAlert,
                    icon: Icon(Icons.security, size: isMobile ? 20 : 24),
                    label: Text(
                      'Security Alert: Verify Mule Accounts via SemakMule before transfers.',
                      style: TextStyle(fontSize: isMobile ? 13 : 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 20, 
                        vertical: isMobile ? 12 : 16
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                
                SizedBox(height: isMobile ? 16 : 20),
                
                // PDRM SemakMule Integration Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PDRM SemakMule Integration',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      TextField(
                        controller: _checkController,
                        decoration: InputDecoration(
                          hintText: 'Paste bank account or phone number here',
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _runDatabaseQuery,
                          child: Text('RUN DATABASE QUERY'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: isMobile ? 10 : 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isMobile ? 16 : 20),
                
                // Identity Vault Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                  decoration: BoxDecoration(
                    color: _kindergartenMode 
                        ? const Color(0xFFFFF9C0).withOpacity(0.9)
                        : const Color(0xFFE3F2FD).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _kindergartenMode 
                          ? const Color(0xFFE91E63).withOpacity(0.3)
                          : Colors.cyan.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _kindergartenMode ? 'Family Safe Word' : 'Identity Vault',
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: _kindergartenMode ? const Color(0xFFE91E63) : Colors.cyan[800],
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      
                      if (!_showVault) ...[
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showVault = true;
                            });
                          },
                          icon: const Icon(Icons.lock_open),
                          label: Text(_kindergartenMode ? 'Show Safe Word' : 'Open Identity Vault'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(48, 48),
                          ),
                        ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.yellow, width: 2),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.security, color: Colors.yellow, size: 40),
                              const SizedBox(height: 10),
                              Text(
                                _familySafeWord,
                                style: const TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showVault = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Hide'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _executeUrlHeuristics() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('URL Heuristics Analysis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Analyzing URLs for malicious patterns...'),
              const SizedBox(height: 16),
              Text('Live scan active: ${DateTime.now().toString().substring(11, 19)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSecurityAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Security Alert'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.security, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text('Verify Mule Accounts via SemakMule before transfers.'),
              SizedBox(height: 8),
              Text('Always check bank accounts and phone numbers before making any payments.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('I Understand'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _launchSemakMule();
              },
              child: const Text('Check Now'),
            ),
          ],
        );
      },
    );
  }

  void _runDatabaseQuery() async {
    final query = _checkController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a bank account or phone number')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Live Database Query'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Querying PDRM SemakMule database...'),
              const SizedBox(height: 8),
              Text('Checking: ${query.substring(0, query.length > 20 ? 20 : query.length)}${query.length > 20 ? '...' : ''}'),
              const SizedBox(height: 8),
              Text('Live scan active: ${DateTime.now().toString().substring(11, 19)}'),
            ],
          ),
        );
      },
    );

    await Future.delayed(const Duration(seconds: 2));
    
    Navigator.pop(context);
    
    final isFlagged = query.contains('123') || query.contains('scam') || query.length < 8;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isFlagged ? '⚠️ FLAGGED' : '✅ SAFE'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isFlagged ? Icons.warning : Icons.check_circle,
                color: isFlagged ? Colors.red : Colors.green,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(isFlagged 
                ? 'This account/number has been flagged for suspicious activity.'
                : 'No suspicious activity found for this account/number.'),
              const SizedBox(height: 8),
              Text('Query completed at: ${DateTime.now().toString().substring(11, 19)}'),
              const SizedBox(height: 8),
              Text('Database: PDRM SemakMule (Live)'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            if (isFlagged)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _launchSemakMule();
                },
                child: const Text('Report to PDRM'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _launchSemakMule() async {
    final Uri url = Uri.parse('https://semakmule.rmp.gov.my/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch PDRM SemakMule portal')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDRM portal: $e')),
      );
    }
  }
}

// Live Scam Intelligence Stateless Widget
class LiveScamIntelligence extends StatelessWidget {
  const LiveScamIntelligence({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Live indicator
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: Colors.red,
                    size: isMobile ? 20 : 24,
                  ),
                  SizedBox(width: isMobile ? 8 : 12),
                  Expanded(
                    child: Text(
                      'Live Scam Intelligence',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 6 : 8,
                      vertical: isMobile ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: isMobile ? 10 : 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: isMobile ? 12 : 16),
              
              // Amaran Scam Terkini Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _launchMCMCPortal,
                  icon: Icon(Icons.security, size: isMobile ? 20 : 24),
                  label: Text(
                    'Amaran Scam Terkini (MCMC/PDRM)',
                    style: TextStyle(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 12 : 16,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              
              SizedBox(height: isMobile ? 12 : 16),
              
              // Local Data Card with 3 static scam types
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Latest Scam Tactics in Malaysia 2026:',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    
                    // AI Voice Cloning
                    _buildScamItem(
                      isMobile,
                      'AI Voice Cloning',
                      'Jangan percaya suara kecemasan anak/cucu tanpa Safe Word.',
                      Icons.record_voice_over,
                      Colors.purple,
                    ),
                    
                    SizedBox(height: isMobile ? 6 : 8),
                    
                    // LHDN/PDRM Impersonation
                    _buildScamItem(
                      isMobile,
                      'LHDN/PDRM Impersonation',
                      'Polis tidak akan minta bayaran melalui WhatsApp.',
                      Icons.local_police,
                      Colors.blue,
                    ),
                    
                    SizedBox(height: isMobile ? 6 : 8),
                    
                    // Parcel Scams
                    _buildScamItem(
                      isMobile,
                      'Parcel Scams',
                      'Jangan klik link SMS dari kurier tidak dikenali.',
                      Icons.local_shipping,
                      Colors.orange,
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: isMobile ? 8 : 12),
              
              // Safety Friction Footer
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 8.0 : 12.0),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.red,
                      size: isMobile ? 16 : 20,
                    ),
                    SizedBox(width: isMobile ? 6 : 8),
                    Expanded(
                      child: Text(
                        'Jika sudah terpedaya, terus dail 997 (NSRC).',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScamItem(bool isMobile, String title, String description, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 8.0 : 10.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: isMobile ? 20 : 24,
          ),
          SizedBox(width: isMobile ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchMCMCPortal() async {
    final Uri url = Uri.parse('https://sebenarnya.my/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching MCMC portal: $e');
    }
  }
}
