import 'package:travelmate/Services/Auth/AuthProvider.dart';
import 'package:travelmate/Services/Auth/AuthUser.dart';
import 'package:travelmate/Services/Auth/FirebaseAuthProvider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<void> initialize() => provider.initialize();

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> signInWithGoogle() => provider.signInWithGoogle();  // Added

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  Future<void> reauthenticate(String password) =>
      provider.reauthenticate(password);

  @override
  Future<void> updatePassword(String newPassword) =>
      provider.updatePassword(newPassword);

  @override
  Future<void> updateUser({String? displayName, String? photoURL}) =>
      provider.updateUser(displayName: displayName, photoURL: photoURL);
}