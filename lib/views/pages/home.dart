import 'dart:io';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/common/event_task_image_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';
import 'package:planora/views/pages/tools/tasks/task_page.dart';
import 'package:planora/widgets/search_bar_delegate.dart';
import 'package:planora/widgets/step_progress_indicator.dart';

class Home extends StatefulWidget {
  const Home({super.key, this.user});

  final UserModel? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // STATE VARIABLES
  final TextEditingController _searchController = TextEditingController();
  final DateTime _now = DateTime.now();
  
  // Event lists
  List<EventModel> _events = [];
  List<EventModel> _todayUpcomingEvents = [];
  List<EventModel> _todayPastEvents = [];
  List<EventModel> _todayCompletedEvents = [];
  List<EventModel> _todayEvents = [];
  List<TaskModel> _tasks = [];

  // LIFECYCLE METHODS
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        _loadData();
      }
    });
  }

  // DATA LOADING
  Future<void> _loadData() async {
    await _fetchEventsAndTasks();
    if (mounted) setState(() {});
  }

  Future<void> _fetchEventsAndTasks() async {
    _events = await HiveEvents.getEventsFromHive();
    _tasks = await HiveEvents.getTasksFromHive();
    _processTasks();
    _processEvents();
  }

  void _processTasks() {
    _tasks.sort((a, b) {
      final aIsOngoing = a.taskStatus != Constants.taskStatus[1];
      final bIsOngoing = b.taskStatus != Constants.taskStatus[1];
      if (aIsOngoing != bIsOngoing) {
        return aIsOngoing ? -1 : 1;
      }
      final updatedAtComparison = b.updatedAt.compareTo(a.updatedAt);
      if (updatedAtComparison != 0) return updatedAtComparison;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  void _processEvents() {
    _todayEvents = _events.where((e) => _isRangeInToday(e, _now)).toList();

    _todayUpcomingEvents =
        _events
            .where(
              (e) =>
                  _isRangeInFuture(e, _now) &&
                  e.eventStatus != Constants.eventStatus[2],
            )
            .toList()
          ..sort((a, b) => a.endTime.compareTo(b.endTime));

    _todayPastEvents =
        _events
            .where(
              (e) =>
                  _isRangeInPast(e, _now) ||
                  (e.eventStatus == Constants.eventStatus[2] &&
                      _isRangeInToday(e, _now)),
            )
            .toList()
          ..sort((a, b) => b.endTime.compareTo(a.endTime));

    _todayCompletedEvents =
        _events
            .where(
              (e) =>
                  e.eventStatus == Constants.eventStatus[2] &&
                  _isRangeInToday(e, _now),
            )
            .toList();

    _processEventImages();
  }

  void _processEventImages() {
    for (var event in _events) {
      if (event.isImageProcessing) continue;
      EventTaskImageService.handleImageTileForEvent(event);
    }
  }

  // EVENT HANDLERS
  void markEventComplete(EventModel event, int selectedIndex) {
    EventModel updatedEvent = event.copyWith(
      eventStatus: Constants.eventStatus[2],
      eventTileImage: event.eventTileImage,
      eventTileImageLocalUrl: event.eventTileImageLocalUrl,
      isImageProcessing: false,
      createdAt: event.createdAt,
      updatedAt: DateTime.now(),
    );
    HiveEvents.updateEventInHive(updatedEvent);
    FirebaseFirestoreService().updateEventDocument(event.id, updatedEvent);
    _loadData();
    if (mounted) {
      setState(() {});
    }
  }

  void markTaskComplete(TaskModel task, int index) {
    TaskModel updatedTask = task.copyWith(
      name: task.name,
      notes: task.notes,
      taskStatus: Constants.taskStatus[1],
      attachments: task.attachments,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
    );
    HiveEvents.updateTaskInHive(updatedTask);
    FirebaseFirestoreService().updateTaskDocument(task.id, updatedTask);
    _loadData();
    if (mounted) {
      setState(() {});
    }
  }

  // HELPER METHODS
  bool _isRangeInPast(EventModel event, DateTime now) {
    final eventLocalStartDate = DateTime.parse(event.startDate);
    DateTime eventLocalEndDate =
        event.endDate != null
            ? DateTime.parse(event.endDate!)
            : eventLocalStartDate;
    final eventLocalEndTime = DateTime.parse(event.endTime);

    final eventLocalEndDateTime = DateTime(
      eventLocalEndDate.year,
      eventLocalEndDate.month,
      eventLocalEndDate.day,
      eventLocalEndTime.hour,
      eventLocalEndTime.minute,
      eventLocalEndTime.second,
    );

    // Is the event's end before now, and does it occur today?
    final isToday =
        now.year == eventLocalEndDate.year &&
        now.month == eventLocalEndDate.month &&
        now.day == eventLocalEndDate.day;

    return eventLocalEndDateTime.isBefore(now) && isToday;
  }

  bool _isRangeInFuture(EventModel event, DateTime now) {
    final eventLocalStartDate = DateTime.parse(event.startDate);
    final eventLocalStartTime = DateTime.parse(event.startTime);

    DateTime eventLocalStartDateTime = DateTime(
      eventLocalStartDate.year,
      eventLocalStartDate.month,
      eventLocalStartDate.day,
      eventLocalStartTime.hour,
      eventLocalStartTime.minute,
      eventLocalStartTime.second,
    );

    // Is the event's start after now, and does it occur today?
    final isToday =
        now.year == eventLocalStartDate.year &&
        now.month == eventLocalStartDate.month &&
        now.day == eventLocalStartDate.day;

    return isToday && eventLocalStartDateTime.isAfter(now);
  }

  bool _isRangeInToday(EventModel event, DateTime now) {
    final eventLocalStartDate = DateTime.parse(event.startDate);
    DateTime eventLocalEndDate =
        event.endDate != null
            ? DateTime.parse(event.endDate!)
            : eventLocalStartDate;

    // Is the event's end before now, and does it occur today?
    final isToday =
        now.year == eventLocalEndDate.year &&
        now.month == eventLocalEndDate.month &&
        now.day == eventLocalEndDate.day;

    return isToday;
  }

  String getCompletedEventsPercentage() {
    if (_todayEvents.isEmpty) return '-';
    final percent =
        (_todayCompletedEvents.length / _todayEvents.length * 100).round();
    return '$percent%';
  }

  String getMilestoneMessage(String percent) {
    if (percent == "-") return "Start planning events to get started!";
    final int percentInt = int.parse(percent.replaceAll('%', ''));
    if (percentInt == 0) return Constants.milestoneMessages[0]!;
    if (percentInt >= 1 && percentInt < 26) {
      return Constants.milestoneMessages[1]!;
    }
    if (percentInt >= 26 && percentInt < 50) {
      return Constants.milestoneMessages[26]!;
    }
    if (percentInt >= 50 && percentInt < 75) {
      return Constants.milestoneMessages[50]!;
    }
    if (percentInt >= 75 && percentInt < 100) {
      return Constants.milestoneMessages[75]!;
    }
    return Constants.milestoneMessages[100]!;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate snapped progress for the day (0-24 scale)
    final now = DateTime.now();
    final int currentMinute = now.hour * 60 + now.minute;

    // Calculate checkpoint times for current day events
    final Set<TimeOfDay> checkpointTimes =
        _events
            .where((e) {
              final eventDate = DateTime.parse(e.startTime);
              return eventDate.year == now.year &&
                  eventDate.month == now.month &&
                  eventDate.day == now.day;
            })
            .map((e) {
              final eventDate = DateTime.parse(e.startTime);
              return TimeOfDay(hour: eventDate.hour, minute: eventDate.minute);
            })
            .toSet();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverAppBar for greeting/profile/notification
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: false,
              elevation: 0.0,
              toolbarHeight: kToolbarHeight + 8,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 8,
                    right: 24,
                    bottom: 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${DateTime.now().hour < 12
                                  ? Constants.greetingMorning
                                  : DateTime.now().hour < 18
                                  ? Constants.greetingAfternoon
                                  : Constants.greetingEvening},',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeights.regular,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              widget.user?.displayName ?? 'Guest',
                              style: TextStyle(
                                fontFamily:
                                    Theme.of(
                                      context,
                                    ).textTheme.headlineLarge!.fontFamily,
                                fontWeight: FontWeights.semiBold,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            Icon(
                              Ionicons.notifications_outline,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Icon(
                          Ionicons.person,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // SliverPersistentHeader for sticky search bar
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                minExtent: 80,
                maxExtent: 80,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0.0,
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: _searchController,
                    cursorColor: Theme.of(context).colorScheme.onSurface,
                    maxLines: 1,
                    minLines: 1,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeights.regular,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.only(left: 16.0, right: 8.0),
                        child: Icon(
                          Ionicons.search_outline,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      prefixIconColor: Theme.of(context).colorScheme.primary,
                      suffixIcon: Container(
                        margin: EdgeInsets.only(right: 4.0),
                        width: MediaQuery.of(context).size.width * 0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 24,
                              width: 1,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Ionicons.mic_outline,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      suffixIconColor: Theme.of(context).colorScheme.primary,
                      hintText: 'Search your tasks, events, notes...',
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontWeight: FontWeights.regular,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main content as a sliver
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Event Progress",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeights.semiBold,
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Ionicons.chevron_forward,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    spacing: 16.0,
                                    children: [
                                      Text(
                                        getCompletedEventsPercentage(),
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                          fontSize: 32,
                                          fontWeight: FontWeights.semiBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Text(
                                      "${_todayCompletedEvents.length} of ${_todayEvents.length} completed",
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeights.semiBold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              StepProgressIndicator(
                                height: 8.0,
                                currentMinute: currentMinute,
                                snappedProgress: getSnappedDayProgress(
                                  _todayEvents,
                                ),
                                progressColor:
                                    Theme.of(context).colorScheme.tertiary,
                                trackColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                checkpointColor:
                                    Theme.of(context).colorScheme.primary,
                                checkpointDiameter: 6.0,
                                checkpointTimes: checkpointTimes,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    getMilestoneMessage(
                                      getCompletedEventsPercentage(),
                                    ),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeights.semiBold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today\'s Schedule',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (_todayUpcomingEvents.isEmpty)
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Text(
                          "No events scheduled for today.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16);
                        },
                        itemCount: _todayUpcomingEvents.length,
                        itemBuilder: (context, index) {
                          final event = _todayUpcomingEvents[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventPage(event: event),
                                ),
                              );
                            },
                            tileColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                            contentPadding: EdgeInsets.only(
                              left: 8.0,
                              right: 16.0,
                            ),
                            minVerticalPadding: 0.0,
                            title: Text(
                              event.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat("jm").format(DateTime.parse(event.startTime))} ${event.endTime != event.startTime ? '- ${DateFormat("jm").format(DateTime.parse(event.endTime))}' : ''}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            minTileHeight: 72,
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: FutureBuilder<File?>(
                                future: CustomImageCacheManager()
                                    .getCachedImageByEventId(event.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return Container(color: Colors.transparent);
                                  }
                                },
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            trailing: Checkbox(
                              value: event.eventStatus == "completed",
                              checkColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              fillColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  EventModel updatedEvent = event.copyWith(
                                    eventStatus: Constants.eventStatus[2],
                                    eventTileImage: event.eventTileImage,
                                    eventTileImageLocalUrl:
                                        event.eventTileImageLocalUrl,
                                    isImageProcessing: false,
                                    createdAt: event.createdAt,
                                    updatedAt: DateTime.now(),
                                  );
                                  HiveEvents.updateEventInHive(updatedEvent);
                                  _loadData();
                                  if (mounted) {
                                    setState(() {});
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          );
                        },
                      ),
                    SizedBox(height: 16),
                    if (_todayPastEvents.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16);
                        },
                        itemCount: _todayPastEvents.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                            contentPadding: EdgeInsets.only(
                              left: 8.0,
                              right: 16.0,
                            ),
                            minVerticalPadding: 0.0,
                            title: Text(
                              _todayPastEvents[index].name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat("jm").format(DateTime.parse(_todayPastEvents[index].startTime))} ${_todayPastEvents[index].endTime != _todayPastEvents[index].startTime ? '- ${DateFormat("jm").format(DateTime.parse(_todayPastEvents[index].endTime))}' : ''}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            minTileHeight: 72,
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: FutureBuilder<File?>(
                                future: CustomImageCacheManager()
                                    .getCachedImageByEventId(
                                      _todayPastEvents[index].id,
                                    ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  } else {
                                    return Container(color: Colors.transparent);
                                  }
                                },
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            trailing: Checkbox(
                              value:
                                  _todayPastEvents[index].eventStatus ==
                                  Constants.eventStatus[2],
                              onChanged: (value) {
                                if (value != null) {
                                  markEventComplete(
                                    _todayPastEvents[index],
                                    index,
                                  );
                                }
                              },
                              checkColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              fillColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          );
                        },
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Tasks',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeights.semiBold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${_tasks.where((t) => t.taskStatus == Constants.taskStatus[1]).length} of ${_tasks.length} ${_tasks.length == 1 ? "task" : "tasks"} completed',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeights.regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (_tasks.isEmpty)
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.055,
                        child: Text(
                          "No tasks.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeights.regular,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16);
                        },
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          TaskPage(task: _tasks[index]),
                                ),
                              );
                            },
                            tileColor: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                            contentPadding: EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                            ),
                            minVerticalPadding: 0.0,
                            title: Text(
                              _tasks[index].name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            minTileHeight: 72,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            subtitle:
                                _tasks[index].notes.isNotEmpty
                                    ? Text(
                                      _tasks[index].notes,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary
                                            .withValues(alpha: 0.7),
                                        fontSize: 12,
                                        fontWeight: FontWeights.regular,
                                      ),
                                    )
                                    : null,
                            trailing: Checkbox(
                              value:
                                  _tasks[index].taskStatus ==
                                  Constants.taskStatus[1],
                              onChanged: (value) {
                                if (value != null) {
                                  markTaskComplete(_tasks[index], index);
                                }
                              },
                              checkColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              fillColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              side: BorderSide(
                                width: 1.5,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 24.0),
                    Container(
                      margin: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Made with ❤️\nby Noel Pinto',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
