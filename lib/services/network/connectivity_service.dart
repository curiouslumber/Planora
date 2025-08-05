import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/services/common/event_task_image_service.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isProcessing = false;

  // Singleton pattern
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  // Initialize the service and start listening for connectivity changes
  Future<void> initialize() async {
    // Initialize the EventTaskImageService
    await EventTaskImageService.initialize();
    
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChange,
      onError: (error) {
        if (kDebugMode) {
          print('Connectivity error: $error');
        }
      },
    );
    
    // Initial check
    final result = await _connectivity.checkConnectivity();
    if (result != ConnectivityResult.none) {
      await _processEventsNeedingImages();
    }
  }

  // Handle connectivity changes
  Future<void> _handleConnectivityChange(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      if (kDebugMode) {
        print('Network connection restored, checking for events needing images...');
      }
      await _processEventsNeedingImages();
      
      // Trigger processing of any pending updates in the queue
      EventTaskImageService.retryPendingUpdates();
    }
  }

  // Process events that don't have images but should
  Future<void> _processEventsNeedingImages() async {
    if (_isProcessing) return;
    _isProcessing = true;
    
    try {
      // Get all events that don't have both a remote and local image URL
      final events = await HiveEvents.getEventsFromHive();
      final eventsNeedingImages = events.where((event) => 
        event.eventTileImage.isEmpty || event.eventTileImageLocalUrl.isEmpty
      ).toList();

      if (kDebugMode) {
        print('Found ${eventsNeedingImages.length} events needing images');
      }

      // Process each event that needs an image
      for (final event in eventsNeedingImages) {
        try {
          await EventTaskImageService.handleImageTileForEvent(event);
          // Small delay to prevent overwhelming the system
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          if (kDebugMode) {
            print('Error queueing image for event ${event.id}: $e');
          }
          // The error is already handled by EventTaskImageService's retry mechanism
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in _processEventsNeedingImages: $e');
      }
    } finally {
      _isProcessing = false;
    }
  }

  // Clean up resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }
}