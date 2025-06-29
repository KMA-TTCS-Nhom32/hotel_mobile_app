/// Entity class for registration data
class RegistrationData {
  /// User's full name
  final String name;

  /// User's password
  final String password;

  /// User's email (if registration is by email)
  final String? identifier;

  /// User's phone number (if registration is by phone)
  final String? phone;

  /// Whether the user is registering with email (true) or phone (false)
  final bool isEmail;

  /// Creates a new registration data instance
  const RegistrationData({
    required this.name,
    required this.password,
    required this.isEmail,
    this.identifier,
    this.phone,
  });

  /// Convert to JSON object for API requests
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'name': name,
        'password': password,
        if (isEmail && identifier != null) 'email': identifier,
        if (!isEmail && phone != null) 'phone': phone,
      },
      'accountIdentifier': isEmail ? 'EMAIL' : 'PHONE',
    };
  }
}
