import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'auth_interceptor.dart';

/// API service for making HTTP requests
class ApiService {
  late final Dio _dio;
  static const String baseUrl =
      'https://ahomevilla-server-42d8383e47f6.herokuapp.com/api';

  /// Creates an instance of ApiService
  ApiService() {
    _dio = _createDioInstance();
  }

  /// Add auth interceptor
  void addAuthInterceptor(
    dynamic authRepository,
    VoidCallback onRefreshFailed,
  ) {
    final authInterceptor = AuthInterceptor(
      _dio,
      authRepository,
      onRefreshFailed,
    );

    // Insert at the beginning to catch errors before other interceptors
    _dio.interceptors.insert(0, authInterceptor);
  }

  /// Create and configure Dio instance
  Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }

    return dio;
  }

  /// Set auth token for authenticated requests
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear auth token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Perform GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  /// Perform POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw _handleGenericError(e);
    }
  }

  /// Handle DioException and convert to custom exceptions
  Exception _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return TimeoutException(
        'Connection timed out. Please check your internet connection.',
      );
    } else if (error.error is SocketException) {
      return NetworkException(
        'Network error. Please check your internet connection.',
      );
    } else if (error.response?.statusCode == 401) {
      return UnauthorizedException('Unauthorized access. Please login again.');
    } else if (error.response?.statusCode == 403) {
      return ForbiddenException(
        'Access denied. You do not have permission to access this resource.',
      );
    } else if (error.response?.statusCode == 404) {
      return NotFoundException('The requested resource was not found.');
    } else if (error.response?.statusCode == 409) {
      // Handle conflict errors (e.g., user already exists)
      final dynamic data = error.response!.data;
      String message = 'Resource conflict';
      if (data is Map<String, dynamic>) {
        final errorMessage = data['message'];
        if (errorMessage is List) {
          message = errorMessage.join(', ');
        } else if (errorMessage is String) {
          message = errorMessage;
        }
      }
      return ConflictException(message);
    } else if (error.response?.statusCode == 422) {
      // Handle validation errors (e.g., already verified account)
      final dynamic data = error.response!.data;
      String message = 'Validation error';
      if (data is Map<String, dynamic>) {
        final errorMessage = data['message'];
        if (errorMessage is List) {
          message = errorMessage.join(', ');
        } else if (errorMessage is String) {
          message = errorMessage;
        }
      }
      return ValidationException(message);
    } else if (error.response != null && error.response!.data != null) {
      // Try to extract error message from response
      final dynamic data = error.response!.data;
      String message = 'An error occurred';
      if (data is Map<String, dynamic>) {
        final errorMessage = data['message'];
        if (errorMessage is List) {
          message = errorMessage.join(', ');
        } else if (errorMessage is String) {
          message = errorMessage;
        }
      }

      return ServerException(message);
    } else {
      return ServerException(
        'An error occurred while processing your request.',
      );
    }
  }

  /// Handle generic errors
  Exception _handleGenericError(dynamic error) {
    return ServerException('An unexpected error occurred: ${error.toString()}');
  }
}

/// Custom exception for network errors
class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

/// Custom exception for timeouts
class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

/// Custom exception for unauthorized access
class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

/// Custom exception for forbidden access
class ForbiddenException implements Exception {
  final String message;
  ForbiddenException(this.message);
}

/// Custom exception for not found resources
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

/// Custom exception for server errors
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Custom exception for validation errors (422)
class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}

/// Custom exception for conflict errors (409)
class ConflictException implements Exception {
  final String message;
  ConflictException(this.message);
}
