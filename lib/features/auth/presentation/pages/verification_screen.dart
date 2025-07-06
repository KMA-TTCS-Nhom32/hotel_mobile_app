import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/index.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/logger.dart';
import '../widgets/language_selector.dart';
import '../../controller/auth_controller.dart';
import '../../domain/entities/verification_data.dart';
import '../pages/login_screen.dart';

/// Screen for OTP verification following registration
class VerificationScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = '/verification';

  /// User ID passed from registration screen
  final String userId;

  /// Whether we're verifying an email (true) or phone (false)
  final bool isEmail;

  /// The email or phone number being verified
  final String identifier;

  /// Creates a verification screen
  const VerificationScreen({
    super.key,
    required this.userId,
    required this.isEmail,
    required this.identifier,
  });

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6, // Changed from 4 to 6 for 6-digit OTP
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6, // Changed from 4 to 6 for 6-digit OTP
    (index) => FocusNode(),
  );

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _code {
    return _controllers.map((c) => c.text).join();
  }

  bool get _isCodeComplete {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  Future<void> _verifyCode() async {
    final loc = AppLocalizations.of(context)!;

    if (!_isCodeComplete) {
      setState(() {
        _errorMessage = loc.verificationIncomplete;
      });
      return;
    }

    final code = _code;
    final logger = AppLogger();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final verificationData = VerificationData(
        userId: widget.userId,
        code: code,
        isEmail: widget.isEmail,
      );

      logger.d(
        'Submitting verification for ${widget.isEmail ? "email" : "phone"}: ${widget.identifier}',
      );
      logger.d('User ID: ${widget.userId}, Code: $code');

      final response = await ref
          .read(authControllerProvider.notifier)
          .verifyUser(verificationData);

      logger.d(
        'Verification response: success=${response.success}, message=${response.message}',
      );

      if (response.success) {
        // Show success message and navigate to login
        if (mounted) {
          // Show the success message from the server if available, otherwise use the default
          String successMessage = response.message ?? loc.verificationSuccess;
          logger.d('Showing success message: $successMessage');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to login screen after a brief delay to ensure the user sees the success message
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            }
          });
        }
      } else {
        logger.w('Verification failed: ${response.message}');
        setState(() {
          _errorMessage = response.message ?? loc.verificationFailed;
        });
      }
    } catch (e) {
      logger.e('Exception during verification', e);
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.verificationTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            // Title and instructions
            Text(
              widget.isEmail
                  ? loc.verificationEmailHeader
                  : loc.verificationPhoneHeader,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              loc.verificationSentTo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.identifier,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 24),

            // OTP input fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6, // Changed from 4 to 6 for 6-digit OTP
                  (index) => _buildDigitInput(index),
                ),
              ),
            ),

            // Error message if any
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 32),

            // Verify button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          loc.verificationButton,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),

            const SizedBox(height: 24),

            // Note about completing verification
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      loc.verificationInfo,
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitInput(int index) {
    return SizedBox(
      width: 45, // Smaller width for 6 digits to fit
      height: 55,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.neutralVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          // When a digit is entered, move to next field
          if (value.isNotEmpty && index < 5) {
            // Changed from 3 to 5 for 6-digit OTP
            _focusNodes[index + 1].requestFocus();
          }

          // Check if code is complete for auto-verification
          if (_isCodeComplete) {
            // Optionally auto-submit when code is complete
          }

          setState(() {
            _errorMessage = null;
          });
        },
      ),
    );
  }
}
