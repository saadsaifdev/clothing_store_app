import 'package:firebase_auth/firebase_auth.dart';

/// Keeps Firebase account-specific errors from being exposed in the UI.
class AuthErrorMessages {
  AuthErrorMessages._();

  static String signIn(FirebaseAuthException _) =>
      'Unable to sign in. Check your details and try again.';

  static String registration(FirebaseAuthException _) =>
      'Unable to create account. Check your details and try again.';
}
