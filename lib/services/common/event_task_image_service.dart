import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/task_model.dart';
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

  static Future<void> handleImageTileForTask(TaskModel task) async {
    // If already has an image or is already being processed, return
    if ((task.taskTileImage.isNotEmpty &&
            task.taskTileImageLocalUrl.isNotEmpty) ||
        task.isImageProcessing) {
      return;
    }

    try {
      // First check if we have a cached image
      File? cachedFile = await CustomImageCacheManager()
          .getCachedImageByEventId(task.id);

      if (cachedFile != null) {
        await HiveEvents.updateTaskInHive(
          task.copyWith(
            taskTileImage: task.taskTileImage,
            taskStatus: task.taskStatus,
            taskTileImageLocalUrl: cachedFile.path,
            isImageProcessing: false,
          ),
        );
        return;
      }

      // Mark as processing
      var processingTask = task.copyWith(
        taskTileImage: task.taskTileImage,
        taskStatus: task.taskStatus,
        taskTileImageLocalUrl: task.taskTileImageLocalUrl,
        isImageProcessing: true,
      );
      await HiveEvents.updateTaskInHive(processingTask);

      String? semanticSearchResponse = await _trySemanticSearch(
        task.name + task.description,
      );

      if (semanticSearchResponse != null) {
        await _updateTaskWithImage(processingTask, semanticSearchResponse);
      } else {
        await _generateAndUploadImageForTask(processingTask);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error processing task image: $e');
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

  static Future<void> _updateTaskWithImage(
    TaskModel task,
    String gsUrl,
  ) async {
    try {
      // Then get a download URL for caching
      final downloadUrl = await Helper.getDownloadUrl(gsUrl);

      // Cache the image using the download URL
      File? cachedImage = await CustomImageCacheManager().cacheImageByEventId(
        downloadUrl,
        task.id,
      );

      if (cachedImage == null) {
        throw Exception('Failed to cache image');
      }

      // Create updated task with local cache path
      final updatedTask = task.copyWith(
        taskTileImage: gsUrl,
        taskStatus: task.taskStatus,
        taskTileImageLocalUrl: cachedImage.path,
        isImageProcessing: false,
      );

      // Update local storage
      await HiveEvents.updateTaskInHive(updatedTask);
      
      // Update remote storage
      await FirebaseFirestoreService().updateTaskDocument(task.id, updatedTask);
    } catch (e) {
      if (kDebugMode) {
        print('Error in _updateTaskWithImage: $e');
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

  static Future<void> _generateAndUploadImageForTask(TaskModel task) async {
    final imageBytes = await FirebaseAiService().generateImage(
      task.name + task.description,
    );
    if (imageBytes == null) return;

    final gsUrl = await _uploadImage(imageBytes, task.name);
    if (gsUrl != null) {
      await _updateTaskWithImage(task, gsUrl);
      await PineconeVectorService.upsertNewIndex(
        task.name + task.description,
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
