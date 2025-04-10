import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planora/presentation/blocs/calendar/calendar_bloc.dart';
import 'package:planora/presentation/blocs/calendar/calendar_event.dart';
import 'package:planora/presentation/blocs/calendar/calendar_state.dart';
import 'package:planora/data/events_data_source.dart';
import 'package:planora/core/utilities/font_weights.dart';
import 'package:planora/presentation/pages/schedule/add_schedule.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarViewWidget extends StatefulWidget {
  const CalendarViewWidget({super.key});

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late final CalendarController _controller;
  EventsDataSource? _eventsDataSource;
  bool _isLoading = false;
  DateTime? _lastLoadDate;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _loadEvents();
  }

  @override
  void didUpdateWidget(covariant CalendarViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Schedule a check for date changes after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForDateChanges();
    });
  }

  // Check if we need to load events due to date changes
  void _checkForDateChanges() {
    final currentDate = _controller.selectedDate ?? DateTime.now();
    final currentDateFormatted = DateFormat('yyyy-MM-dd').format(currentDate);
    final lastDateFormatted =
        _lastLoadDate != null
            ? DateFormat('yyyy-MM-dd').format(_lastLoadDate!)
            : null;

    // Only reload if the date has changed
    if (lastDateFormatted != currentDateFormatted) {
      _loadEvents();
    }
  }

  // Load events for the current date
  Future<void> _loadEvents() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _lastLoadDate = _controller.selectedDate ?? DateTime.now();
    });

    try {
      final currentDate = _controller.selectedDate ?? DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
      final result = await EventsHelper.getEventsForDate(formattedDate);

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _errorMessage = failure.toString();
              _isLoading = false;
            });
          }
        },
        (dataSource) {
          if (mounted) {
            setState(() {
              _eventsDataSource = dataSource;
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading events: $e';
          _isLoading = false;
        });
      }
    }
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

          // Instead of directly calling _loadEvents here,
          // schedule it for after the build phase is complete
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkForDateChanges();
          });
        }

        return Stack(
          children: [
            Column(
              children: [
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                Expanded(
                  child: SfCalendar(
                    selectionDecoration: BoxDecoration(border: null),
                    appointmentBuilder: (context, calendarAppointmentDetails) {
                      final appointment =
                          calendarAppointmentDetails.appointments.isNotEmpty
                              ? calendarAppointmentDetails.appointments.first
                              : null;

                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment?.title ?? '',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeights.regular,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (appointment != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                '${DateFormat('HH:mm a').format(appointment.from)} - ${DateFormat('HH:mm a').format(appointment.to)}',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withAlpha(180),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                    headerStyle: CalendarHeaderStyle(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      textStyle: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(
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
                    dataSource:
                        _eventsDataSource ?? EventsDataSource(<Event>[]),
                    onTap: (CalendarTapDetails details) {
                      if (details.targetElement == CalendarElement.header) {
                        return;
                      }
                      if (details.targetElement ==
                          CalendarElement.allDayPanel) {
                        return;
                      }

                      if (details.date != null) {
                        final selectedDate = DateTime(
                          details.date!.year,
                          details.date!.month,
                          details.date!.day,
                          details.date!.hour,
                          details.date!.minute,
                        );

                        final startTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedDate.hour,
                          selectedDate.minute,
                        );

                        // Format the date and times
                        final formattedDate = DateFormat(
                          'yyyy-MM-dd',
                        ).format(selectedDate);
                        final formattedStartTime = DateFormat(
                          'HH:mm',
                        ).format(startTime);

                        context.read<CalendarBloc>().add(
                          UpdateSelectedDate(selectedDate),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AddSchedule(
                                  date: formattedDate,
                                  startTime: formattedStartTime,
                                ),
                          ),
                        ).then((value) {
                          // Reload events when returning from AddSchedule
                          if (value == true) {
                            _loadEvents();
                          }
                        });
                      }
                    },
                    onViewChanged: (ViewChangedDetails details) {
                      // Schedule loading events after build is complete
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _checkForDateChanges();
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
