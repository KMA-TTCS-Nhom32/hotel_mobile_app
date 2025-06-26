import 'package:flutter/foundation.dart';

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

  const AuthAuthenticatedState(this.accessToken);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAuthenticatedState &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken;

  @override
  int get hashCode => accessToken.hashCode;
}

/// State when user is not authenticated
class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
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
