import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/blocs/calendar/calendar_bloc.dart';
import 'package:planora/blocs/calendar/calendar_event.dart';
import 'package:planora/blocs/calendar/calendar_state.dart';
import 'package:planora/data/events_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewWidget extends StatefulWidget {
  const CalendarViewWidget({super.key});

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late final CalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        // Sync controller's display date with state
        if (_controller.displayDate != state.selectedDate) {
          _controller.displayDate = state.selectedDate.subtract(
            Duration(minutes: 90),
          );
        }

        return SfCalendar(
          headerStyle: CalendarHeaderStyle(
            backgroundColor: Theme.of(context).colorScheme.surface,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          view: CalendarView.day,
          showNavigationArrow: true,
          showDatePickerButton: true,
          allowAppointmentResize: true,
          controller: _controller,
          allowViewNavigation: false,
          showCurrentTimeIndicator: true,
          headerDateFormat: "EEE, d MMM yyyy",
          cellBorderColor: Theme.of(context).colorScheme.primary.withAlpha(100),
          dataSource: EventsDataSource(<Event>[]),
          onTap: (CalendarTapDetails details) {
            if (details.date != null) {
              context.read<CalendarBloc>().add(
                UpdateSelectedDate(details.date!),
              );
            }
          },
        );
      },
    );
  }
}
