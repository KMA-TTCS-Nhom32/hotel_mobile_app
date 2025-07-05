/// Custom exception for auth controller errors
class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}
