import 'index.dart';

/// Extension methods for AppLocalizations to get validator messages
extension ValidatorMessages on AppLocalizations {
  /// Get message for required field validation
  String getRequiredFieldMessage() => validationRequired;

  /// Get message for empty email/phone validation
  String getEmptyEmailPhoneMessage() => validationEmptyEmail;

  /// Get message for invalid email/phone validation
  String getInvalidEmailPhoneMessage() => validationEmailPhone;

  /// Get message for empty password validation
  String getEmptyPasswordMessage() => validationEmptyPassword;

  /// Get message for invalid password validation (complex requirements)
  String getInvalidPasswordMessage() => validationPassword;
}
