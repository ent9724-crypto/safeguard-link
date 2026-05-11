import 'package:flutter/material.dart';
import 'dashboard_minimal.dart';

void main() {
  // Test with minimal dashboard
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const DashboardMinimal(),
  ));
}
