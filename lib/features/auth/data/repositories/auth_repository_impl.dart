import 'package:dio/dio.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/registration_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/verification_data.dart';
import '../../domain/exceptions/auth_exception.dart';
import '../models/login_credentials.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';
import '../models/user_profile_dto.dart';
import '../models/verify_response_dto.dart';
import 'auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final SecureStorageService _secureStorage;
  final AppLogger _logger = AppLogger();

  /// Create an instance of AuthRepositoryImpl
  AuthRepositoryImpl(this._apiService, this._secureStorage);

  @override
  Future<AuthToken> login(LoginCredentials credentials) async {
    try {
      _logger.d('Attempting login with: ${credentials.emailOrPhone}');

      final response = await _apiService.post(
        '/auth/login',
        data: credentials.toJson(),
      );

      _logger.d('Login successful');
      final loginResponse = LoginResponseDto.fromJson(response.data);
      final token = loginResponse.toEntity();

      // Store token
      await storeToken(token);

      // Set token for authenticated requests
      _apiService.setAuthToken(token.accessToken);

      return token;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<AuthToken> refreshToken(String refreshToken) async {
    try {
      _logger.d('Attempting to refresh token');

      final response = await _apiService.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      _logger.d('Token refresh successful');
      final loginResponse = LoginResponseDto.fromJson(response.data);
      final token = loginResponse.toEntity();

      // Store token
      await storeToken(token);

      // Set token for authenticated requests
      _apiService.setAuthToken(token.accessToken);

      return token;
    } catch (e) {
      // Clear token if refresh fails
      _logger.e('Token refresh failed', e);
      await clearToken();
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      _logger.d('Logging out user');
      // Call logout endpoint if needed
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Ignore errors on logout
      _logger.w(
        'Error during logout API call (proceeding anyway): ${e.toString()}',
      );
    } finally {
      // Always clear local token
      await clearToken();
      _apiService.clearAuthToken();
      _logger.d('User logged out - tokens cleared');
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await _secureStorage.hasValidToken();
  }

  @override
  Future<AuthToken?> getStoredToken() async {
    final accessToken = await _secureStorage.getAccessToken();
    final refreshToken = await _secureStorage.getRefreshToken();
    final expiry = await _secureStorage.getTokenExpiry();

    if (accessToken != null && refreshToken != null && expiry != null) {
      return AuthToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        accessTokenExpires: expiry,
      );
    }
    return null;
  }

  @override
  Future<void> storeToken(AuthToken token) async {
    await _secureStorage.setAccessToken(token.accessToken);
    await _secureStorage.setRefreshToken(token.refreshToken);
    await _secureStorage.setTokenExpiry(token.accessTokenExpires);
  }

  @override
  Future<void> clearToken() async {
    await _secureStorage.clearAuthData();
  }

  @override
  Future<RegisterResponseDto> register(RegistrationData data) async {
    try {
      // Debug log for registration request
      _logger.d(
        'Registering user with ${data.isEmail ? "email" : "phone"}: ${data.isEmail ? data.identifier : data.phone}',
      );

      final response = await _apiService.post(
        '/auth/register',
        data: data.toJson(),
      );

      // Debug log for successful registration
      _logger.d('Registration successful: ${response.data}');

      return RegisterResponseDto.fromJson(response.data);
    } catch (e) {
      // Debug log for registration error
      _logger.e('Registration error', e);
      throw _handleAuthError(e);
    }
  }

  @override
  Future<VerifyResponseDto> verifyUser(VerificationData data) async {
    try {
      final response = await _apiService.post(
        data.isEmail ? '/auth/verify-email' : '/auth/verify-phone',
        data: data.toJson(),
      );

      // Debug the response to troubleshoot parsing issues
      _logger.d('Verification response: ${response.data}');

      final verifyResponse = VerifyResponseDto.fromJson(response.data);
      // Extra check to ensure success is properly set
      if (response.statusCode == 200) {
        return VerifyResponseDto(
          success: true,
          userId: verifyResponse.userId,
          message: verifyResponse.message ?? 'Verification successful',
        );
      }

      return verifyResponse;
    } catch (e) {
      _logger.e('Verification error', e);
      // Special handling for 422 errors which might indicate the code was already used
      if (e is ValidationException && e.message.contains('already verified')) {
        // Return a successful response with a custom message
        return VerifyResponseDto(
          success: true,
          userId: data.userId,
          message: 'Account already verified. You can now login.',
        );
      } else if (e is ServerException &&
          e.message.contains('already verified')) {
        // Return a successful response with a custom message
        return VerifyResponseDto(
          success: true,
          userId: data.userId,
          message: 'Account already verified. You can now login.',
        );
      }
      throw _handleAuthError(e);
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      _logger.d('Fetching user profile');
      final response = await _apiService.get('/auth/profile');
      final userProfileDto = UserProfileDto.fromJson(response.data);
      _logger.d('User profile fetched successfully');
      return userProfileDto.toEntity();
    } catch (e) {
      _logger.e('Error fetching user profile', e);
      throw _handleAuthError(e);
    }
  }

  /// Convert errors to auth-specific exceptions
  Exception _handleAuthError(dynamic error) {
    if (error is UnauthorizedException) {
      return AuthException('Invalid email/phone or password.');
    } else if (error is ForbiddenException) {
      return AuthException(
        'Access denied. Please check your account permissions.',
      );
    } else if (error is ConflictException) {
      // Handle specific conflict errors
      if (error.message.contains('userAlreadyExists')) {
        return AuthException('User with this email or phone already exists.');
      }
      return AuthException(error.message);
    } else if (error is ValidationException) {
      return AuthException(error.message);
    } else if (error is TimeoutException || error is NetworkException) {
      return AuthException(error.message);
    } else if (error is ServerException) {
      return AuthException(error.message);
    } else if (error is DioException && error.response?.statusCode == 401) {
      return AuthException('Invalid email/phone or password.');
    } else {
      return AuthException('Authentication failed. Please try again.');
    }
  }
}
