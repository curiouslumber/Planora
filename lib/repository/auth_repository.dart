import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:planora/apis/models/auth/login_request.dart';
import 'package:planora/apis/models/auth/login_response.dart';
import 'package:planora/apis/services/auth_service.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/firebase/firebase_auth_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseFirestoreService _firebaseFirestoreService;
  final AuthService _authService;

  AuthRepository({
    FirebaseAuthService? firebaseAuthService,
    FirebaseFirestoreService? firebaseFirestoreService,
    AuthService? authService,
  })
    : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService(),
       _firebaseFirestoreService =
           firebaseFirestoreService ?? FirebaseFirestoreService(),
       _authService = authService ?? AuthService();

  Future<UserModel?> currentUser() async {
    final String? uuid = _firebaseAuthService.currentUser?.uid;
    if (uuid == null) return null;
    return _firebaseFirestoreService.getUserDocument(uuid);
  }

  Future<UserModel?> getUserDocument(String uuid) async {
    return _firebaseFirestoreService.getUserDocument(uuid);
  }

  Future<User?> createFirebaseAuthUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _firebaseAuthService.createUserWithEmailAndPassword(email, password);
  }

  Future<void> createFirebaseFirestoreUserWithEmailAndPassword(
    String uid,
    String email,
    String displayName,
    String? profilePicUrl,
    String? phoneNumber,
    String loginType,
  ) async {
    return _firebaseFirestoreService.createUserDocument(
      uid: uid,
      email: email,
      displayName: displayName,
      profilePicUrl: profilePicUrl,
      phoneNumber: phoneNumber,
      loginType: loginType,
    );
  }

  Future<User?> signInWithGoogle() async {
    return await _firebaseAuthService.signInWithGoogle();
  }

  // Update this later to have the repository format i.e only the service functions, move business logic to bloc
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
        email,
        password
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

  Future<void> signOut() {
    return _firebaseAuthService.signOut();
  }
}
