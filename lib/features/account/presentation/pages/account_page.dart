import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/index.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../../auth/controller/auth_state.dart';
import './account_screen.dart';

/// Account page that serves as the navigation destination for the account tab
class AccountPage extends ConsumerWidget {
  /// Creates a new account page
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    // If authenticated, show account screen
    if (authState is AuthAuthenticatedState) {
      return const AccountScreen();
    }

    // Otherwise redirect to login
    return _buildLoginRedirect(context);
  }

  Widget _buildLoginRedirect(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.accountTitle), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  loc.accountSignIn,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    loc.accountSignInMsg,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  icon: const Icon(Icons.login),
                  label: Text(loc.loginButton),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    minimumSize: const Size(200, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
