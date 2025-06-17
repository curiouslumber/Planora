import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  // Function to upload bytes to Firebase Storage
  Future<String?> uploadImageUsingBytes(
    String fileName,
    String path,
    Uint8List imageBytes,
  ) async {
    if (imageBytes.isEmpty) {
      return null;
    }
    try {
      String storagePath = '$path/$fileName';

      final storageRef = _storage.ref().child(storagePath);

      final uploadTask = storageRef.putData(imageBytes);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        if (kDebugMode) {
          print(
            'Uploading: ${snapshot.bytesTransferred / snapshot.totalBytes}',
          );
        }
      });
      final TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        return 'gs://planora-np47.firebasestorage.app/$path/$fileName';
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('Firebase Storage Error: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
      return null;
    }
  }
}
