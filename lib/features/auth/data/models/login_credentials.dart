import 'package:flutter/foundation.dart';

/// Represents a user's authentication credentials
@immutable
class LoginCredentials {
  final String emailOrPhone;
  final String password;

  const LoginCredentials({required this.emailOrPhone, required this.password});

  Map<String, dynamic> toJson() => {
    'emailOrPhone': emailOrPhone,
    'password': password,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginCredentials &&
          runtimeType == other.runtimeType &&
          emailOrPhone == other.emailOrPhone &&
          password == other.password;

  @override
  int get hashCode => Object.hash(emailOrPhone, password);
}
