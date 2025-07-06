import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/login_credentials.dart';
import '../data/models/register_response_dto.dart';
import '../data/models/verify_response_dto.dart';
import '../data/repositories/auth_repository.dart';
import '../domain/entities/registration_data.dart';
import '../domain/entities/verification_data.dart';
import '../domain/exceptions/auth_exception.dart';
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

  /// Register a new user
  Future<RegisterResponseDto> register(
    RegistrationData registrationData,
  ) async {
    try {
      state = const AuthLoadingState();
      final response = await _authRepository.register(registrationData);

      // Store the response but keep the state as loading until verification is complete
      state = AuthRegistrationState(userId: response.id);

      return response;
    } catch (e) {
      state = AuthErrorState(
        e is AuthException
            ? e.message
            : 'Registration failed. Please try again.',
        e is Exception ? e : null,
      );
      rethrow;
    }
  }

  /// Verify a user's email or phone
  Future<VerifyResponseDto> verifyUser(
    VerificationData verificationData,
  ) async {
    try {
      state = const AuthLoadingState();
      final response = await _authRepository.verifyUser(verificationData);

      print(
        'Auth controller received verification response: ${response.success} - ${response.message}',
      );

      // After successful verification, set state back to unauthenticated so user can log in
      if (response.success) {
        state = const AuthUnauthenticatedState();
        // print('Setting state to unauthenticated after successful verification');
      } else {
        // print('Setting state to error after failed verification');
        state = AuthErrorState(
          'Verification failed: ${response.message ?? "Unknown error"}',
        );
      }

      return response;
    } catch (e) {
      // print('Exception in auth controller during verification: $e');
      state = AuthErrorState(
        e is AuthException
            ? e.message
            : 'Verification failed. Please try again.',
        e is Exception ? e : null,
      );
      rethrow;
    }
  }
}
