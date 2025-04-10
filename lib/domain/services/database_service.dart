import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:planora/data/models/event_model.dart';
import 'package:uuid/uuid.dart';

// Define failure classes for better error handling
abstract class Failure {
  final String message;

  const Failure(this.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Service to handle event data storage with Hive
class DatabaseService {
  static const String _eventsBoxName = 'events_box';
  static const String _eventsBoxTypedName = 'events_typed_box';
  static DatabaseService? _instance;
  late Box<String> _eventsBox;
  late Box<EventModel> _eventsBoxTyped;
  final _uuid = const Uuid();

  // Private constructor
  DatabaseService._();

  // Singleton pattern
  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      _instance = DatabaseService._();
      await _instance!._init();
    }
    return _instance!;
  }

  // Initialize and open the box
  Future<void> _init() async {
    // Open the box to store events as JSON strings
    _eventsBox = await Hive.openBox<String>(_eventsBoxName);

    try {
      // Try to open the typed box
      _eventsBoxTyped = await Hive.openBox<EventModel>(_eventsBoxTypedName);

      // If there's data in the old box but not in the typed box, migrate it
      if (_eventsBox.isNotEmpty && _eventsBoxTyped.isEmpty) {
        await _migrateDataToTypedBox();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error opening typed box: $e');
      }
      // If the typed box can't be opened, we'll continue with the string-based approach
    }
  }

  // Migrate data from string-based box to typed box
  Future<Either<DatabaseFailure, bool>> _migrateDataToTypedBox() async {
    try {
      final eventsResult = await getAllEvents();

      return eventsResult.fold((failure) => Left(failure), (events) async {
        for (var event in events) {
          await _eventsBoxTyped.put(event.id, event);
        }
        if (kDebugMode) {
          print('Data migrated to typed box');
        }
        return const Right(true);
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error migrating data: $e');
      }
      return Left(DatabaseFailure('Failed to migrate data: $e'));
    }
  }

  // Add a new event
  Future<Either<DatabaseFailure, EventModel>> addEvent({
    required String title,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      // Create a new event with a unique ID
      final event = EventModel(
        id: _uuid.v4(), // Generate a unique ID
        title: title,
        date: date,
        startTime: startTime,
        endTime: endTime,
      );

      // Add the event to the box
      final result = await saveEvent(event);

      return result.fold((failure) => Left(failure), (_) => Right(event));
    } catch (e) {
      return Left(DatabaseFailure('Failed to add event: $e'));
    }
  }

  // Save an event to the box
  Future<Either<DatabaseFailure, Unit>> saveEvent(EventModel event) async {
    try {
      // Try to save to the typed box first
      if (Hive.isBoxOpen(_eventsBoxTypedName)) {
        await _eventsBoxTyped.put(event.id, event);
      }

      // Always save to the string-based box as a fallback
      final eventsResult = await getAllEvents();

      return eventsResult.fold((failure) => Left(failure), (events) async {
        // Add the new event or update existing one
        final updatedEvents = _updateEventInList(events, event);

        // Save the updated list
        final eventsJson = jsonEncode({
          'events': updatedEvents.map((e) => e.toJson()).toList(),
        });
        await _eventsBox.put('eventsList', eventsJson);

        return const Right(unit);
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to save event: $e'));
    }
  }

  // Helper to update an event in the list or add it if not found
  List<EventModel> _updateEventInList(
    List<EventModel> events,
    EventModel event,
  ) {
    final index = events.indexWhere((e) => e.id == event.id);

    if (index >= 0) {
      // Replace the existing event
      return [...events]..replaceRange(index, index + 1, [event]);
    } else {
      // Add the new event
      return [...events, event];
    }
  }

  // Get all events
  Future<Either<DatabaseFailure, List<EventModel>>> getAllEvents() async {
    try {
      // Try to get from typed box first
      if (Hive.isBoxOpen(_eventsBoxTypedName) && _eventsBoxTyped.isNotEmpty) {
        return Right(_eventsBoxTyped.values.toList());
      }

      // Fallback to string-based storage
      final eventsJson = _eventsBox.get('eventsList');

      if (eventsJson == null) {
        return const Right([]);
      }

      final Map<String, dynamic> decodedJson = jsonDecode(eventsJson);
      final List<dynamic> eventsList = decodedJson['events'] ?? [];

      final events =
          eventsList
              .map((eventJson) => EventModel.fromJson(eventJson))
              .toList();

      return Right(events);
    } catch (e) {
      return Left(DatabaseFailure('Failed to get events: $e'));
    }
  }

  // Get events for a specific date
  Future<Either<DatabaseFailure, List<EventModel>>> getEventsForDate(
    String date,
  ) async {
    try {
      final eventsResult = await getAllEvents();

      return eventsResult.fold((failure) => Left(failure), (events) {
        final filteredEvents =
            events.where((event) => event.date == date).toList();
        return Right(filteredEvents);
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to get events for date: $e'));
    }
  }

  // Update an event
  Future<Either<DatabaseFailure, Unit>> updateEvent(EventModel event) async {
    return saveEvent(event);
  }

  // Delete an event
  Future<Either<DatabaseFailure, Unit>> deleteEvent(String id) async {
    try {
      // Try to delete from typed box first
      if (Hive.isBoxOpen(_eventsBoxTypedName)) {
        await _eventsBoxTyped.delete(id);
      }

      // Also delete from string-based storage
      final eventsResult = await getAllEvents();

      return eventsResult.fold((failure) => Left(failure), (events) async {
        final updatedEvents = events.where((event) => event.id != id).toList();

        final eventsJson = jsonEncode({
          'events': updatedEvents.map((e) => e.toJson()).toList(),
        });
        await _eventsBox.put('eventsList', eventsJson);

        return const Right(unit);
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete event: $e'));
    }
  }

  // Mark event as completed or not completed
  Future<Either<DatabaseFailure, Unit>> toggleEventCompletion(
    String id,
    bool isCompleted,
  ) async {
    try {
      // Get the event first
      final eventsResult = await getAllEvents();

      return eventsResult.fold((failure) => Left(failure), (events) async {
        // Find the event
        final eventIndex = events.indexWhere((e) => e.id == id);
        if (eventIndex < 0) {
          return Left(DatabaseFailure('Event not found'));
        }

        final event = events[eventIndex];
        final updatedEvent = event.copyWith(isCompleted: isCompleted);

        // Save the updated event
        return saveEvent(updatedEvent);
      });
    } catch (e) {
      return Left(DatabaseFailure('Failed to toggle event completion: $e'));
    }
  }

  // Clear all events
  Future<Either<DatabaseFailure, Unit>> clearAllEvents() async {
    try {
      // Clear both boxes
      if (Hive.isBoxOpen(_eventsBoxTypedName)) {
        await _eventsBoxTyped.clear();
      }
      await _eventsBox.clear();
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure('Failed to clear events: $e'));
    }
  }
}
