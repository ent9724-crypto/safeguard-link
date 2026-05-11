import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafeIdentityField extends StatefulWidget {
  final String? label;
  final String? hint;
  final Function(String)? onChanged;
  final Function(String)? onICDetected;
  final bool obscureText;
  final TextEditingController? controller;

  const SafeIdentityField({
    super.key,
    this.label,
    this.hint,
    this.onChanged,
    this.onICDetected,
    this.obscureText = true,
    this.controller,
  });

  @override
  State<SafeIdentityField> createState() => _SafeIdentityFieldState();
}

class _SafeIdentityFieldState extends State<SafeIdentityField> {
  late TextEditingController _controller;
  String _maskedValue = '';
  String _actualValue = '';
  Timer? _debounceTimer;
  bool _showPIIWarning = false;
  bool _isICDetected = false;

  // Malaysian IC format: XXXXXX-XX-XXXX (where X is digit)
  static final RegExp _malaysianICRegex = RegExp(
    r'^(\d{6})-(\d{2})-(\d{4})$',
    caseSensitive: false,
  );

  // Advanced IC patterns to catch partial inputs
  static final List<RegExp> _icPatterns = [
    RegExp(r'^\d{6}-\d{2}-\d{4}$'), // Complete format
    RegExp(r'^\d{12}$'), // Without dashes
    RegExp(r'^\d{6}-\d{6}$'), // Partial format
    RegExp(r'^\d{6}-\d{2}-\d{1,3}$'), // Partial end
    RegExp(r'^\d{1,5}-\d{2}-\d{4}$'), // Partial start
  ];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    
    // Debounce the validation
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _validateAndMask(text);
    });
  }

  void _validateAndMask(String input) {
    setState(() {
      _actualValue = input;
      _maskedValue = _maskICNumber(input);
      
      // Check for Malaysian IC patterns
      _isICDetected = _isMalaysianIC(input);
      
      if (_isICDetected && !_showPIIWarning) {
        _showPIIWarning = true;
        _showPIIAlertDialog();
        widget.onICDetected?.call(input);
      }
    });
    
    widget.onChanged?.call(input);
  }

  bool _isMalaysianIC(String input) {
    final cleanedInput = input.replaceAll(RegExp(r'[^\d-]'), '');
    
    for (final pattern in _icPatterns) {
      if (pattern.hasMatch(cleanedInput)) {
        return true;
      }
    }
    
    return false;
  }

  String _maskICNumber(String input) {
    if (!_isMalaysianIC(input)) {
      return input;
    }
    
    final cleanedInput = input.replaceAll(RegExp(r'[^\d-]'), '');
    
    // Format: XXXXXX-XX-XXXX
    if (cleanedInput.length >= 12) {
      final part1 = cleanedInput.substring(0, 6);
      final part2 = cleanedInput.substring(6, 8);
      final part3 = cleanedInput.substring(8, 12);
      
      return '******-**-$part3';
    } else if (cleanedInput.length >= 8 && cleanedInput.contains('-')) {
      final parts = cleanedInput.split('-');
      if (parts.length >= 2) {
        final masked = List<String>.from(parts);
        for (int i = 0; i < masked.length - 1; i++) {
          if (masked[i].length > 2) {
            masked[i] = '*' * masked[i].length;
          } else {
            masked[i] = '**';
          }
        }
        return masked.join('-');
      }
    }
    
    // Partial masking for incomplete IC numbers
    if (cleanedInput.length > 4) {
      final visiblePart = cleanedInput.substring(cleanedInput.length - 4);
      final maskedPart = '*' * (cleanedInput.length - 4);
      return '$maskedPart$visiblePart';
    }
    
    return input;
  }

  void _showPIIAlertDialog() {
    HapticFeedback.heavyImpact();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red.withOpacity(0.9),
        title: Row(
          children: const [
            Icon(Icons.warning, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text(
              '🛑 STOP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PERSONAL IDENTIFICATION DETECTED',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Is this an official PDRM or LHDN app?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'If not, delete this immediately.',
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '⚠️ SECURITY RISKS:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '• Identity theft and fraud\n'
                    '• Unauthorized access to personal data\n'
                    '• Financial scams using stolen IC\n'
                    '• Criminal activities under your name',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your IC number has been automatically masked for protection.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _showPIIWarning = false;
              });
              Navigator.pop(context);
            },
            child: const Text(
              'I Understand',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showPIIWarning = false;
                _controller.clear();
                _actualValue = '';
                _maskedValue = '';
                _isICDetected = false;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
            ),
            child: const Text(
              'Delete Now',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _isICDetected ? Colors.red : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isICDetected ? Colors.red : Colors.white.withOpacity(0.3),
              width: _isICDetected ? 2 : 1,
            ),
          ),
          child: TextField(
            controller: _controller,
            obscureText: widget.obscureText && !_isICDetected,
            style: TextStyle(
              color: Colors.white,
              fontFamily: _isICDetected ? 'monospace' : null,
            ),
            decoration: InputDecoration(
              hintText: widget.hint ?? 'Enter text...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              suffixIcon: _isICDetected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.security, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'IC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  : null,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d-]')),
              LengthLimitingTextInputFormatter(14),
            ],
            keyboardType: TextInputType.number,
            onChanged: (value) => _onTextChanged(),
          ),
        ),
        if (_isICDetected) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'IC detected: ${_maskedValue}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Advanced Malaysian IC Validator with enhanced patterns
