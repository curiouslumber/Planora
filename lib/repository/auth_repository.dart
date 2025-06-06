import 'package:flutter/foundation.dart';
import 'package:planora/apis/services/auth_service.dart';
import 'package:planora/services/firebase/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final AuthService _authService;

  AuthRepository({
    FirebaseAuthService? firebaseAuthService,
    AuthService? authService,
  })
    : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService(),
       _authService = authService ?? AuthService();

  // get currentUser => _firebaseAuthService.currentUser;

  // Future<User?> signInWithGoogle() async {
  //   // Sign In with Google
  //   final userCred = await _firebaseAuthService.signInWithGoogle();

  //   // Return user credential on succesful sign in
  //   return userCred;
  // }

  // Sign In with Email and Password
  // Future<User?> signInWithEmail(String email, String password) async {
  //   try {
  //     LoginRequest loginObj = LoginRequest(email: email, password: password);

  //     // Login Api Call
  //     LoginResponse? apiRes = await _authService.login(loginObj);
  //     if (!apiRes.status) {
  //       return null;
  //     }

  //     // If success then Firebase Login
  //     final userCred = await _firebaseAuthService.signInFirebaseWithEmail(
  //       email,
  //       password
  //     );
  
  //     // Return user credential on succesful login
  //     return userCred;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error during Email Sign-In: $e');
  //     }
  //     return null;
  //   }
  // }

  // Future<User?> createUserWithEmailAndPassword(
  //   String name,
  //   String email,
  //   String password,
  //   String loginType,
  // ) async {
  //   RegisterRequest registerObj = RegisterRequest(
  //     name: name,
  //     email: email,
  //     password: password,
  //     loginType: loginType,
  //   );

  //   // Register API Call
  //   RegisterResponse? apiRes = await _authService.register(registerObj);
  //   if (!apiRes.status) {
  //     return null;
  //   }

  //   // If success, then create user in firebase
  //   final userCred = await _firebaseAuthService.createUserWithEmailAndPassword(
  //     email,
  //     password,
  //   );
  //   if (userCred == null) {
  //     return null;
  //   }

  //   // After success hit the login flow to login the user
  //   final loginCred = await signInWithEmail(email, password);
  //   if (loginCred == null) {
  //     return null;
  //   }

  //   // Return user credential for login
  //   return loginCred;
  // }

  // Future<void> signOut() {
  //   return _firebaseAuthService.signOut();
  // }
}
