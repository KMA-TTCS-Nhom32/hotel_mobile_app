import 'package:flutter/foundation.dart';

import '../domain/entities/user_profile.dart';

/// Base class for authentication state
@immutable
abstract class AuthState {
  const AuthState();
}

/// Initial state before any authentication attempt
class AuthInitialState extends AuthState {
  const AuthInitialState();
}

/// Loading state during authentication process
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// State when user is authenticated
class AuthAuthenticatedState extends AuthState {
  final String accessToken;
  final UserProfile? userProfile;

  const AuthAuthenticatedState(this.accessToken, {this.userProfile});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticatedState &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          userProfile == other.userProfile;

  @override
  int get hashCode => Object.hash(accessToken, userProfile);

  /// Create a copy with updated profile
  AuthAuthenticatedState copyWith({
    String? accessToken,
    UserProfile? userProfile,
  }) {
    return AuthAuthenticatedState(
      accessToken ?? this.accessToken,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}

/// State when user is not authenticated
class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

/// State during registration process (after registration, before verification)
class AuthRegistrationState extends AuthState {
  final String userId;

  const AuthRegistrationState({required this.userId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthRegistrationState &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

/// Error state when authentication fails
class AuthErrorState extends AuthState {
  final String message;
  final Exception? exception;

  const AuthErrorState(this.message, [this.exception]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthErrorState &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
