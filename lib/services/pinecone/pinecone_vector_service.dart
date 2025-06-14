import 'package:flutter/foundation.dart';
import 'package:planora/networking/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PineconeVectorService {
  static final apiBaseUrl = dotenv.env['PINECONE_API_BASE_URL']!;

  static Future<String?> semanticSearch(String imagePrompt) async {
    final url = '$apiBaseUrl/semanticSearch';
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
}
