import 'package:flutter/foundation.dart';
import 'package:planora/networking/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PineconeVectorService {

  static Future<String?> semanticSearch(String imagePrompt) async {
    final url = '${dotenv.env['PINECONE_SEARCH_API_BASE_URL']!}/semanticSearch';
    try {
      final response = await DioClient.dio.post(
        url,
        data: {'image_prompt': imagePrompt},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (kDebugMode) {
          print(data);
        }
        if (data["results"] != null && data["results"].isNotEmpty) {
          return data["results"][0]["image_url"];
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

  static Future<bool> upsertNewIndex(
    String imagePrompt,
    String imageUrl,
  ) async {
    final url = '${dotenv.env['PINECONE_UPSERT_API_BASE_URL']!}/upsertRecord';
    try {
      final response = await DioClient.dio.post(
        url,
        data: {'image_prompt': imagePrompt, 'image_url': imageUrl},
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (kDebugMode) {
          print(data);
        }
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
    return false;
  }
}
