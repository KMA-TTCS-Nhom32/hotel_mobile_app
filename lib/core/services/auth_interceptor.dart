import 'dart:async';

import 'package:dio/dio.dart';
import '../../features/auth/data/repositories/auth_repository.dart';

/// Interceptor for handling authentication in API requests
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final AuthRepository _authRepository;

  /// Flag to prevent multiple token refresh requests
  bool _isRefreshing = false;

  /// Queue of requests that failed with 401 and await token refresh
  final _pendingRequests = <RequestOptions>[];

  /// Callback to trigger when refresh fails and user needs to login
  final VoidCallback onRefreshFailed;

  /// Creates an instance of AuthInterceptor
  AuthInterceptor(this._dio, this._authRepository, this.onRefreshFailed);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      if (_excludeAuthEndpoints(err.requestOptions.path)) {
        // Don't try to refresh for login/register/verify endpoints
        return handler.next(err);
      }

      final requestOptions = err.requestOptions;

      // Try to refresh token
      final refreshedToken = await _refreshToken();

      if (refreshedToken != null) {
        // Retry original request with new token
        return handler.resolve(await _retry(requestOptions, refreshedToken));
      } else {
        // If token refresh fails, pass the error through
        return handler.next(err);
      }
    }

    // For other errors, continue error handling
    return handler.next(err);
  }

  /// Check if the path should be excluded from auto-refresh
  bool _excludeAuthEndpoints(String path) {
    final authEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/verify-email',
      '/auth/verify-phone',
    ];

    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }

  /// Refresh the token and update all pending requests
  Future<String?> _refreshToken() async {
    // Prevent multiple simultaneous refresh attempts
    if (_isRefreshing) {
      return await _waitForRefresh();
    }

    _isRefreshing = true;

    try {
      // Get current refresh token
      final storedToken = await _authRepository.getStoredToken();

      if (storedToken == null || storedToken.refreshToken.isEmpty) {
        _failAndClearPendingRequests();
        return null;
      }

      // Attempt to refresh the token
      final newToken = await _authRepository.refreshToken(
        storedToken.refreshToken,
      );

      // Update dio header with new token
      _dio.options.headers['Authorization'] = 'Bearer ${newToken.accessToken}';

      // Process any pending requests with new token
      _processPendingRequests(newToken.accessToken);

      _isRefreshing = false;
      return newToken.accessToken;
    } catch (e) {
      _isRefreshing = false;

      // Token refresh failed, clear storage and notify app
      await _authRepository.clearToken();
      _failAndClearPendingRequests();
      onRefreshFailed();

      return null;
    }
  }

  /// Wait for an ongoing refresh to complete
  Future<String?> _waitForRefresh() {
    final completer = Completer<String?>();

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isRefreshing) {
        timer.cancel();
        final token = _dio.options.headers['Authorization'];
        if (token != null && token is String && token.startsWith('Bearer ')) {
          completer.complete(token.substring(7)); // Remove 'Bearer ' prefix
        } else {
          completer.complete(null);
        }
      }
    });

    return completer.future;
  }

  /// Process any pending requests with the new token
  void _processPendingRequests(String newToken) {
    final requests = List<RequestOptions>.from(_pendingRequests);
    _pendingRequests.clear();

    for (final request in requests) {
      // Set new token
      request.headers['Authorization'] = 'Bearer $newToken';
      _dio.fetch(request);
    }
  }

  /// Mark all pending requests as failed when token refresh fails
  void _failAndClearPendingRequests() {
    // Just clear the queue and let the app redirect to login
    _pendingRequests.clear();
  }

  /// Retry a request with a new token
  Future<Response> _retry(
    RequestOptions requestOptions,
    String accessToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    // Update auth header with new token
    options.headers?['Authorization'] = 'Bearer $accessToken';

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

/// Callback type for refresh failure
typedef VoidCallback = void Function();
