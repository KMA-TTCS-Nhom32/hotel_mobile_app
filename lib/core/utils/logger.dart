import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Logger utility for the application
/// Uses the logger package to provide a consistent logging interface
/// that can be enabled/disabled based on build environment
class AppLogger {
  /// Singleton instance
  static final AppLogger _instance = AppLogger._internal();

  /// Logger instance from the logger package
  final Logger _logger;

  /// Indicates whether debug logging is enabled
  final bool _isDebugEnabled;

  /// Returns the singleton instance
  factory AppLogger() => _instance;

  /// Creates the logger instance
  AppLogger._internal()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 1,
          errorMethodCount: 8,
          lineLength: 80,
          colors: true,
          printEmojis: true,
          // printTime is deprecated, use dateTimeFormat instead
          dateTimeFormat: DateTimeFormat.dateAndTime,
        ),
      ),
      // Only enable debug logging in debug mode
      _isDebugEnabled = kDebugMode;

  /// Log a debug message
  /// Only prints in debug mode
  void d(dynamic message) {
    if (_isDebugEnabled) {
      _logger.d(message);
    }
  }

  /// Log an info message
  void i(dynamic message) {
    if (_isDebugEnabled) {
      _logger.i(message);
    }
  }

  /// Log a warning message
  void w(dynamic message) {
    if (_isDebugEnabled) {
      _logger.w(message);
    }
  }

  /// Log an error message
  /// This will be logged in all build modes
  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    // Error logs are important, so we always log them
    if (error != null) {
      _logger.e('$message', error: error, stackTrace: stackTrace);
    } else {
      _logger.e(message);
    }
  }
}
