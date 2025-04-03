import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planora/data/events_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewWidget extends StatefulWidget {
  const CalendarViewWidget({super.key});

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
      initialDisplayDate: DateTime.now(),
      showNavigationArrow: true,
      showDatePickerButton: true,
      initialSelectedDate: DateTime.now(),
      allowAppointmentResize: true,
      controller: CalendarController(),
      allowViewNavigation: false,
      showCurrentTimeIndicator: true,
      headerDateFormat: "EEE, d MMM yyyy",
      cellBorderColor: context.theme.colorScheme.primary.withAlpha(100),
      dataSource: EventsDataSource(<Event>[
        Event(
          'Meeting',
          DateTime.now(),
          DateTime.now().add(Duration(minutes: 60)),
          context.theme.colorScheme.secondary,
          false,
        ),
      ]),
    );
  }
}
