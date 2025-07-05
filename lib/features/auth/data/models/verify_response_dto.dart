import '../../domain/entities/account_identifier.dart';

/// DTO for the verification response
class VerifyResponseDto {
  /// Whether the verification was successful
  final bool success;

  /// User ID that was verified
  final String userId;

  /// Type of verification (EMAIL or PHONE)
  final AccountIdentifier? type;

  /// Verification message from server (if any)
  final String? message;

  /// Creates a verification response DTO instance
  VerifyResponseDto({
    required this.success,
    required this.userId,
    this.type,
    this.message,
  });

  /// Create from JSON response
  factory VerifyResponseDto.fromJson(Map<String, dynamic> json) {
    // Check if the response format includes 'success' field
    if (json.containsKey('success')) {
      return VerifyResponseDto(
        success: json['success'] as bool,
        userId: json['userId'] as String,
        type:
            json['type'] != null
                ? _parseIdentifierType(json['type'] as String)
                : null,
        message: json['message'] as String?,
      );
    } else {
      // Handle newer API response format where success is implied by status 200
      // and there's a message and user object
      final bool success =
          json.containsKey('message') && json.containsKey('user');
      String userId = '';
      if (json.containsKey('user') && json['user'] is Map<String, dynamic>) {
        final user = json['user'] as Map<String, dynamic>;
        userId = user['id']?.toString() ?? '';
      }

      return VerifyResponseDto(
        success: success,
        userId: userId,
        message: json['message'] as String?,
      );
    }
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
