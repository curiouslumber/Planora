import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';

class FirebaseAiService {
  final model = FirebaseAI.googleAI().imagenModel(
    model: 'imagen-3.0-generate-002',
  );

  final prompt = 'Exam Test';

  Future<Uint8List?> generateImage() async {
    final response = await model.generateImages(prompt);
    if (response.images.isNotEmpty) {
      final image = response.images[0];
      return image.bytesBase64Encoded;
    } else {
      return null;
    }
  }
}
