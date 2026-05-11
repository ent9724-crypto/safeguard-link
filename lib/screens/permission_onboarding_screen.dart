import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/permission_onboarding_service.dart';

class PermissionOnboardingScreen extends StatefulWidget {
  final VoidCallback onCompleted;
  final bool isMalay;

  const PermissionOnboardingScreen({
    super.key,
    required this.onCompleted,
    this.isMalay = false,
  });

  @override
  State<PermissionOnboardingScreen> createState() => _PermissionOnboardingScreenState();
}

class _PermissionOnboardingScreenState extends State<PermissionOnboardingScreen> {
  int _currentStep = 0;
  bool _isLoading = false;
  Map<Permission, bool> _permissionResults = {};
  
  final List<Permission> _permissions = [
    Permission.microphone,
    Permission.phone,
    Permission.camera,
    Permission.storage,
    Permission.notification,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A5F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Progress indicator
              _buildProgressIndicator(),
              
              const SizedBox(height: 40),
              
              // Content
              Expanded(
                child: _buildContent(),
              ),
              
              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Text(
          widget.isMalay ? 'Langkah ${_currentStep + 1} dari ${_permissions.length}' : 'Step ${_currentStep + 1} of ${_permissions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: (_currentStep + 1) / _permissions.length,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final currentPermission = _permissions[_currentStep];
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: _getPermissionColor(currentPermission).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getPermissionIcon(currentPermission),
            size: 40,
            color: _getPermissionColor(currentPermission),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Title
        Text(
          PermissionOnboardingService.getPermissionTitle(currentPermission, isMalay: widget.isMalay),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        // Explanation
        Text(
          PermissionOnboardingService.getPermissionExplanation(currentPermission, isMalay: widget.isMalay),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Permission status
        if (_permissionResults.containsKey(currentPermission))
          _buildPermissionStatus(currentPermission),
      ],
    );
  }

  Widget _buildPermissionStatus(Permission permission) {
    final isGranted = _permissionResults[permission] ?? false;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGranted ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGranted ? Colors.green : Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isGranted ? Icons.check_circle : Icons.error,
            color: isGranted ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isGranted 
                ? (widget.isMalay ? 'Kebenaran diberikan' : 'Permission granted')
                : (widget.isMalay ? 'Kebenaran ditolak' : 'Permission denied'),
              style: TextStyle(
                color: isGranted ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Grant permission button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _requestPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.isMalay ? 'Berikan Kebenaran' : 'Grant Permission',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Skip/Next button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _isLoading ? null : _nextStep,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white70,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              _currentStep < _permissions.length - 1
                ? (widget.isMalay ? 'Langkau' : 'Skip')
                : (widget.isMalay ? 'Selesai' : 'Finish'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _requestPermission() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentPermission = _permissions[_currentStep];
      final status = await currentPermission.request();
      
      setState(() {
        _permissionResults[currentPermission] = status.isGranted;
        _isLoading = false;
      });

      // Auto-advance after a short delay if permission was granted
      if (status.isGranted) {
        await Future.delayed(const Duration(seconds: 1));
        _nextStep();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isMalay ? 'Ralat meminta kebenaran' : 'Error requesting permission',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _permissions.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeOnboarding();
    }
  }

  void _completeOnboarding() async {
    await PermissionOnboardingService.markOnboardingCompleted();
    widget.onCompleted();
  }

  IconData _getPermissionIcon(Permission permission) {
    switch (permission) {
      case Permission.microphone:
        return Icons.mic;
      case Permission.phone:
        return Icons.phone;
      case Permission.camera:
        return Icons.camera_alt;
      case Permission.storage:
        return Icons.storage;
      case Permission.notification:
        return Icons.notifications;
      default:
        return Icons.security;
    }
  }

  Color _getPermissionColor(Permission permission) {
    switch (permission) {
      case Permission.microphone:
        return Colors.blue;
      case Permission.phone:
        return Colors.green;
      case Permission.camera:
        return Colors.purple;
      case Permission.storage:
        return Colors.orange;
      case Permission.notification:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
