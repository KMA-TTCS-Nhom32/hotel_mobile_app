import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/login_credentials.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Provider for the auth controller
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(ref.read(authRepositoryProvider)),
);

/// Provider for the auth repository
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) =>
      throw UnimplementedError('authRepositoryProvider must be overridden'),
);

/// Controller for authentication state
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  /// Creates an instance of AuthController
  AuthController(this._authRepository) : super(const AuthInitialState()) {
    // Check if user is already authenticated
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    try {
      final isAuthenticated = await _authRepository.isAuthenticated();
      if (isAuthenticated) {
        final token = await _authRepository.getStoredToken();
        if (token != null) {
          state = AuthAuthenticatedState(token.accessToken);
          // After confirming auth status, try to fetch user profile
          _fetchUserProfile();
          return;
        }
      }
      state = const AuthUnauthenticatedState();
    } catch (e) {
      state = const AuthUnauthenticatedState();
    }
  }

  /// Fetch current user profile
  Future<void> _fetchUserProfile() async {
    try {
      if (state is AuthAuthenticatedState) {
        final userProfile = await _authRepository.getUserProfile();
        final currentState = state as AuthAuthenticatedState;
        state = currentState.copyWith(userProfile: userProfile);
      }
    } catch (e) {
      // In case of error fetching profile, keep the current authenticated state
      // but without profile data. Do not change to error state as we're already logged in.
    }
  }

  /// Manually refresh user profile
  Future<void> refreshUserProfile() async {
    if (state is AuthAuthenticatedState) {
      await _fetchUserProfile();
    }
  }

  /// Login with email/phone and password
  Future<void> login(String emailOrPhone, String password) async {
    try {
      state = const AuthLoadingState();
      final credentials = LoginCredentials(
        emailOrPhone: emailOrPhone,
        password: password,
      );
      final token = await _authRepository.login(credentials);

      // After successful login, fetch user profile
      try {
        final userProfile = await _authRepository.getUserProfile();
        state = AuthAuthenticatedState(
          token.accessToken,
          userProfile: userProfile,
        );
      } catch (profileError) {
        // If profile fetch fails, still mark as authenticated but without profile
        state = AuthAuthenticatedState(token.accessToken);
      }
    } catch (e) {
      state = AuthErrorState(
        e is AuthException ? e.message : 'Login failed. Please try again.',
        e is Exception ? e : null,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      state = const AuthLoadingState();
      await _authRepository.logout();
      state = const AuthUnauthenticatedState();
    } catch (e) {
      // Force logout even if server request failed
      await _authRepository.clearToken();
      state = const AuthUnauthenticatedState();
    }
  }
}

/// Custom exception for auth controller errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
