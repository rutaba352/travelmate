import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:travelmate/Services/Auth/AuthException.dart';
import 'package:travelmate/Services/Auth/AuthUser.dart';
import 'package:travelmate/firebase_options.dart';
import 'package:travelmate/Services/Auth/AuthProvider.dart' as my_auth;

class FirebaseAuthProvider implements my_auth.AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) return user;
      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during login: ${e.code}');
      switch (e.code) {
        case 'user-not-found':
          throw UserNotFoundAuthException();
        case 'wrong-password':
          throw WrongPasswordAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-disabled':
          throw GenericAuthException();
        case 'invalid-credential':
          // This is a common error that replaces user-not-found and wrong-password
          throw InvalidCredentialsAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      print('Unknown error during login: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) return user;
      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during registration: ${e.code}');
      switch (e.code) {
        case 'weak-password':
          throw WeakPasswordAuthException();
        case 'email-already-in-use':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'operation-not-allowed':
          throw GenericAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      print('Unknown error during registration: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn with proper configuration
      final googleSignIn = GoogleSignIn(
        scopes: ['email'],
        // OPTIONAL: Add your Web Client ID here if needed
        // clientId: '752416442170-9v7oje93smkja5fnefm7nge83b6ikovu.apps.googleusercontent.com',
      );

      // Sign out from any previous session to allow account selection
      await googleSignIn.signOut();

      // Trigger the Google sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // User canceled the sign-in
      if (googleUser == null) {
        print('User cancelled Google Sign-In');
        throw GenericAuthException();
      }

      print('Google Sign-In successful for: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Check if we have both access token and ID token
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print('Missing Google authentication tokens');
        throw GenericAuthException();
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      // Verify the user was created/signed in
      if (userCredential.user == null) {
        print('Failed to create Firebase user from Google credential');
        throw UserNotLoggedInAuthException();
      }

      print('Firebase sign-in successful: ${userCredential.user!.email}');

      final user = currentUser;
      if (user != null) return user;
      throw UserNotLoggedInAuthException();
    } on FirebaseAuthException catch (e) {
      print(
        'FirebaseAuthException during Google Sign-In: ${e.code} - ${e.message}',
      );
      switch (e.code) {
        case 'account-exists-with-different-credential':
          throw EmailAlreadyInUseAuthException();
        case 'invalid-credential':
        case 'user-disabled':
        case 'operation-not-allowed':
          throw GenericAuthException();
        default:
          throw GenericAuthException();
      }
    } on PlatformException catch (e) {
      print(
        'PlatformException during Google Sign-In: ${e.code} - ${e.message}',
      );
      // Common error codes:
      // sign_in_failed - Usually means SHA-1 not configured
      // network_error - No internet connection
      // sign_in_canceled - User canceled
      if (e.code == 'sign_in_failed') {
        print(
          'ERROR: sign_in_failed - This usually means SHA-1/SHA-256 fingerprints are not added to Firebase Console',
        );
        print('Follow these steps:');
        print('1. Run: cd android && ./gradlew signingReport');
        print('2. Copy SHA-1 and SHA-256 from debug variant');
        print(
          '3. Add them to Firebase Console → Project Settings → Your Android App',
        );
      }
      throw GenericAuthException();
    } catch (e) {
      print('Unknown error during Google Sign-In: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Sign out from Google if user signed in with Google
        await GoogleSignIn().signOut();
        print('Signed out from Google');
      } catch (e) {
        print('Error signing out from Google: $e');
        // Continue with Firebase sign-out even if Google sign-out fails
      }

      try {
        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();
        print('Signed out from Firebase');
      } catch (e) {
        print('Error signing out from Firebase: $e');
        throw GenericAuthException();
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
        print('Email verification sent to: ${user.email}');
      } on FirebaseAuthException catch (e) {
        print('Error sending email verification: ${e.code}');
        throw GenericAuthException();
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> reauthenticate(String password) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.email == null) {
        throw GenericAuthException();
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
          throw WrongPasswordAuthException();
        } else {
          throw GenericAuthException();
        }
      } catch (_) {
        throw GenericAuthException();
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(newPassword);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw WeakPasswordAuthException();
        } else if (e.code == 'requires-recent-login') {
          throw GenericAuthException(); // Should be handled by reauth
        } else {
          throw GenericAuthException();
        }
      } catch (_) {
        throw GenericAuthException();
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> updateUser({String? displayName, String? photoURL}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    try {
      final methods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(
        toEmail,
      );
      if (methods.isEmpty) {
        throw UserNotFoundAuthException();
      }
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
      print('Password reset email sent to: $toEmail');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during password reset: ${e.code}');
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-not-found':
          throw UserNotFoundAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      print('Unknown error during password reset: $e');
      throw GenericAuthException();
    }
  }
}
