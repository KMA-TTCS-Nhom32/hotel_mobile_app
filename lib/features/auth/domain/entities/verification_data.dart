/// Entity class for holding verification details
class VerificationData {
  /// User ID received from backend after registration
  final String userId;

  /// Verification code (OTP) entered by the user
  final String code;

  /// Whether verification is for email or phone
  final bool isEmail;

  /// Creates a verification data instance
  const VerificationData({
    required this.userId,
    required this.code,
    required this.isEmail,
  });

  /// Convert to JSON object for API requests
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'code': code};
  }
}
