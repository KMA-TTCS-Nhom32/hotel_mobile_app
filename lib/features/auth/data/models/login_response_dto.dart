import '../../domain/entities/auth_token.dart';

/// Data transfer object for login response
class LoginResponseDto {
  final String accessToken;
  final int accessTokenExpires;
  final String refreshToken;

  const LoginResponseDto({
    required this.accessToken,
    required this.accessTokenExpires,
    required this.refreshToken,
  });

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken'] as String,
      accessTokenExpires: json['accessTokenExpires'] as int,
      refreshToken: json['refreshToken'] as String,
    );
  }

  /// Convert DTO to domain entity
  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      accessTokenExpires: accessTokenExpires,
      refreshToken: refreshToken,
    );
  }
}
