import 'package:firebase_auth/firebase_auth.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/firebase/firebase_auth_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseFirestoreService _firebaseFirestoreService;

  AuthRepository({
    FirebaseAuthService? firebaseAuthService,
    FirebaseFirestoreService? firebaseFirestoreService,
  })
    : _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService(),
       _firebaseFirestoreService =
           firebaseFirestoreService ?? FirebaseFirestoreService();

  Future<UserModel?> currentUser() async {
    final String? uuid = _firebaseAuthService.currentUser?.uid;
    if (uuid == null) return null;
    return _firebaseFirestoreService.getUserDocument(uuid);
  }

  Future<UserModel?> getUserDocument(String uuid) async {
    return _firebaseFirestoreService.getUserDocument(uuid);
  }

  Future<Object?> createFirebaseAuthUserWithEmailAndPassword(
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

  Future<Object?> signInWithEmail(String email, String password) async {
    return _firebaseAuthService.signInFirebaseWithEmail(email, password);
  }

  Future<User?> signInWithGoogle() async {
    return await _firebaseAuthService.signInWithGoogle();
  }

  // Update this later to have the repository format i.e only the service functions, move business logic to bloc
 
  Future<void> signOut() {
    return _firebaseAuthService.signOut();
  }
}
