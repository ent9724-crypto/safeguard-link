import 'package:flutter/material.dart';
import 'dashboard_clean.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const DashboardClean(),
  ));
}
