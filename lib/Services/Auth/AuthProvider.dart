import 'package:travelmate/Services/Auth/AuthUser.dart';

abstract class AuthProvider {
  Future<void> initialize();
  
  AuthUser? get currentUser;
  
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  
  Future<AuthUser> signInWithGoogle();  // Added
  
  Future<void> logOut();
  
  Future<void> sendEmailVerification();
  
  Future<void> reauthenticate(String password);
  
  Future<void> updatePassword(String newPassword);
  
  Future<void> updateUser({String? displayName, String? photoURL});
  
  Future<void> sendPasswordReset({required String toEmail});
}