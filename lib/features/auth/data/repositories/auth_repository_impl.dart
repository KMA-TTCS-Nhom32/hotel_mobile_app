import 'package:dio/dio.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/registration_data.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/verification_data.dart';
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

  /// Create an instance of AuthRepositoryImpl
  AuthRepositoryImpl(this._apiService, this._secureStorage);

  @override
  Future<AuthToken> login(LoginCredentials credentials) async {
    try {
      final response = await _apiService.post(
        '/auth/login',
        data: credentials.toJson(),
      );

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
      final response = await _apiService.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final loginResponse = LoginResponseDto.fromJson(response.data);
      final token = loginResponse.toEntity();

      // Store token
      await storeToken(token);

      // Set token for authenticated requests
      _apiService.setAuthToken(token.accessToken);

      return token;
    } catch (e) {
      // Clear token if refresh fails
      await clearToken();
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Call logout endpoint if needed
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Ignore errors on logout
    } finally {
      // Always clear local token
      await clearToken();
      _apiService.clearAuthToken();
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
      final response = await _apiService.post(
        '/auth/register',
        data: data.toJson(),
      );

      return RegisterResponseDto.fromJson(response.data);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<VerifyResponseDto> verifyUser(VerificationData data) async {
    try {
      final response = await _apiService.post(
        '/auth/verify-email',
        data: data.toJson(),
      );

      return VerifyResponseDto.fromJson(response.data);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      final response = await _apiService.get('/auth/profile');
      final userProfileDto = UserProfileDto.fromJson(response.data);
      return userProfileDto.toEntity();
    } catch (e) {
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

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
