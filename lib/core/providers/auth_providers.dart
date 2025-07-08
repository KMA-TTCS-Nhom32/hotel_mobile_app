import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../services/auth_interceptor.dart';

/// Provider for handling authentication refresh failures
final authRefreshFailureProvider = Provider<VoidCallback>((ref) {
  return () {
    // Force logout and redirect to login screen
    ref.read(authControllerProvider.notifier).logout();
  };
});
