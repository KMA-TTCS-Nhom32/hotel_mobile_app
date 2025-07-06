import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/index.dart';
import '../../../../core/localization/validator_messages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/logo_widgets.dart';
import '../../controller/auth_controller.dart';
import '../../domain/entities/registration_data.dart';

/// Widget for the registration form
class RegistrationForm extends ConsumerStatefulWidget {
  final bool isLoading;
  final void Function(RegistrationData data) onRegister;
  final String? errorMessage;

  const RegistrationForm({
    super.key,
    required this.isLoading,
    required this.onRegister,
    this.errorMessage,
  });

  @override
  ConsumerState<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends ConsumerState<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Determines if input is email or phone
  bool isEmail = true;

  @override
  void dispose() {
    _nameController.dispose();
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
          // App logo at the top
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                children: [
                  const LargeLogo(height: 80),
                  const SizedBox(height: 16),
                  Text(
                    loc.registerTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Error message display (if any)
                  if (widget.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight.withAlpha(
                          (0.1 * 255).toInt(),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.errorLight.withAlpha(
                            (0.3 * 255).toInt(),
                          ),
                        ),
                      ),
                      child: Text(
                        widget.errorMessage!,
                        style: TextStyle(color: AppColors.errorLight),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    loc.registerSubtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Name field
          _buildNameField(loc),
          const SizedBox(height: 16),

          // Email/Phone field with toggle
          _buildEmailPhoneField(loc),
          const SizedBox(height: 16),

          // Password field
          _buildPasswordField(loc),
          const SizedBox(height: 24),

          // Register button
          _buildRegisterButton(loc),

          // Privacy policy notice
          const SizedBox(height: 16),
          Text(
            loc.registerTerms,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(AppLocalizations loc) {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: loc.registerFullName,
        hintText: loc.registerFullName,
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return loc.validationRequired;
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters.';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      enabled: !widget.isLoading,
    );
  }

  Widget _buildEmailPhoneField(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _emailOrPhoneController,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.phone,
          decoration: InputDecoration(
            labelText: isEmail ? loc.registerEmail : loc.registerPhone,
            hintText: isEmail ? loc.registerEmail : loc.registerPhone,
            prefixIcon: Icon(
              isEmail ? Icons.email_outlined : Icons.phone_outlined,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isEmail ? Icons.phone_outlined : Icons.email_outlined,
                color: AppColors.neutralDark,
              ),
              onPressed: () {
                setState(() {
                  isEmail = !isEmail;
                  _emailOrPhoneController.clear();
                });
              },
              tooltip: isEmail ? 'Switch to phone' : 'Switch to email',
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
          validator: (value) => _validateEmailOrPhone(value, loc),
          textInputAction: TextInputAction.next,
          enabled: !widget.isLoading,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6.0, left: 8.0),
          child: Text(
            isEmail ? loc.registerUsePhone : loc.registerUseEmail,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(AppLocalizations loc) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: loc.registerPassword,
        hintText: loc.registerPassword,
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

  Widget _buildRegisterButton(AppLocalizations loc) {
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
                  loc.registerButton,
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
      return loc.validationEmptyEmail;
    }

    if (isEmail) {
      // Email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return loc.validationEmailPhone;
      }
    } else {
      // Phone validation
      final phoneRegex = RegExp(r'^\+?[0-9]{10,12}$');
      if (!phoneRegex.hasMatch(value)) {
        return loc.validationPhone;
      }
    }
    return null;
  }

  String? _validatePassword(String? value, AppLocalizations loc) {
    if (value == null || value.isEmpty) {
      return loc.validationEmptyPassword;
    }

    // Enhanced password validation with minimum 8 chars,
    // at least 1 uppercase, 1 lowercase, 1 number and 1 special char
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return loc.validationPassword;
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final registrationData = RegistrationData(
        name: _nameController.text,
        password: _passwordController.text,
        identifier: isEmail ? _emailOrPhoneController.text : null,
        phone: isEmail ? null : _emailOrPhoneController.text,
        isEmail: isEmail,
      );

      widget.onRegister(registrationData);
    }
  }
}
