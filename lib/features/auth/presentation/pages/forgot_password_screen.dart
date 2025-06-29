import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Screen for password recovery (placeholder)
class ForgotPasswordScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = '/forgot-password';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Icon(Icons.lock_reset, size: 80, color: AppColors.primaryLight),
            const SizedBox(height: 24),
            Text(
              'Reset Your Password',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your email or phone number and we\'ll send you a code to reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondaryLight),
            ),
            const SizedBox(height: 32),
            // Placeholder form content
            _buildPlaceholderForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderForm(BuildContext context) {
    return Column(
      children: [
        // Email/Phone
        TextField(
          decoration: InputDecoration(
            labelText: 'Email or Phone',
            hintText: 'Enter your email or phone number',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 24),
        // Send code button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password reset feature coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Send Reset Code',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
