import '../../domain/entities/auth_token.dart';
import '../models/login_credentials.dart';
import '../models/login_response_dto.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email/phone and password
  Future<AuthToken> login(LoginCredentials credentials);

  /// Refresh access token
  Future<AuthToken> refreshToken(String refreshToken);

  /// Logout user
  Future<void> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored auth token
  Future<AuthToken?> getStoredToken();

  /// Store auth token
  Future<void> storeToken(AuthToken token);

  /// Clear auth token
  Future<void> clearToken();
}
