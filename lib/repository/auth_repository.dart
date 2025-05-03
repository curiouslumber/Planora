import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Triggers Google Sign-In flow and returns the signed-in [User].
  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Sign In aborted by user');
      }

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign In to Firebase with the Google [UserCredential]
      final userCred = await _firebaseAuth.signInWithCredential(credential);
      return userCred.user;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Google Sign-In: $e');
      }
      return null;
    }
  }

  // Signs out from both Firebase and Google
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error during Sign-Out: $e');
      }
    }
  }

  // Returns the currently signed-in [User] or null if not signed-in
  User? get currentUser => _firebaseAuth.currentUser;
}