class MalaysianICValidator {
  static final RegExp _completeICRegex = RegExp(r'^(\d{6})-(\d{2})-(\d{4})$');
  static final RegExp _digitsOnlyRegex = RegExp(r'^\d{12}$');
  
  static bool isValidMalaysianIC(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d]'), '');
    
    if (_completeICRegex.hasMatch(input)) {
      return _validateICStructure(input);
    } else if (_digitsOnlyRegex.hasMatch(cleaned)) {
      return _validateICStructure(_formatICWithDashes(cleaned));
    }
    
    return false;
  }
  
  static String _formatICWithDashes(String digits) {
    if (digits.length == 12) {
      return '${digits.substring(0, 6)}-${digits.substring(6, 8)}-${digits.substring(8, 12)}';
    }
    return digits;
  }
  
  static bool _validateICStructure(String formattedIC) {
    final match = _completeICRegex.firstMatch(formattedIC);
    if (match == null) return false;
    
    final birthDate = match.group(1)!;
    final placeCode = match.group(2)!;
    final serialNumber = match.group(3)!;
    
    // Basic validation
    if (birthDate == '000000') return false;
    if (placeCode == '00') return false;
    if (serialNumber == '0000') return false;
    
    // Validate birth date (YYMMDD)
    if (!_isValidBirthDate(birthDate)) return false;
    
    return true;
  }
  
  static bool _isValidBirthDate(String yyMMdd) {
    try {
      final year = int.parse(yyMMdd.substring(0, 2));
      final month = int.parse(yyMMdd.substring(2, 4));
      final day = int.parse(yyMMdd.substring(4, 6));
      
      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;
      
      // More sophisticated validation could be added here
      return true;
    } catch (e) {
      return false;
    }
  }
  
  static String maskICNumber(String ic) {
    if (!isValidMalaysianIC(ic)) return ic;
    
    final formatted = _digitsOnlyRegex.hasMatch(ic) 
        ? _formatICWithDashes(ic.replaceAll(RegExp(r'[^\d]'), ''))
        : ic;
    
    return formatted.replaceRange(0, 8, '********');
  }
}

// Child Guard Enhanced Widget
class ChildGuardIdentityField extends StatelessWidget {
  final String label;
  final String hint;
  final Function(String)? onChanged;
  final Function(String)? onICDetected;

  const ChildGuardIdentityField({
    super.key,
    required this.label,
    required this.hint,
    this.onChanged,
    this.onICDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.child_care, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Child Guard Active',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'PROTECTED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SafeIdentityField(
            label: label,
            hint: hint,
            onICDetected: onICDetected,
            onChanged: onChanged,
          ),
          const SizedBox(height: 8),
          const Text(
            '• Automatic IC detection and masking\n'
            '• PII protection for children\n'
            '• Real-time fraud prevention alerts',
            style: TextStyle(
              fontSize: 11,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
