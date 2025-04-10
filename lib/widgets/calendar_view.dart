import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planora/blocs/calendar/calendar_bloc.dart';
import 'package:planora/blocs/calendar/calendar_event.dart';
import 'package:planora/blocs/calendar/calendar_state.dart';
import 'package:planora/data/events_data_source.dart';
import 'package:planora/views/schedule/add_schedule.dart';
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
          _controller.displayDate = state.selectedDate;
          _controller.selectedDate = state.selectedDate;
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
          cellBorderColor: Theme.of(context).colorScheme.primary,
          dataSource: EventsDataSource(<Event>[]),
          onTap: (CalendarTapDetails details) {
            if (details.date != null) {
              final selectedDate = DateTime(
                details.date!.year,
                details.date!.month,
                details.date!.day,
              );
              context.read<CalendarBloc>().add(
                UpdateSelectedDate(selectedDate),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AddSchedule(
                        date:
                            DateFormat(
                              'yyyy-MM-dd',
                            ).format(selectedDate).toString(),
                      ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
