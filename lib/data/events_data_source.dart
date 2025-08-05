import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsDataSource extends CalendarDataSource {
  EventsDataSource(List<Event> source) {
    appointments = source;
  }

  String getEventId(int index) {
    return appointments![index].id;
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

class Event {
  Event(this.eventName, this.id, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  String id;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
