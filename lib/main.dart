import 'package:flutter/material.dart';
import 'package:safeguard_sandbox/dashboard_fixed.dart';
import 'package:safeguard_sandbox/vault.dart';
import 'package:safeguard_sandbox/reporting.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
    home: const DashboardFixed(),
  ));
}
