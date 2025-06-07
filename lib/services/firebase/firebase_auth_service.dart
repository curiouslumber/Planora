import 'package:flutter/foundation.dart';

class FirebaseAuthService {

  // FirebaseAuthService({})
  //   //   : _firebaseAuth = FirebaseAuth.instance,
  //   //     _googleSignIn = GoogleSignIn();

//   // Returns the currently signed-in [User] or null if not signed-in
  //   // User? get currentUser => _firebaseAuth.currentUser;

//   // Create a new user with email and password
  //   Future<User?> createUserWithEmailAndPassword(
  //     String email,
  //     String password,
  //   ) async {
  //     try {
  //       final userCred = await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       return userCred.user;
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Error during Email Sign-Up: $e');
  //       }
  //       return null;
  //     }
  //   }

//   // Sign with email and password
  //   Future<User?> signInFirebaseWithEmail(String email, String password) async {
  //     try {
  //       final userCred = await _firebaseAuth.signInWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       return userCred.user;
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Error during Email Sign-In: $e');
  //       }
  //       return null;
  //     }
  //   }

//   // Triggers Google Sign-In flow and returns the signed-in [User].
  //   Future<User?> signInWithGoogle() async {
  //     try {
  //       final googleUser = await _googleSignIn.signIn();
  //       if (googleUser == null) {
  //         throw Exception('Sign In aborted by user');
  //       }

//       // Obtain the auth details from the request
  //       final googleAuth = await googleUser.authentication;

//       // Create a new credential
  //       final credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth.accessToken,
  //         idToken: googleAuth.idToken,
  //       );

//       // Sign In to Firebase with the Google [UserCredential]
  //       final userCred = await _firebaseAuth.signInWithCredential(credential);
  //       return userCred.user;
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Error during Google Sign-In: $e');
  //       }
  //       return null;
  //     }
  //   }

//   //Universal Sign-Out method
  //   Future<void> signOut() async {
  //     try {
  //       await _firebaseAuth.signOut();
  //       await _googleSignIn.signOut();
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print('Error during Sign-Out: $e');
  //       }
  //     }
  //   }
}
