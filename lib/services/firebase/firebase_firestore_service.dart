import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planora/models/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Reference to the 'users' collection
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Create a new user document in Firestore
  Future<void> createUserDocument({
    required String uid,
    required String email,
    required String displayName,
    String? profilePicUrl,
    String? phoneNumber,
    required String loginType,
  }) async {
    final UserModel newUser = UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      profilePicUrl: profilePicUrl,
      phoneNumber: phoneNumber,
      loginType: loginType,
    );
    await _usersCollection.doc(uid).set(newUser.toFirestore());
  }

  // Get user document from Firestore
  Future<UserModel?> getUserDocument(String uuid) async {
    final doc = await _usersCollection.doc(uuid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }
}
