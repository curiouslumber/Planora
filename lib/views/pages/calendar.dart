import 'package:flutter/material.dart';
import 'package:planora/data/events_data_source.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarController _monthController = CalendarController();
  final CalendarController _dayController = CalendarController();
  DateTime _selectedDate = DateTime.now();
  List<EventModel> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      _events = await HiveEvents.getEventsFromHive();
    } catch (e) {
      // Handle error
      debugPrint('Error loading events: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events
        .where((event) {
          final eventDate = DateTime.parse(event.startDate);
          return eventDate.year == day.year &&
              eventDate.month == day.month &&
              eventDate.day == day.day;
        })
        .map((event) => Event(
              event.name,
              DateTime.parse(event.startDate),
              event.endDate != null
                  ? DateTime.parse(event.endDate!)
                  : DateTime.parse(event.startDate).add(const Duration(hours: 1)),
              Theme.of(context).colorScheme.secondary,
              false,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 0.0,
                  bottom: 0.0,
                ),
                child: Column(
                  children: [
                    // Month View (50% of screen)
                    Expanded(
                      child: SfCalendar(
                        controller: _monthController,
                        view: CalendarView.month,
                        initialDisplayDate: _selectedDate,
                        initialSelectedDate: _selectedDate,
                        showNavigationArrow: true,
                        showDatePickerButton: true,
                        firstDayOfWeek: 1,
                        viewNavigationMode: ViewNavigationMode.snap,
                        selectionDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onTap: (CalendarTapDetails details) {
                          if (details.targetElement == CalendarElement.calendarCell) {
                            setState(() {
                              _selectedDate = details.date!;
                              _dayController.displayDate = _selectedDate;
                              _dayController.selectedDate = _selectedDate;
                            });
                          }
                        },
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                        cellBorderColor: Colors.transparent,
                        dataSource: EventsDataSource(_getEventsForDay(_selectedDate)),
                      ),
                    ),
                    // Day View (50% of screen)
                    Expanded(
                      child: SfCalendar(
                        controller: _dayController,
                        view: CalendarView.day,
                        initialDisplayDate: _selectedDate,
                        initialSelectedDate: _selectedDate,
                        showCurrentTimeIndicator: true,
                        headerHeight: 0.0,
                        todayHighlightColor: Theme.of(context).colorScheme.primary,
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeights.medium,
                        ),
                        selectionDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        appointmentBuilder: (context, details) {
                          final event = details.appointments.first as Event;
                          return Container(
                            decoration: BoxDecoration(
                              color: event.background.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: event.background.withValues(alpha: 0.1),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  event.eventName,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeights.medium,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_formatTime(event.from)} - ${_formatTime(event.to)}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        dataSource: EventsDataSource(_getEventsForDay(_selectedDate)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final period = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
  }
}
