import 'package:calendar_view/calendar_view.dart';
import 'package:easy_scheduler/databases/hive_events.dart';
import 'package:easy_scheduler/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventController {
  static EventController get to => Get.find<EventController>();

  void addEvent(
    String title,
    DateTime date,
    DateTime startTime,
    DateTime endTime,
    BuildContext context,
  ) {
    EventModel newEvent = EventModel(
      title: title,
      date: date.withoutTime,
      startTime: startTime,
      endTime: endTime,
    );

    CalendarEventData calendarEventData = CalendarEventData(
      title: title,
      date: date.withoutTime,
      startTime: startTime,
      endTime: endTime,
      color: context.theme.colorScheme.primaryFixed,
      titleStyle: TextStyle(
        fontSize: 12,
        color: context.theme.colorScheme.onPrimaryFixed,
      ),
      descriptionStyle: TextStyle(
        fontSize: 12,
        color: context.theme.colorScheme.onPrimaryFixed,
      ),
    );
    HiveEvents.addEventToHive(newEvent);
    CalendarControllerProvider.of(context).controller.add(calendarEventData);
  }
}
