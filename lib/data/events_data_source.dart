import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

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
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

/// Represents a calendar event with immutable properties.
///
/// This class holds all the necessary information for displaying an event
/// in the calendar view, including its name, time range, color, and whether
/// it's an all-day event.
class Event {
  /// Creates a new instance of [Event].
  ///
  /// [eventName] is the title of the event.
  /// [from] is the start time of the event.
  /// [to] is the end time of the event.
  /// [background] is the color of the event in the calendar.
  /// [isAllDay] indicates whether the event spans the entire day.
  const Event(
    this.eventName,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
  );

  /// The title of the event.
  final String eventName;

  /// The start time of the event.
  final DateTime from;

  /// The end time of the event.
  final DateTime to;

  /// The color of the event in the calendar.
  final Color background;

  /// Whether the event spans the entire day.
  final bool isAllDay;
}
