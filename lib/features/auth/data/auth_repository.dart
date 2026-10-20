/// Local dummy authentication for the assessment app.
///
/// Demo account (no backend):
/// - Email: [demoEmail]
/// - Password: [demoPassword]
class AuthRepository {
  const AuthRepository({this.delay = const Duration(milliseconds: 450)});

  static const String demoEmail = 'demo@ecom.app';
  static const String demoPassword = 'Password123';

  static const String invalidCredentialsMessage =
      'Those credentials don’t match the demo account. '
      'Use $demoEmail and $demoPassword.';

  /// Artificial wait so the login loading state is visible.
  final Duration delay;

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }

    final normalizedEmail = email.trim().toLowerCase();
    final isValid = normalizedEmail == demoEmail && password == demoPassword;

    if (isValid) {
      return const AuthResult.success();
    }

    return const AuthResult.failure(invalidCredentialsMessage);
  }
}

final class AuthResult {
  const AuthResult.success() : isSuccess = true, message = null;

  const AuthResult.failure(this.message) : isSuccess = false;

  final bool isSuccess;
  final String? message;
}
