import 'package:firebase_storage/firebase_storage.dart';

class Helper {
  // Method to get download URL from gs:// URL
  static Future<String> getDownloadUrl(String gsUrl) async {
    final ref = FirebaseStorage.instance.refFromURL(gsUrl);
    return await ref.getDownloadURL();
  }
}
