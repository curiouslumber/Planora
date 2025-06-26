import 'dart:io';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/common/event_task_image_service.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';
import 'package:planora/views/pages/tools/tasks/task_page.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final UserModel? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventModel> events = [];
  TextEditingController searchController = TextEditingController();
  Map<int, Map<String, int>> gridTileConstants = {
    0: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
    1: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    2: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    3: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
  };

  DateTime now = DateTime.now();
  List<EventModel> todayUpcomingEvents = [];
  List<EventModel> todayPastEvents = [];
  List<EventModel> todayCompletedEvents = [];
  List<EventModel> todayEvents = [];
  List<TaskModel> tasks = [];

  void getEvents() async {
    events = await HiveEvents.getEventsFromHive();
    tasks = await HiveEvents.getTasksFromHive();

    todayEvents =
        events.where((event) {
          return isRangeInToday(event, now);
        }).toList();

    todayUpcomingEvents =
        events.where((event) {
            return isRangeInFuture(event, now) &&
                event.eventStatus != Constants.eventStatus[2];
          }).toList()
          ..sort(
            (a, b) =>
                DateTime.parse(a.endTime).compareTo(DateTime.parse(b.endTime)),
          );

    todayPastEvents =
        events.where((event) {
            return isRangeInPast(event, now) ||
                (event.eventStatus == Constants.eventStatus[2] &&
                    isRangeInToday(event, now));
          }).toList()
          ..sort(
            (a, b) =>
                DateTime.parse(b.endTime).compareTo(DateTime.parse(a.endTime)),
          );

    todayCompletedEvents =
        events.where((event) {
          return event.eventStatus == Constants.eventStatus[2] &&
              isRangeInToday(event, now);
        }).toList();

    for (var event in events) {
      if (event.isImageProcessing) continue;
      EventTaskImageService.handleImageTileForEvent(event);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void markEventComplete(EventModel event, int selectedIndex) {
    EventModel updatedEvent = event.copyWith(
      eventStatus: Constants.eventStatus[2],
      eventTileImage: event.eventTileImage,
      eventTileImageLocalUrl: event.eventTileImageLocalUrl,
      isImageProcessing: false,
    );
    HiveEvents.updateEventInHive(updatedEvent);
    getEvents();
    if (mounted) {
      setState(() {});
    }
  }

  void markTaskComplete(TaskModel task, int index) {
    TaskModel updatedTask = task.copyWith(
      name: task.name,
      notes: task.notes,
      taskStatus: Constants.taskStatus[1],
    );
    HiveEvents.updateTaskInHive(updatedTask);
    getEvents();
    if (mounted) {
      setState(() {});
    }
  }

  String getCompletedEventsPercentage() {
    if (todayEvents.isEmpty) return '-';
    final percent =
        (todayCompletedEvents.length / todayEvents.length * 100).round();
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

  bool isRangeInPast(EventModel event, DateTime now) {
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

  bool isRangeInFuture(EventModel event, DateTime now) {
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

  bool isRangeInToday(EventModel event, DateTime now) {
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

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate snapped progress for the day (0-24 scale)
    final now = DateTime.now();
    final int currentMinute = now.hour * 60 + now.minute;

    // Calculate checkpoint times for current day events
    final Set<TimeOfDay> checkpointTimes =
        events
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
              delegate: _SearchBarDelegate(
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
                    controller: searchController,
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
                                "Task Progress",
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
                                      "${todayCompletedEvents.length} of ${todayEvents.length} completed",
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
                                  todayEvents,
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
                    if (todayUpcomingEvents.isEmpty)
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
                        itemCount: todayUpcomingEvents.length,
                        itemBuilder: (context, index) {
                          final event = todayUpcomingEvents[index];
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
                                  );
                                  HiveEvents.updateEventInHive(updatedEvent);
                                  getEvents();
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
                    if (todayPastEvents.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 16);
                        },
                        itemCount: todayPastEvents.length,
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
                              todayPastEvents[index].name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 16,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                            subtitle: Text(
                              '${DateFormat("jm").format(DateTime.parse(todayPastEvents[index].startTime))} ${todayPastEvents[index].endTime != todayPastEvents[index].startTime ? '- ${DateFormat("jm").format(DateTime.parse(todayPastEvents[index].endTime))}' : ''}',
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
                                      todayPastEvents[index].id,
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
                                  todayPastEvents[index].eventStatus ==
                                  Constants.eventStatus[2],
                              onChanged: (value) {
                                if (value != null) {
                                  markEventComplete(
                                    todayPastEvents[index],
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
                      children: [
                        Text(
                          'Todo',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeights.semiBold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            '${tasks.length} ${tasks.length == 1 ? "task" : "tasks"}',
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
                    if (tasks.isEmpty)
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
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => TaskPage(task: tasks[index]),
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
                              tasks[index].name,
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
                            subtitle: Text(
                              "dummy description here and extra text for checking overflow",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeights.regular,
                              ),
                            ),
                            trailing: Checkbox(
                              value:
                                  tasks[index].taskStatus ==
                                  Constants.taskStatus[1],
                              onChanged: (value) {
                                if (value != null) {
                                  markTaskComplete(tasks[index], index);
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

// SliverPersistentHeaderDelegate for sticky search bar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Widget child;
  _SearchBarDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent;
  }
}

class StepProgressIndicator extends StatelessWidget {
  final int currentMinute; // minute of the day: 0-1439
  final Color progressColor;
  final Color trackColor;
  final Color checkpointColor;
  final double checkpointDiameter;
  final double height;
  final Set<TimeOfDay> checkpointTimes;
  final double? snappedProgress;

  static const int _totalMinutes = 24 * 60;

  const StepProgressIndicator({
    super.key,
    required this.currentMinute,
    this.progressColor = Colors.blue,
    this.trackColor = Colors.grey,
    this.checkpointColor = Colors.white,
    this.checkpointDiameter = 8.0,
    this.height = 10.0,
    this.checkpointTimes = const {},
    this.snappedProgress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth;

        return Container(
          height: height + checkpointDiameter / 2,
          alignment: Alignment.centerLeft,
          child: Stack(
            children: [
              // Background track
              Container(
                height: height,
                width: barWidth,
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Filled progress
              Container(
                height: height,
                width:
                    barWidth *
                    (snappedProgress ?? (currentMinute / _totalMinutes)),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Spots at event times (hours and minutes)
              ...checkpointTimes.map((time) {
                int minuteOfDay = time.hour * 60 + time.minute;
                double positionX;
                if (minuteOfDay == 0) {
                  // Place the first dot just inside the left border
                  positionX = checkpointDiameter / 2;
                } else if (minuteOfDay == _totalMinutes) {
                  // Place the last dot just inside the right border
                  positionX = barWidth - checkpointDiameter / 2;
                } else {
                  positionX = minuteOfDay * (barWidth / _totalMinutes);
                }
                return Positioned(
                  left: positionX - checkpointDiameter / 2,
                  top: (height / 2) - checkpointDiameter / 2,
                  child: Container(
                    width: checkpointDiameter,
                    height: checkpointDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: checkpointColor,
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

double getSnappedDayProgress(List<EventModel> todayEvents) {
  final now = DateTime.now();
  double timeProgress = (now.hour + now.minute / 60) / 24;

  if (todayEvents.isEmpty) return timeProgress;

  // If all events are completed, fill the bar
  if (todayEvents.every((e) => e.eventStatus == Constants.eventStatus[2])) {
    return 1.0;
  }

  // Sort events by end time
  List<EventModel> sortedEvents = List.from(todayEvents)..sort(
    (a, b) => DateTime.parse(a.endTime).compareTo(DateTime.parse(b.endTime)),
  );

  DateTime? latestSnappableEnd;

  // Track if all previous events are completed
  bool allPrevCompleted = true;
  for (final event in sortedEvents) {
    final isCompleted = event.eventStatus == Constants.eventStatus[2];
    final eventEnd = DateTime.parse(event.endTime);

    if (isCompleted && allPrevCompleted && eventEnd.isAfter(now)) {
      latestSnappableEnd = eventEnd;
    }
    if (!isCompleted) {
      allPrevCompleted = false;
    }
  }

  if (latestSnappableEnd != null) {
    double snappedProgress =
        (latestSnappableEnd.hour + latestSnappableEnd.minute / 60) / 24;
    return snappedProgress > timeProgress ? snappedProgress : timeProgress;
  }

  return timeProgress;
}
