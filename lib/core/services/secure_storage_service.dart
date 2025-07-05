import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive information
class SecureStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _userIdKey = 'user_id';

  final FlutterSecureStorage _storage;

  /// Creates an instance of SecureStorageService
  SecureStorageService() : _storage = const FlutterSecureStorage();

  /// Set access token
  Future<void> setAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Set refresh token
  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Set token expiry timestamp (milliseconds since epoch)
  Future<void> setTokenExpiry(int expiryTimestamp) async {
    await _storage.write(
      key: _tokenExpiryKey,
      value: expiryTimestamp.toString(),
    );
  }

  /// Get token expiry timestamp
  Future<int?> getTokenExpiry() async {
    final expiry = await _storage.read(key: _tokenExpiryKey);
    return expiry != null ? int.tryParse(expiry) : null;
  }

  /// Set user ID
  Future<void> setUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Check if access token exists and is not expired
  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    final expiryTimestamp = await getTokenExpiry();

    if (token == null || expiryTimestamp == null) {
      return false;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    return now < expiryTimestamp;
  }

  /// Clear all stored authentication data
  Future<void> clearAuthData() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tokenExpiryKey);
    await _storage.delete(key: _userIdKey);
  }
}
