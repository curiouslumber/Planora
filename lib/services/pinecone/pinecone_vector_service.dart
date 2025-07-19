import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:planora/networking/dio_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PineconeVectorService {

  static Future<Map<String, Object>?> semanticSearch(String imagePrompt) async {
    final url =
        '${dotenv.env['SUPABASE_BASE_URL']!}/functions/v1/semanticSearch';
    try {
      final response = await DioClient.dio.post(
        url,
        data: {'image_prompt': imagePrompt},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_AUTH_TOKEN']}',
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (kDebugMode) {
          print(data);
        }
        if (data["results"] != null && data["results"].isNotEmpty) {
          return {
            "image_url": data["results"][0]["image_url"],
            "attribution": json.decode(data["results"][0]["attribution"]),
          };
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
    Map<String, String>? attribution,
  ) async {
    final url = '${dotenv.env['SUPABASE_BASE_URL']!}/functions/v1/upsertRecord';
    try {
      final response = await DioClient.dio.post(
        url,
        data: {
          'image_prompt': imagePrompt,
          'image_url': imageUrl,
          'attribution': attribution != null ? jsonEncode(attribution) : "",
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_AUTH_TOKEN']}',
          },
        ),
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
