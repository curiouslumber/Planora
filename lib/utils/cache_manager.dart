// In cache_manager.dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:planora/utils/helper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImageCacheManager extends CacheManager {
  static const key = 'customImageCache';

  static final CustomImageCacheManager _instance = CustomImageCacheManager._();

  factory CustomImageCacheManager() {
    return _instance;
  }

  CustomImageCacheManager._()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 100,
        ),
      );

  // Handles downloading and caching an image, converting GS URLs to download URLs if needed
  Future<File?> cacheImageByEventId(String imageUrl, String eventId) async {
    try {
      // First check if we already have this cached
      final fileInfo = await getFileFromCache(eventId);
      if (fileInfo != null) {
        return fileInfo.file;
      }

      String downloadUrl = imageUrl;

      // Convert GS URL to download URL if needed
      if (imageUrl.startsWith('gs://')) {
        downloadUrl = await Helper.getDownloadUrl(imageUrl);
      }

      // Download and cache the file using the download URL
      final file = await getSingleFile(
        downloadUrl,
        key: eventId,
        headers: {'Cache-Control': 'max-age=2592000'}, // 30 days cache
      );
      
      return file;
    } catch (e) {
      if (kDebugMode) {
        print('Error caching image for event $eventId: $e');
      }
      return null;
    }
  }

  Future<File?> getCachedImageByEventId(String eventId) async {
    try {
      final fileInfo = await getFileFromCache(eventId);
      return fileInfo?.file;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting cached image: $e');
      }
      return null;
    }
  }
}
