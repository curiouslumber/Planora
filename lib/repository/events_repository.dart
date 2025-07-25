import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/app_config.dart';
import 'base_repository.dart';

class EventsRepository extends BaseRepository<EventModel, String> {
  EventsRepository() : super(boxName: 'events', collectionName: 'events');

  @override
  EventModel fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      eventTileImage: data['eventTileImage'] ?? '',
      eventTileImageLocalUrl: data['eventTileImageLocalUrl'] ?? '',
      isImageProcessing: data['isImageProcessing'] ?? false,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      startDate: data['startDate'],
      endDate: data['endDate'],
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      meeting: data['meeting'],
      eventStatus: data['eventStatus'] ?? 'upcoming',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      attribution: data['attribution'] != null 
          ? Map<String, String>.from(data['attribution']) 
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap(EventModel event) {
    return {
      'id': event.id,
      'userId': event.userId,
      'eventTileImage': event.eventTileImage,
      'eventTileImageLocalUrl': event.eventTileImageLocalUrl,
      'isImageProcessing': event.isImageProcessing,
      'name': event.name,
      'description': event.description,
      'startDate': event.startDate,
      'endDate': event.endDate,
      'startTime': event.startTime,
      'endTime': event.endTime,
      'meeting': event.meeting,
      'eventStatus': event.eventStatus,
      'createdAt': event.createdAt,
      'updatedAt': DateTime.now(),
      'attribution': event.attribution,
    };
  }

  @override
  String getId(EventModel item) => item.id;

  /// Gets events filtered by status (e.g., 'upcoming', 'ongoing', 'completed')
  Future<List<EventModel>> getEventsByStatus(String status) async {
    if (AppConfig.isCloudSyncEnabled) {
      try {
        final query = FirebaseFirestore.instance
            .collection(collectionName)
            .where('eventStatus', isEqualTo: status);
        final snapshot = await query.get();
        return snapshot.docs.map((doc) => fromDocument(doc)).toList();
      } catch (e) {
        debugPrint('Error filtering events by status from cloud: $e');
      }
    }

    final events = await getAll();
    return events.where((event) => event.eventStatus == status).toList();
  }

  /// Gets upcoming events (events with start date today or in the future)
  Future<List<EventModel>> getUpcomingEvents() async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    if (AppConfig.isCloudSyncEnabled) {
      try {
        final query = FirebaseFirestore.instance
            .collection(collectionName)
            .where('startDate', isGreaterThanOrEqualTo: today)
            .orderBy('startDate')
            .limit(10);
            
        final snapshot = await query.get();
        return snapshot.docs.map((doc) => fromDocument(doc)).toList();
      } catch (e) {
        debugPrint('Error fetching upcoming events from cloud: $e');
      }
    }

    final events = await getAll();
    return events
        .where((event) => event.startDate.compareTo(today) >= 0)
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  /// Updates the event status (e.g., from 'upcoming' to 'completed')
  Future<void> updateEventStatus(String eventId, String status) async {
    final event = await get(eventId);
    if (event != null) {
      final updatedEvent = event.copyWith(
        userId: event.userId,
        eventTileImage: event.eventTileImage,
        eventTileImageLocalUrl: event.eventTileImageLocalUrl,
        isImageProcessing: event.isImageProcessing,
        eventStatus: status,
        createdAt: event.createdAt,
        updatedAt: DateTime.now(),
        attribution: event.attribution,
      );
      await save(updatedEvent);
    }
  }
}
