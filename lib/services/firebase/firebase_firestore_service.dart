import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/image_model.dart';
import 'package:planora/models/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;

  FirebaseFirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Reference to the 'users' collection
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Reference to the 'events' collection
  CollectionReference get _eventsCollection => _firestore.collection('events');

  // Reference to the 'images' collection
  CollectionReference get _imagesCollection => _firestore.collection('images');

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

  // Create a new event document in Firestore
  Future<void> createEventDocument({required EventModel event}) async {
    await _eventsCollection.doc(event.id).set(event.toFirestore());
  }

  // Update event document in Firestore
  Future<void> updateEventDocument(String id, EventModel updatedEvent) async {
    await _eventsCollection.doc(id).update(updatedEvent.toFirestore());
  }

  // Create a new image document in Firestore
  Future<void> createImageDocument({required ImageModel image}) async {
    await _imagesCollection.doc(image.uid).set(image.toFirestore());
  }

  // Get image document from Firestore
  Future<ImageModel?> getImageDocument(String imageId) async {
    final doc = await _imagesCollection.doc(imageId).get();
    if (doc.exists) {
      return ImageModel.fromFirestore(doc);
    }
    return null;
  }
}
