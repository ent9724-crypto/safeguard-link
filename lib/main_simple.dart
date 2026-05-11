import 'package:flutter/material.dart';
import 'dashboard_clean.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Safeguard Link',
    home: Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Safeguard Link - Test'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              'App is Loading...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'If you see this, the basic Flutter app works',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    ),
  ));
}
