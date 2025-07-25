import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planora/networking/dio_client.dart';
import 'package:planora/utils/app_config.dart';

class UnsplashImageService {
  /// Generates an image using Unsplash API based on the provided prompt.
  /// Returns null if offline, cloud sync is disabled, or if the request fails.
  static Future<Map<String, Object>?> generateImage(String imagePrompt) async {
    // Skip if cloud sync is disabled
    if (!AppConfig.isCloudSyncEnabled) {
      if (kDebugMode) {
        print('Cloud sync is disabled, skipping image generation');
      }
      return null;
    }

    // Check network connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (kDebugMode) {
        print('No network connection, skipping image generation');
      }
      return null;
    }

    final url = '${dotenv.env['SUPABASE_BASE_URL']!}/functions/v1/unsplashImageGen';
    
    try {
      final response = await DioClient.dio.get(
        url,
        queryParameters: {'query': imagePrompt},
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['SUPABASE_AUTH_TOKEN']}',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final data = Map<String, Object>.from(response.data as Map<String, dynamic>);
        if (kDebugMode) {
          print('Successfully generated image: $data');
        }
        return data;
      } else {
        if (kDebugMode) {
          print('Failed to generate image. Status code: ${response.statusCode}');
        }
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException in generateImage: ${e.message}');
        if (e.response != null) {
          print('Response data: ${e.response?.data}');
          print('Response headers: ${e.response?.headers}');
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error in generateImage: $e');
        print('Stack trace: $stackTrace');
      }
    }
    
    return null;
  }
}
