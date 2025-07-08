import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_screen.dart';

/// Utility class for app-wide navigation
class NavigationUtils {
  /// Navigate to login screen and clear navigation stack
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      LoginScreen.routeName,
      (route) => false, // Remove all routes
    );
  }

  /// Navigate to login screen using a navigator key (for use outside of widgets)
  static void navigateToLoginWithKey(GlobalKey<NavigatorState> navigatorKey) {
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false, // Remove all routes
      );
    }
  }
}
