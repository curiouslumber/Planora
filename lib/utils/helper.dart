import 'dart:typed_data';

import 'package:planora/networking/dio_client.dart';

class Helper {
  Future<Uint8List> getImageBytes(String imageUrl) async {
    final response = await DioClient.dio.get(imageUrl);

    if (response.statusCode == 200) {
      return response.data; // This gives you the image as bytes
    } else {
      throw Exception('Failed to load image');
    }
  }
}
