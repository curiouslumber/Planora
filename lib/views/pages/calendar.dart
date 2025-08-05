import 'package:flutter/material.dart';
import 'package:planora/data/events_data_source.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/pages/create/create_event.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key, required this.pageController, this.user});

  final PageController pageController;
  final UserModel? user;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final CalendarController _monthController = CalendarController();
  final CalendarController _dayController = CalendarController();
  DateTime _selectedDate = DateTime.now();
  List<EventModel> _events = [];
  bool _isLoading = true;
  double _dragStartX = 0.0;
  static const double _minSwipeDistance = 25.0;

  void onSwipeLeft() {
    widget.pageController.nextPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void onSwipeRight() {
    widget.pageController.previousPage(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

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
          final eventDate = DateTime.parse(event.startTime);
          return eventDate.year == day.year &&
              eventDate.month == day.month &&
              eventDate.day == day.day;
        })
        .map((event) => Event(
              event.name,
              event.id,
              DateTime.parse(event.startTime),
              event.endDate != null
                  ? DateTime.parse(event.endDate!)
                  : DateTime.parse(event.startTime).add(const Duration(hours: 1)),
              Theme.of(context).colorScheme.secondary,
              false,
            ))
        .toList();
  }

  DateTime _getSafeDisplayDate(DateTime date) {
    final now = DateTime.now();
    final startOfDay = DateTime(date.year, date.month, date.day);
    final targetTime = now.subtract(const Duration(hours: 1, minutes: 30));
    
    // If subtracting 1h30m would go to previous day, use start of day instead
    if (targetTime.isBefore(startOfDay)) {
      return startOfDay;
    }
    return targetTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 0.0,
                      bottom: 0.0,
                    ),
                    child: Column(
                      spacing: 8.0,
                      children: [
                        // Month View (50% of screen)
                        Expanded(
                          child: SfCalendar(
                            controller: _monthController,
                            view: CalendarView.month,
                            allowViewNavigation: false,
                            viewNavigationMode: ViewNavigationMode.none,
                            initialDisplayDate: _selectedDate,
                            initialSelectedDate: _selectedDate,
                            showNavigationArrow: true,
                            showDatePickerButton: true,
                            firstDayOfWeek: 1,
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
                            dataSource: _isLoading ? null : EventsDataSource(_getEventsForDay(_selectedDate)),
                          ),
                        ),
                        // Day View (50% of screen)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin),
                            child: SfCalendar(
                              onTap: (calendarTapDetails) {
                                if(calendarTapDetails.targetElement == CalendarElement.calendarCell) {
                                final now = DateTime.now();
                                final selectedTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, now.hour, 0);
                                final startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, selectedTime.hour, 0);
                                final endTime = startTime.add(const Duration(hours: 1));

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateEvent(
                                      user: widget.user,
                                      startDate: _selectedDate,
                                      startTime: startTime,
                                      endTime: endTime,
                                      endDate: _selectedDate,
                                    ),
                                  ),
                                );
                                }
                                if (calendarTapDetails.targetElement == CalendarElement.appointment) {
                                  final eventId = calendarTapDetails.appointments?.first as Event;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventPage(event: _events.firstWhere((event) => event.id == eventId.id)),
                                    ),
                                  );
                                }
                              },
                              controller: _dayController,
                              view: CalendarView.day,
                              allowViewNavigation: false,
                              viewNavigationMode: ViewNavigationMode.none,
                              initialDisplayDate: _getSafeDisplayDate(_selectedDate),
                              initialSelectedDate: _selectedDate,
                              showCurrentTimeIndicator: true,
                              headerHeight: 0.0,
                              todayHighlightColor: Theme.of(context).colorScheme.primary,
                              todayTextStyle: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeights.medium,
                              ),
                              timeSlotViewSettings: TimeSlotViewSettings(
                                timeIntervalHeight: 60,
                              ),
                              selectionDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: Colors.transparent
                                ),
                              ),
                              appointmentBuilder: (context, details) {
                                final event = details.appointments.first as Event;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: event.background,
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
                                          color: Theme.of(context).colorScheme.surface,
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
                                              .surface
                                              .withValues(alpha: 0.7),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              dataSource: _isLoading ? null : EventsDataSource(_getEventsForDay(_selectedDate)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (details) {
                      _dragStartX = details.globalPosition.dx;
                    },
                    onHorizontalDragUpdate: (details) {
                      final dragDistance = details.globalPosition.dx - _dragStartX;
                      if (dragDistance.abs() > _minSwipeDistance) {
                        if (dragDistance > 0) {
                          onSwipeRight();
                        } else {
                          onSwipeLeft();
                        }
                        _dragStartX = details.globalPosition.dx;
                      }
                    },
                  ),
                ],
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
