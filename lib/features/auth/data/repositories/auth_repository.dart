import '../../domain/entities/auth_token.dart';
import '../../domain/entities/registration_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/verification_data.dart';
import '../models/login_credentials.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';
import '../models/verify_response_dto.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email/phone and password
  Future<AuthToken> login(LoginCredentials credentials);

  /// Register a new user
  Future<RegisterResponseDto> register(RegistrationData data);

  /// Verify a user's email or phone with OTP code
  Future<VerifyResponseDto> verifyUser(VerificationData data);

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

  /// Get current user profile
  Future<UserProfile> getUserProfile();
}
