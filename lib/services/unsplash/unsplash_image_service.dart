import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planora/networking/dio_client.dart';

class UnsplashImageService {
  static Future<String?> generateImage(String imagePrompt) async {
    final url =
        '${dotenv.env['SUPABASE_BASE_URL']!}/functions/v1/unsplashImageGen';
    try {
      final response = await DioClient.dio.get(
        url,
        queryParameters: {'query': imagePrompt},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_AUTH_TOKEN']}',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (kDebugMode) {
          print(data);
        }
        if (data["image_url"] != null) {
          return data["image_url"] as String;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
    return null;
  }
}
