import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/services/pinecone/pinecone_vector_service.dart';
import 'package:planora/services/supabase/supabase_storage_service.dart';
import 'package:planora/services/unsplash/unsplash_image_service.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/helper.dart';

class EventTaskImageService {
  // Handle event image tile generation and processing
  static Future<void> handleImageTileForEvent(EventModel event) async {
    if ((event.eventTileImage.isNotEmpty &&
            event.eventTileImageLocalUrl.isNotEmpty) ||
        event.isImageProcessing) {
      return;
    }

    try {
      // First check if we have a cached image
      File? cachedFile = await CustomImageCacheManager()
          .getCachedImageByEventId(event.id);

      if (cachedFile != null) {
        await HiveEvents.updateEventInHive(
          event.copyWith(
            userId: event.userId,
            attribution: event.attribution,
            eventTileImage: event.eventTileImage,
            eventStatus: event.eventStatus,
            eventTileImageLocalUrl: cachedFile.path,
            isImageProcessing: false,
            createdAt: event.createdAt,
            updatedAt: event.updatedAt,
          ),
        );
        return;
      }

      // Mark as processing
      var processingEvent = event.copyWith(
        userId: event.userId,
        attribution: event.attribution,
        eventTileImage: event.eventTileImage,
        eventStatus: event.eventStatus,
        eventTileImageLocalUrl: event.eventTileImageLocalUrl,
        isImageProcessing: true,
        createdAt: event.createdAt,
        updatedAt: event.updatedAt,
      );
      await HiveEvents.updateEventInHive(processingEvent);

      String? semanticSearchResponse = await _trySemanticSearch(
        event.name + event.description,
      );

      if (semanticSearchResponse != null) {
        await _updateEventWithImage(processingEvent, semanticSearchResponse);
      } else {
        await _generateAndUploadImageForEvent(processingEvent);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing event image: $e');
      }
    }
  }

  // Private helper methods
  static Future<String?> _trySemanticSearch(String query) async {
    return await PineconeVectorService.semanticSearch(query);
  }

  static Future<void> _updateEventWithImage(
    EventModel event,
    String fileUrl,
  ) async {
    try {

      // Cache the image using the download URL
      File? cachedImage = await CustomImageCacheManager().cacheImageByEventId(
        fileUrl,
        event.id,
      );

      if (cachedImage == null) {
        throw Exception('Failed to cache image');
      }

      // Create updated event with local cache path
      final updatedEvent = event.copyWith(
        userId: event.userId,
        attribution: event.attribution,
        eventTileImage: fileUrl,
        eventStatus: event.eventStatus,
        eventTileImageLocalUrl: cachedImage.path,
        isImageProcessing: false,
        createdAt: event.createdAt,
        updatedAt: event.updatedAt,
      );

      // Update local storage
      await HiveEvents.updateEventInHive(updatedEvent);
      
      // Update remote storage
      await FirebaseFirestoreService().updateEventDocument(
        event.id,
        updatedEvent,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error in _updateEventWithImage: $e');
      }
      rethrow;
    }
  }

  static Future<void> _generateAndUploadImageForEvent(EventModel event) async {
    final imageData = await UnsplashImageService.generateImage(
      event.name + event.description,
    );
    if (imageData == null) return;

    // Add attribution
    final updatedEvent = event.copyWith(
      userId: event.userId,
      eventTileImage: event.eventTileImage,
      eventStatus: event.eventStatus,
      eventTileImageLocalUrl: event.eventTileImageLocalUrl,
      isImageProcessing: event.isImageProcessing,
      createdAt: event.createdAt,
      updatedAt: event.updatedAt,
      attribution: Map<String, String>.from(imageData["attribution"] as Map<String, dynamic>),
    );

    // Convert image URL to bytes
    final imageBytes = await Helper().getImageBytes(imageData["image_url"] as String);

    var uri = Uri.parse(imageData["image_url"] as String);
    var fileName =
        '${event.name.replaceAll(' ', '_').toLowerCase()}.${uri.queryParameters['fm']}';
    final contentType = "image/${uri.queryParameters['fm']}";
    final headers = {'Content-Type': contentType};

    String? fileUrl = await _uploadImage(
      fileName,
      imageBytes,
      'event-images',
      headers,
    );
    if (fileUrl == null) return;
    fileUrl =
        "${dotenv.env['SUPABASE_BASE_URL']!}/storage/v1/object/public/$fileUrl";
    await _updateEventWithImage(updatedEvent, fileUrl);
    await PineconeVectorService.upsertNewIndex(
      updatedEvent.name + updatedEvent.description,
      fileUrl,
      updatedEvent.attribution,
    );
  }

  static Future<String?> _uploadImage(
    String fileName,
    Uint8List imageBytes,
    String bucketName,
    Map<String, String> headers,
  ) {
    return SupabaseStorageService.uploadImageUsingBytes(
      fileName,
      bucketName,
      imageBytes,
      headers,
    );
  }
}
