import 'package:flutter/foundation.dart';

/// Represents authentication tokens
@immutable
class AuthToken {
  final String accessToken;
  final int accessTokenExpires;
  final String refreshToken;

  const AuthToken({
    required this.accessToken,
    required this.accessTokenExpires,
    required this.refreshToken,
  });

  /// Check if the access token has expired
  bool get isExpired =>
      DateTime.now().millisecondsSinceEpoch > accessTokenExpires;

  /// Get the remaining validity time of the access token in seconds
  int get remainingTime {
    final remaining =
        accessTokenExpires - DateTime.now().millisecondsSinceEpoch;
    return remaining > 0 ? remaining ~/ 1000 : 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthToken &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          accessTokenExpires == other.accessTokenExpires &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode =>
      Object.hash(accessToken, accessTokenExpires, refreshToken);
}
