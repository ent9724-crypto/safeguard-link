import 'package:flutter/material.dart';

class NsrcReportScreen extends StatefulWidget {
  const NsrcReportScreen({super.key});

  @override
  State<NsrcReportScreen> createState() => _NsrcReportScreenState();
}

class _NsrcReportScreenState extends State<NsrcReportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _selectedScamType = 'Financial Scam';
  bool _isSubmitting = false;

  final List<String> _scamTypes = [
    'Financial Scam',
    'Phone Scam',
    'SMS Scam',
    'Online Shopping Scam',
    'Investment Scam',
    'Job Scam',
    'Love Scam',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      appBar: AppBar(
        title: const Text(
          'NSRC Report',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.report_problem,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Report to NSRC',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'National Scam Response Centre',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Report Form
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tell the Officer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Name Field
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Your Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone Field
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Scam Type Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedScamType,
                      decoration: const InputDecoration(
                        labelText: 'Type of Scam',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.category),
                      ),
                      items: _scamTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedScamType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Details Field
                    TextField(
                      controller: _detailsController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Tell us what happened',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                        helperText: 'Please include as much detail as possible',
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Submit Report',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Emergency Contact
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.priority_high,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Emergency Contact',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Call 997 for immediate assistance',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Use the 997 button on the main dashboard')),
                        );
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call 997'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
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

  void _submitReport() {
    if (_nameController.text.isEmpty || 
        _phoneController.text.isEmpty || 
        _detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate submission
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSubmitting = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Report Submitted'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 48,
              ),
              SizedBox(height: 10),
              Text(
                'Thank you for your report!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                'NSRC officers will review your case and contact you if needed.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to dashboard
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}
