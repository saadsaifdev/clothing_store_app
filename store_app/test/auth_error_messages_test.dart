import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_app/services/auth_error_messages.dart';

void main() {
  group('AuthErrorMessages', () {
    test('sign-in failures do not disclose whether an account exists', () {
      final unknownAccount = AuthErrorMessages.signIn(
        FirebaseAuthException(code: 'user-not-found'),
      );
      final wrongPassword = AuthErrorMessages.signIn(
        FirebaseAuthException(code: 'wrong-password'),
      );
      final invalidCredential = AuthErrorMessages.signIn(
        FirebaseAuthException(code: 'invalid-credential'),
      );

      expect(unknownAccount, wrongPassword);
      expect(unknownAccount, invalidCredential);
    });

    test('registration failures do not disclose whether an account exists', () {
      final existingAccount = AuthErrorMessages.registration(
        FirebaseAuthException(code: 'email-already-in-use'),
      );
      final weakPassword = AuthErrorMessages.registration(
        FirebaseAuthException(code: 'weak-password'),
      );

      expect(existingAccount, weakPassword);
    });
  });
}
