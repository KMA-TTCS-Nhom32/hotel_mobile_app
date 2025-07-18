import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/index.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/logo_widgets.dart';
import '../widgets/language_selector.dart';
import '../../controller/auth_controller.dart';
import '../../controller/auth_state.dart';
import '../../domain/entities/registration_data.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../pages/verification_screen.dart';
import '../widgets/registration_form.dart';

/// Screen for user registration
class RegisterScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  String _mapAuthError(AuthException error, AppLocalizations loc) {
    // If using error codes as suggested in AuthException enhancement
    switch (error.message) {
      case 'userAlreadyExists':
        return loc.registerUserExists;
      case 'NETWORK_ERROR':
        return loc.loginNetworkError;
      default:
        return error.message;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authControllerProvider, (previous, current) {
      // Handle loading state
      if (current is AuthLoadingState) {
        setState(() {
          _isLoading = true;
        });
      }
      // Handle registered state (show verification screen)
      else if (current is AuthRegistrationState) {
        setState(() {
          _isLoading = false;
        });
      }
      // Handle error state
      else if (current is AuthErrorState) {
        setState(() {
          _isLoading = false;
          _errorMessage = current.message;
        });
      }
      // Handle other states
      else {
        setState(() {
          _isLoading = false;
        });
      }
    });

    // Get localized strings
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.registerTitle),
        centerTitle: true,
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back to Login',
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: RegistrationForm(
          isLoading: _isLoading,
          errorMessage: _errorMessage,
          onRegister: _handleRegister,
        ),
      ),
    );
  }

  Future<void> _handleRegister(RegistrationData data) async {
    // Clear any previous error messages
    setState(() {
      _errorMessage = null;
    });

    try {
      final response = await ref
          .read(authControllerProvider.notifier)
          .register(data);

      if (mounted) {
        // Navigate to verification screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => VerificationScreen(
                  userId: response.id,
                  isEmail: data.isEmail,
                  identifier: data.isEmail ? data.identifier! : data.phone!,
                ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        // Display specific error message if it's an AuthException
        String errorMessage = loc.registerFailed;

        if (e is AuthException) {
          errorMessage = _mapAuthError(e, loc);
        }

        // print('Registration error in UI: $e');

        setState(() {
          _errorMessage = errorMessage;
        });
      }
    }
  }
}
