import 'package:flutter/material.dart';

import '../../../../core/localization/index.dart';
import '../../../../core/localization/validator_messages.dart';
import '../../../../core/theme/app_colors.dart';

/// Widget for the login form
class LoginForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String emailOrPhone, String password) onLogin;

  const LoginForm({super.key, required this.isLoading, required this.onLogin});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get localized strings
    final loc = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Email/Phone field
          _buildEmailPhoneField(loc),
          const SizedBox(height: 16),
          // Password field
          _buildPasswordField(loc),
          const SizedBox(height: 24),
          // Login button
          _buildLoginButton(loc),
        ],
      ),
    );
  }

  Widget _buildEmailPhoneField(AppLocalizations loc) {
    return TextFormField(
      controller: _emailOrPhoneController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: loc.loginEmailPhonePlaceholder,
        hintText: loc.loginEmailPhonePlaceholder,
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neutralVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
      ),
      validator: (value) => _validateEmailOrPhone(value, loc),
      textInputAction: TextInputAction.next,
      enabled: !widget.isLoading,
    );
  }

  Widget _buildPasswordField(AppLocalizations loc) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: loc.loginPasswordPlaceholder,
        hintText: loc.loginPasswordPlaceholder,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: AppColors.neutralDark,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.neutralVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        ),
      ),
      validator: (value) => _validatePassword(value, loc),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submitForm(),
      enabled: !widget.isLoading,
    );
  }

  Widget _buildLoginButton(AppLocalizations loc) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 2,
        ),
        child:
            widget.isLoading
                ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                : Text(
                  loc.loginButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  String? _validateEmailOrPhone(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.getEmptyEmailPhoneMessage();
    }

    // Check if it's an email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // Check if it's a phone number (simple validation)
    final phoneRegex = RegExp(r'^\+?[0-9]{10,12}$');

    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return loc.getInvalidEmailPhoneMessage();
    }
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.getEmptyPasswordMessage();
    }

    // Enhanced password validation with minimum 8 chars,
    // at least 1 uppercase, 1 lowercase, 1 number and 1 special char
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return loc.getInvalidPasswordMessage();
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onLogin(_emailOrPhoneController.text, _passwordController.text);
    }
  }
}
