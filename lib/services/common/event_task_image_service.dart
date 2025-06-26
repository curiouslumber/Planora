import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/services/firebase/firebase_ai_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/services/firebase/firebase_storage_service.dart';
import 'package:planora/services/pinecone/pinecone_vector_service.dart';
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
    String gsUrl,
  ) async {
    try {
      // Get a download URL for caching
      final downloadUrl = await Helper.getDownloadUrl(gsUrl);

      // Cache the image using the download URL
      File? cachedImage = await CustomImageCacheManager().cacheImageByEventId(
        downloadUrl,
        event.id,
      );

      if (cachedImage == null) {
        throw Exception('Failed to cache image');
      }

      // Create updated event with local cache path
      final updatedEvent = event.copyWith(
        eventTileImage: gsUrl,
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
    final imageBytes = await FirebaseAiService().generateImage(
      event.name + event.description,
    );
    if (imageBytes == null) return;

    final gsUrl = await _uploadImage(imageBytes, event.name);
    if (gsUrl != null) {
      await _updateEventWithImage(event, gsUrl);
      await PineconeVectorService.upsertNewIndex(
        event.name + event.description,
        gsUrl,
      );
    }
  }

  static Future<String?> _uploadImage(Uint8List imageBytes, String name) {
    return FirebaseStorageService().uploadImageUsingBytes(
      '${name.replaceAll(' ', '_').toLowerCase()}.png',
      'event_images',
      imageBytes,
    );
  }
}
