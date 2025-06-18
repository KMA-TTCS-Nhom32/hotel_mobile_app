import 'package:flutter/foundation.dart';

/// Base UI state class to manage common UI states
/// This follows the pattern of loading, error, and data states
@immutable
abstract class UiState<T> {
  const UiState();

  /// Helper method to handle the different states
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message, Exception? exception) error,
  });
}

/// Initial state before any data loading has started
class InitialUiState<T> extends UiState<T> {
  const InitialUiState();

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message, Exception? exception) error,
  }) {
    return initial();
  }
}

/// Loading state when data is being fetched
class LoadingUiState<T> extends UiState<T> {
  const LoadingUiState();

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message, Exception? exception) error,
  }) {
    return loading();
  }
}

/// Success state with data
class SuccessUiState<T> extends UiState<T> {
  final T data;

  const SuccessUiState(this.data);

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message, Exception? exception) error,
  }) {
    return success(data);
  }
}

/// Error state with message
class ErrorUiState<T> extends UiState<T> {
  final String message;
  final Exception? exception;

  const ErrorUiState(this.message, [this.exception]);

  @override
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message, Exception? exception) error,
  }) {
    return error(message, exception);
  }
}
