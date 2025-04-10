import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:planora/data/models/event_model.dart';
import 'package:planora/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:planora/di/service_locator.dart';

/// A data source for calendar events that extends [CalendarDataSource].
/// This class provides the necessary implementations for displaying events
/// in a calendar view.
class EventsDataSource extends CalendarDataSource {
  /// Creates a new instance of [EventsDataSource] with the given list of events.
  ///
  /// [source] is the list of events to be displayed in the calendar.
  EventsDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].backgroundColor;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String getId(int index) {
    return appointments![index].id;
  }

  // Allow access to the appointments list with proper type
  List<Event> get events => List.generate(
    appointments!.length,
    (index) => appointments![index] as Event,
  );
}

/// Represents a calendar event with immutable properties.
///
/// This class holds all the necessary information for displaying an event
/// in the calendar view, including its name, time range, color, and whether
/// it's an all-day event.
class Event {
  /// Creates a new instance of [Event].
  ///
  /// [id] is the unique identifier of the event.
  /// [title] is the title of the event.
  /// [from] is the start time of the event.
  /// [to] is the end time of the event.
  /// [backgroundColor] is the color of the event in the calendar.
  /// [isAllDay] indicates whether the event spans the entire day.
  const Event({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.blue,
    this.isAllDay = false,
  });

  /// The unique identifier of the event.
  final String id;

  /// The title of the event.
  final String title;

  /// The start time of the event.
  final DateTime from;

  /// The end time of the event.
  final DateTime to;

  /// The color of the event in the calendar.
  final Color backgroundColor;

  /// Whether the event spans the entire day.
  final bool isAllDay;
}

// Helper class to fetch events from the database and convert them to Calendar events
class EventsHelper {
  static Future<Either<Failure, EventsDataSource>> getEventsForDate(
    String date,
  ) async {
    try {
      final dbService = getIt<DatabaseService>();
      final eventsResult = await dbService.getEventsForDate(date);

      return eventsResult.fold((failure) => Left(failure), (events) {
        final calendarEvents = _convertToCalendarEvents(events);
        return Right(EventsDataSource(calendarEvents));
      });
    } catch (e) {
      return Left(DatabaseFailure('Error loading events: $e'));
    }
  }

  static Future<Either<Failure, EventsDataSource>> getAllEvents() async {
    try {
      final dbService = getIt<DatabaseService>();
      final eventsResult = await dbService.getAllEvents();

      return eventsResult.fold((failure) => Left(failure), (events) {
        final calendarEvents = _convertToCalendarEvents(events);
        return Right(EventsDataSource(calendarEvents));
      });
    } catch (e) {
      return Left(DatabaseFailure('Error loading all events: $e'));
    }
  }

  // Helper method to convert EventModel list to Event list
  static List<Event> _convertToCalendarEvents(List<EventModel> events) {
    return events.map((event) {
      try {
        // Parse date
        final date = DateFormat('yyyy-MM-dd').parse(event.date);

        // Parse times
        final startTimeParts = event.startTime.split(':');
        final startHour = int.parse(startTimeParts[0]);
        final startMinute = int.parse(startTimeParts[1]);

        final endTimeParts = event.endTime.split(':');
        final endHour = int.parse(endTimeParts[0]);
        final endMinute = int.parse(endTimeParts[1]);

        // Create from and to DateTimes
        final from = DateTime(
          date.year,
          date.month,
          date.day,
          startHour,
          startMinute,
        );

        final to = DateTime(
          date.year,
          date.month,
          date.day,
          endHour,
          endMinute,
        );

        return Event(
          id: event.id,
          title: event.title,
          from: from,
          to: to,
          backgroundColor:
              event.isCompleted ? Colors.green.shade300 : Colors.blue.shade300,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing event: $e');
        }
        // Return a default event if parsing fails
        return Event(
          id: event.id,
          title: event.title,
          from: DateTime.now(),
          to: DateTime.now().add(const Duration(hours: 1)),
          backgroundColor: Colors.grey,
        );
      }
    }).toList();
  }
}
