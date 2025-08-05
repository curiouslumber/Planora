import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:planora/networking/dio_client.dart';

class Helper {
  Future<Uint8List> getImageBytes(String imageUrl) async {
  try {
    final response = await DioClient.dio.get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      return Uint8List.fromList(response.data);
    } else {
      throw Exception('Failed to load image: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching image: $e');
  }
}
}
