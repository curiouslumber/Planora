import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:planora/apis/models/auth/login_request.dart';
import 'package:planora/apis/models/auth/login_response.dart';
import 'package:planora/apis/services/auth_service.dart';
import 'package:planora/services/firebase/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuthService _firebaseAuthService;
  final AuthService _authService;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseAuthService? firebaseAuthService,
    AuthService? authService,
  })
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _firebaseAuthService =
           firebaseAuthService ?? FirebaseAuthService.instance,
       _authService = firebaseAuthService ?? AuthService.instance,
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

  //Universal Sign-Out method
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

  // Create a new user with email and password
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Email Sign-Up: $e');
      }
      return null;
    }
  }

  // Sign In with Email and Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      LoginRequest loginObj = LoginRequest(email: email, password: password);
      // Login Api Call
      LoginResponse? apiRes = await _authService.login(loginObj);
      if (!apiRes.status) {
        return null;
      }

      // If success then Firebase Login
      final userCred = await _firebaseAuthService.signInFirebaseWithEmail(
        loginObj.email,
        loginObj.password
      );
  
      // Return user credential on succesful login
      return userCred;
    } catch (e) {
      if (kDebugMode) {
        print('Error during Email Sign-In: $e');
      }
      return null;
    }
  }
}
