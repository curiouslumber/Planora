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
            eventTileImageLocalUrl: cachedFile.path, // Use the local file path
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

      String imageUrl;
      if (semanticSearchResponse != null) {
        imageUrl = semanticSearchResponse;
      } else {
        await _generateAndUploadImageForEvent(processingEvent);
        imageUrl = processingEvent.eventTileImage;
      }

      // Download and cache the image
      File? cachedImage = await CustomImageCacheManager().cacheImageByEventId(
        imageUrl,
        event.id,
      );

      if (cachedImage == null) {
        throw Exception('Failed to cache image');
      }

      // Update with new image URL and cache path
      await HiveEvents.updateEventInHive(
        processingEvent.copyWith(
          eventTileImage: imageUrl,
          eventStatus: event.eventStatus,
          eventTileImageLocalUrl: cachedImage.path, // Store the local file path
          isImageProcessing: false,
        ),
      );
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

      String imageUrl;
      if (semanticSearchResponse != null) {
        imageUrl = semanticSearchResponse;
      } else {
        await _generateAndUploadImageForTask(processingTask);
        imageUrl = processingTask.taskTileImage;
      }

      // Download and cache the image
      File? cachedImage = await CustomImageCacheManager().cacheImageByEventId(
        imageUrl,
        task.id,
      );

      if (cachedImage == null) {
        throw Exception('Failed to cache image');
      }

      // Update with new image URL and cache path
      await HiveEvents.updateTaskInHive(
        processingTask.copyWith(
          taskTileImage: imageUrl,
          taskStatus: task.taskStatus,
          taskTileImageLocalUrl: cachedImage.path,
          isImageProcessing: false,
        ),
      );
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
    String imageUrl,
  ) async {
    final updatedEvent = event.copyWith(
      eventTileImage: imageUrl,
      eventStatus: event.eventStatus,
      eventTileImageLocalUrl: event.eventTileImageLocalUrl,
      isImageProcessing: false,
    );

    await HiveEvents.updateEventInHive(updatedEvent);
    await FirebaseFirestoreService().updateEventDocument(
      event.id,
      updatedEvent,
    );
  }

  static Future<void> _updateTaskWithImage(
    TaskModel task,
    String imageUrl,
  ) async {
    final updatedTask = task.copyWith(
      taskTileImage: imageUrl,
      taskStatus: task.taskStatus,
      taskTileImageLocalUrl: task.taskTileImageLocalUrl,
      isImageProcessing: false,
    );

    await HiveEvents.updateTaskInHive(updatedTask);
    await FirebaseFirestoreService().updateTaskDocument(task.id, updatedTask);
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
