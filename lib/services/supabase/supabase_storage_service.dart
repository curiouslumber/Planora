import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planora/networking/dio_client.dart';

class SupabaseStorageService {
  static Future<String?> uploadImageUsingBytes(
    String fileName,
    String bucketName,
    Uint8List imageBytes,
    Map<String, String> headers,
  ) async {
    try {
      final response = await DioClient.dio.post(
        '${dotenv.env['SUPABASE_BASE_URL']!}/storage/v1/object/$bucketName/$fileName',
        data: imageBytes,
        options: Options(
          headers: {
            'Authorization': '${dotenv.env['SUPABASE_STORAGE_AUTH_TOKEN']}',
            ...headers,
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (kDebugMode) {
          print(data);
        }
        return data["Key"] as String;
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
