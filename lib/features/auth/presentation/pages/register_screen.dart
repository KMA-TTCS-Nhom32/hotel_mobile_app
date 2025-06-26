import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Screen for user registration (placeholder)
class RegisterScreen extends StatelessWidget {
  /// Route name for navigation
  static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Icon(
              Icons.app_registration,
              size: 80,
              color: AppColors.primaryLight,
            ),
            const SizedBox(height: 24),
            Text(
              'Join AHomeVilla Hotel',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your account to enjoy exclusive benefits and personalized service',
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
        // Name
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.person_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Email
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Phone
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: const Icon(Icons.phone_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        // Password
        TextField(
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 32),
        // Register button
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Registration feature coming soon!'),
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
              'Create Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Privacy policy note
        Text(
          'By creating an account, you agree to our Terms of Service and Privacy Policy',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
        ),
      ],
    );
  }
}
