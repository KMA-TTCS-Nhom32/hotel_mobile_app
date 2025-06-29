import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/index.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/logo_widgets.dart';
import '../../controller/auth_controller.dart';
import '../../controller/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/language_selector.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

/// Screen for user login
class LoginScreen extends ConsumerStatefulWidget {
  /// Route name for navigation
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoadingState;
    // Get localized strings
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: LogoAppBar(
        title: '',
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, loc),
                const SizedBox(height: 40),
                // Display error message if authentication fails
                if (authState is AuthErrorState)
                  _buildErrorMessage(authState.message),
                const SizedBox(height: 24),
                // Login form
                LoginForm(isLoading: isLoading, onLogin: _handleLogin),
                const SizedBox(height: 16),
                // Forgot password link
                _buildForgotPasswordLink(context, loc),
                const SizedBox(height: 32),
                // Register link
                _buildRegisterLink(context, loc),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc) {
    return Column(
      children: [
        const LargeLogo(height: 80),
        const SizedBox(height: 16),
        Text(
          loc.loginWelcome,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          loc.loginSubtitle,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondaryLight),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    final loc = AppLocalizations.of(context)!;

    // Try to map error messages to localized versions
    String localizedMessage = message;
    if (message.contains('Invalid email/phone or password')) {
      localizedMessage = loc.loginInvalidCredentials;
    } else if (message.contains('Network error') ||
        message.contains('connection')) {
      localizedMessage = loc.loginNetworkError;
    } else if (message.contains('Login failed')) {
      localizedMessage = loc.loginGenericError;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorLight.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.errorLight.withAlpha((0.3 * 255).toInt()),
        ),
      ),
      child: Text(
        localizedMessage,
        style: TextStyle(color: AppColors.errorLight),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context, AppLocalizations loc) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _navigateToForgotPassword,
        child: Text(
          loc.loginForgotPassword,
          style: TextStyle(
            color: AppColors.secondaryLight,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context, AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          loc.loginNoAccount,
          style: TextStyle(color: AppColors.textSecondaryLight),
        ),
        TextButton(
          onPressed: _navigateToRegister,
          child: Text(
            loc.loginSignUp,
            style: TextStyle(
              color: AppColors.primaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin(String emailOrPhone, String password) {
    ref.read(authControllerProvider.notifier).login(emailOrPhone, password);
  }

  void _navigateToForgotPassword() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()));
  }

  void _navigateToRegister() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
  }
}
