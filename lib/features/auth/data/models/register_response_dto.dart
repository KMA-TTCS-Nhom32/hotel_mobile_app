import '../../domain/entities/account_identifier.dart';

/// DTO for the registration response that matches server API
class RegisterResponseDto {
  /// The ID of the registered user
  final String id;

  /// User's email (optional)
  final String? email;

  /// User's phone number (optional)
  final String? phone;

  /// Type of identifier used for registration (EMAIL or PHONE)
  final AccountIdentifier identifierType;

  /// Creates a register response DTO instance
  const RegisterResponseDto({
    required this.id,
    this.email,
    this.phone,
    required this.identifierType,
  });

  /// Create from JSON response
  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      id: json['id'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      identifierType: _parseIdentifierType(json['identifier_type'] as String),
    );
  }

  /// Helper method to parse identifier type from string
  static AccountIdentifier _parseIdentifierType(String value) {
    switch (value) {
      case 'EMAIL':
        return AccountIdentifier.email;
      case 'PHONE':
        return AccountIdentifier.phone;
      default:
        return AccountIdentifier.email; // Default fallback
    }
  }
}
