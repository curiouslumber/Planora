import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/services/pinecone/pinecone_vector_service.dart';
import 'package:planora/services/unsplash/unsplash_image_service.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventTaskImageService {
  static const _maxRetryAttempts = 3;
  static const _retryDelay = Duration(seconds: 5);
  
  static final _connectivity = Connectivity();
  static final _imageCache = CustomImageCacheManager();
  static List<Map<String, dynamic>> _pendingUpdates = [];
  static bool _isProcessingQueue = false;

  static const String _processingStateKey = 'image_processing_state';
  static const String _pendingUpdatesKey = 'pending_image_updates';

  static Future<void> initialize() async {
    await _loadProcessingState();
    // Start processing any pending updates on initialization
    if (_pendingUpdates.isNotEmpty) {
      _processQueue();
    }
  }

  /// Main entry point to handle event image processing
  static Future<void> handleImageTileForEvent(EventModel event) async {
    try {
      // Check if image is already processed
      if (event.eventTileImage.isNotEmpty && 
          event.eventTileImageLocalUrl.isNotEmpty) {
        return;
      }

      // Check local cache first
      final cachedFile = await _imageCache.getCachedImageByEventId(event.id);
      if (cachedFile != null) {
        await _updateEventLocalCache(event, cachedFile.path);
        return;
      }

      // Process image based on connectivity
      if (await _isOnline) {
        await _processOnlineImage(event);
      } else {
        await _queueForRetry(event);
      }
    } catch (e) {
      _logError('Error in handleImageTileForEvent', e);
      await _queueForRetry(event);
    }
  }

  static Future<void> _processOnlineImage(EventModel event) async {
    try {
      // Try semantic search first
      final semanticResult = await _trySemanticSearch(
        '${event.name} ${event.description}',
      );

      if (semanticResult != null) {
        await _processSemanticResult(event, semanticResult);
      } else {
        await _generateAndUploadImage(event);
      }
    } catch (e) {
      _logError('Error in _processOnlineImage', e);
      rethrow;
    }
  }

  static Future<void> _processSemanticResult(
    EventModel event,
    Map<String, dynamic> result,
  ) async {
    final imageUrl = result['image_url'] as String? ?? '';
    final attribution = _parseAttribution(result['attribution']);

    final cachedFile = await _imageCache.cacheImageByEventId(
      imageUrl,
      event.id,
    );
    
    if (cachedFile != null) {
      await _updateEventWithImage(
        event,
        imageUrl,
        attribution,
        cachedFile.path,
      );
    } else {
      throw Exception('Failed to cache image from semantic search');
    }
  }

  static Future<void> _generateAndUploadImage(EventModel event) async {
    try {
      final imageData = await UnsplashImageService.generateImage(
        '${event.name} ${event.description}',
      );

      if (imageData == null) {
        throw Exception('Failed to generate image');
      }

      final imageUrl = imageData['image_url'] as String;
      final cachedFile = await _imageCache.cacheImageByEventId(
        imageUrl,
        event.id,
      );

      if (cachedFile != null) {
        await _updateEventWithImage(
          event,
          imageUrl,
          _parseAttribution(imageData['attribution']),
          cachedFile.path,
        );
      } else {
        throw Exception('Failed to cache generated image');
      }
    } catch (e) {
      _logError('Error in _generateAndUploadImage', e);
      rethrow;
    }
  }

  static Future<void> _updateEventWithImage(
    EventModel event,
    String imageUrl,
    Map<String, dynamic>? attribution,
    String localPath,
  ) async {
    try {
      final updatedEvent = event.copyWith(
        eventTileImage: imageUrl,
        eventTileImageLocalUrl: localPath,
        isImageProcessing: false,
        updatedAt: DateTime.now(),
        attribution: attribution != null
            ? Map<String, String>.from(attribution)
            : event.attribution,
        userId: event.userId,
        eventStatus: event.eventStatus,
        createdAt: event.createdAt,
      );

      await HiveEvents.updateEventInHive(updatedEvent);
      
      // Notify listeners that an image was updated
      EventBus().fireImageUpdated(event.id);
      
    } catch (e) {
      _logError('Error in _updateEventWithImage', e);
      rethrow;
    }
  }

  static Future<void> _updateEventLocalCache(
    EventModel event,
    String localPath,
  ) async {
    try {
      await HiveEvents.updateEventInHive(
        event.copyWith(
          eventTileImageLocalUrl: localPath,
          isImageProcessing: false,
          updatedAt: DateTime.now(),
          userId: event.userId,
          eventTileImage: event.eventTileImage,
          eventStatus: event.eventStatus,
          createdAt: event.createdAt,
          attribution: event.attribution,
        ),
      );
    } catch (e) {
      _logError('Error in _updateEventLocalCache', e);
      rethrow;
    }
  }

  static Future<void> _queueForRetry(EventModel event) async {
    try {
      // Check if already in queue
      final existingIndex = _pendingUpdates.indexWhere((e) => e['id'] == event.id);
      
      if (existingIndex >= 0) {
        final existing = _pendingUpdates[existingIndex];
        final retryCount = (existing['retryCount'] as int) + 1;
        
        if (retryCount >= _maxRetryAttempts) {
          _pendingUpdates.removeAt(existingIndex);
          _logError('Max retries reached for event ${event.id}, removing from queue', null);
          return;
        }
        
        existing['retryCount'] = retryCount;
        existing['lastRetry'] = DateTime.now();
      } else {
        _pendingUpdates.add({
          'id': event.id,
          'event': event,
          'retryCount': 0,
          'lastRetry': DateTime.now(),
        });
      }

      await _saveProcessingState();

      if (!_isProcessingQueue) {
        _processQueue();
      }
    } catch (e) {
      _logError('Error in _queueForRetry', e);
    }
  }

  static Future<void> _processQueue() async {
    if (_isProcessingQueue || _pendingUpdates.isEmpty) return;
    _isProcessingQueue = true;

    try {
      while (_pendingUpdates.isNotEmpty) {
        final item = _pendingUpdates.removeAt(0);
        final event = item['event'] as EventModel;
        final retryCount = item['retryCount'] as int;

        if (retryCount >= _maxRetryAttempts) {
          _logError('Max retries reached for event ${event.id}, skipping', null);
          continue;
        }

        try {
          if (kDebugMode) {
            print('Processing event ${event.id}, attempt ${retryCount + 1}');
          }
          
          await handleImageTileForEvent(event);
          
          if (kDebugMode) {
            print('Successfully processed event ${event.id}');
          }
        } catch (e) {
          _logError('Error processing event ${event.id}', e);
          
          // Re-add to queue if we haven't reached max retries
          if (retryCount + 1 < _maxRetryAttempts) {
            _pendingUpdates.add({
              'id': event.id,
              'event': event,
              'retryCount': retryCount + 1,
              'lastRetry': DateTime.now(),
            });
            
            // Add delay before next retry
            await Future.delayed(_retryDelay);
          } else {
            _logError('Max retries reached for event ${event.id}, giving up', null);
          }
        }
        
        await _saveProcessingState();
      }
    } finally {
      _isProcessingQueue = false;
      await _saveProcessingState();
    }
  }

  static Future<void> _saveProcessingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_processingStateKey, json.encode({
        'isProcessing': _isProcessingQueue,
        'lastUpdated': DateTime.now().toIso8601String(),
      }));

      await prefs.setString(_pendingUpdatesKey, json.encode(
        _pendingUpdates.map((e) => {
          'id': e['id'],
          'event': (e['event'] as EventModel).toJson(),
          'retryCount': e['retryCount'],
          'lastRetry': (e['lastRetry'] as DateTime).toIso8601String(),
        }).toList(),
      ));
    } catch (e) {
      _logError('Error saving processing state', e);
    }
  }

  static Future<void> _loadProcessingState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load processing state
      final stateJson = prefs.getString(_processingStateKey);
      if (stateJson != null) {
        final state = json.decode(stateJson) as Map<String, dynamic>;
        _isProcessingQueue = state['isProcessing'] ?? false;
      }

      // Load pending updates
      final updatesJson = prefs.getString(_pendingUpdatesKey);
      if (updatesJson != null) {
        final List<dynamic> updates = json.decode(updatesJson);
        _pendingUpdates = updates.map((e) => {
          'id': e['id'],
          'event': EventModel.fromJson(Map<String, dynamic>.from(e['event'])),
          'retryCount': e['retryCount'],
          'lastRetry': DateTime.parse(e['lastRetry']),
        }).toList();
      }
    } catch (e) {
      _logError('Error loading processing state', e);
      _pendingUpdates = [];
    }
  }

  static Map<String, dynamic> _parseAttribution(dynamic rawAttribution) {
    if (rawAttribution == null) return {};
    if (rawAttribution is Map) return Map<String, dynamic>.from(rawAttribution);
    if (rawAttribution is String) {
      try {
        return json.decode(rawAttribution) as Map<String, dynamic>;
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  static Future<bool> get _isOnline async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      _logError('Error checking connectivity', e);
      return false;
    }
  }

  static Future<Map<String, dynamic>?> _trySemanticSearch(String query) async {
    try {
      if (!await _isOnline) {
        if (kDebugMode) {
          print('Skipping semantic search - device is offline');
        }
        return null;
      }

      final result = await PineconeVectorService.semanticSearch(query);

      if (kDebugMode) {
        print('Semantic search result: $result');
      }

      return result;
    } catch (e) {
      _logError('Error in _trySemanticSearch', e);
      return null;
    }
  }

  static void _logError(String message, dynamic error) {
    if (kDebugMode) {
      print('$message: $error');
    }
  }

  /// Public method to manually trigger processing of pending updates
  static void retryPendingUpdates() {
    if (!_isProcessingQueue && _pendingUpdates.isNotEmpty) {
      _processQueue();
    }
  }
}

// Define the ImageUpdatedEvent class
class ImageUpdatedEvent {
  final String eventId;

  ImageUpdatedEvent(this.eventId);
}
