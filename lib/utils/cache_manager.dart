import 'dart:io';

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

  Future<File?> cacheImageByEventId(String imageUrl, String eventId) async {
    return await CustomImageCacheManager().getSingleFile(
      imageUrl,
      key: eventId,
    );
  }

  Future<File?> getCachedImageByEventId(String eventId) async {
    final fileInfo = await CustomImageCacheManager().getFileFromCache(eventId);
    return fileInfo?.file;
  }
}
