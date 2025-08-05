import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/event_bus.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';
import 'package:planora/views/pages/tools/todos/todo_page.dart';
import 'package:planora/widgets/step_progress_indicator.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.user,
    required this.pageController,
  });

  final UserModel? user;
  final PageController pageController;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  // STATE VARIABLES
  final TextEditingController _searchController = TextEditingController();
  late StreamSubscription<ImageUpdateEvent> _imageUpdateSubscription;

  // Event lists
  List<EventModel> _events = [];
  List<TodoModel> _todos = [];

  // LIFECYCLE METHODS
  @override
  void initState() {
    super.initState();
    loadData();
    _setupImageUpdateListener();
  }

  @override
  void dispose() {
    _imageUpdateSubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _setupImageUpdateListener() {
    _imageUpdateSubscription = EventBus().onImageUpdated.listen((event) {
      if (mounted) {
        _refreshEvent(event.eventId);
      }
    });
  }

  Future<void> _refreshEvent(String eventId) async {
    try {
      // Get the latest event from Hive
      final events = await HiveEvents.getEventsFromHive();
      final updatedEvent = events.firstWhere((e) => e.id == eventId);

      // Update the events list
      setState(() {
        final index = _events.indexWhere((e) => e.id == eventId);
        if (index != -1) {
          _events[index] = updatedEvent;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing event: $e');
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        loadData();
      }
    });
  }

  // DATA LOADING
  Future<void> loadData() async {
    await _fetchEventsAndTasks();
    if (mounted) setState(() {});
  }

  Future<void> _fetchEventsAndTasks() async {
    _events = await HiveEvents.getEventsFromHive();
    _todos = await HiveEvents.getTodosFromHive();
    _processTasks();
    _processEvents();
  }

  void _processTasks() {
    _todos.sort((a, b) {
      final aIsOngoing = a.todoStatus != Constants.todoStatus[1];
      final bIsOngoing = b.todoStatus != Constants.todoStatus[1];
      if (aIsOngoing != bIsOngoing) {
        return aIsOngoing ? -1 : 1;
      }
      final updatedAtComparison = b.updatedAt.compareTo(a.updatedAt);
      if (updatedAtComparison != 0) return updatedAtComparison;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  void _processEvents() {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(today.year, today.month, today.day + 1);

    _events =
        _events
            .where(
              (e) =>
                  DateTime.parse(
                    e.startDate,
                  ).add(const Duration(milliseconds: 1)).isAfter(todayStart) &&
                  DateTime.parse(
                    e.startDate,
                  ).add(const Duration(milliseconds: 1)).isBefore(todayEnd),
            )
            .toList();

    _events.sort((a, b) {
      final aIsOngoing = a.eventStatus != Constants.eventStatus[2];
      final bIsOngoing = b.eventStatus != Constants.eventStatus[2];
      if (aIsOngoing != bIsOngoing) {
        return aIsOngoing ? -1 : 1;
      }
      final updatedAtComparison = b.updatedAt.compareTo(a.updatedAt);
      if (updatedAtComparison != 0) return updatedAtComparison;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  // EVENT HANDLERS
  void markEventComplete(EventModel event, int selectedIndex) {
    EventModel updatedEvent = event.copyWith(
      userId: event.userId,
      attribution: event.attribution,
      eventStatus: Constants.eventStatus[2],
      eventTileImage: event.eventTileImage,
      eventTileImageLocalUrl: event.eventTileImageLocalUrl,
      isImageProcessing: false,
      createdAt: event.createdAt,
      updatedAt: DateTime.now(),
    );
    HiveEvents.updateEventInHive(updatedEvent);
    FirebaseFirestoreService().updateEventDocument(event.id, updatedEvent);
    loadData();
    if (mounted) {
      setState(() {});
    }
  }

  void markTodoComplete(TodoModel todo, int selectedIndex) {
    TodoModel updatedTodo = todo.copyWith(
      todo: todo.todo,
      doesRepeat: todo.doesRepeat,
      repeatOption: todo.repeatOption,
      selectedDays: todo.selectedDays,
      todoStatus: Constants.todoStatus[1],
      createdAt: todo.createdAt,
      updatedAt: DateTime.now(),
      priority: todo.priority,
    );
    HiveEvents.updateTodoInHive(updatedTodo);
    FirebaseFirestoreService().updateTodoDocument(todo.id, updatedTodo);
    loadData();
    if (mounted) {
      setState(() {});
    }
  }

  String getCompletedEventsPercentage() {
    if (_events.isEmpty) return '-';
    final percent =
        (_events
                    .where((e) => e.eventStatus == Constants.eventStatus[2])
                    .length /
                _events.length *
                100)
            .round();
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
        child: Column(
          children: [
            // App Bar
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  GestureDetector(
                    onTap: () {
                      widget.pageController.jumpToPage(3);
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage:
                          (widget.user?.profilePicUrl != null &&
                                  widget.user!.profilePicUrl!.isNotEmpty)
                              ? NetworkImage(widget.user!.profilePicUrl!)
                              : null,
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      child:
                          (widget.user?.profilePicUrl == null ||
                                  widget.user!.profilePicUrl!.isEmpty)
                              ? Icon(
                                  Ionicons.person,
                                  size: 16,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                )
                              : null,
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  enabled: false,
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
            
            // Main Content
            Expanded(
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
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
                      spacing: 8.0,
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
                                    "${_events.where((e) => e.eventStatus == Constants.eventStatus[2]).length} of ${_events.length} completed",
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
                              snappedProgress: getSnappedDayProgress(_events),
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
                  if (_events.isEmpty)
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
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
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
                            // left: 8.0,
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
                          leading: FutureBuilder<File?>(
                            future: CustomImageCacheManager()
                                .getCachedImageByEventId(event.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData &&
                                  snapshot.data != null) {
                                return AspectRatio(
                                  aspectRatio: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      snapshot.data!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
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
                              if (event.eventStatus == "completed") {
                                return;
                              }

                              if (value != null) {
                                EventModel updatedEvent = event.copyWith(
                                  userId: event.userId,
                                  attribution: event.attribution,
                                  eventStatus: Constants.eventStatus[2],
                                  eventTileImage: event.eventTileImage,
                                  eventTileImageLocalUrl:
                                      event.eventTileImageLocalUrl,
                                  isImageProcessing: false,
                                  createdAt: event.createdAt,
                                  updatedAt: DateTime.now(),
                                );
                                HiveEvents.updateEventInHive(updatedEvent);
                                loadData();
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
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Todos',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeights.semiBold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          '${_todos.where((t) => t.todoStatus == Constants.todoStatus[1]).length} of ${_todos.length} ${_todos.length == 1 ? "task" : "tasks"} completed',
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
                  if (_todos.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Text(
                        "No todos.",
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
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        TodoPage(todo: _todos[index]),
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
                          title: Text(
                            _todos[index].todo,
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
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child:
                                _todos[index].priority.isNotEmpty
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  _todos[index].priority == 'High'
                                                      ? Colors.redAccent
                                                          .withValues(alpha: 0.2)
                                                      : _todos[index].priority ==
                                                          'Medium'
                                                      ? Colors.orangeAccent
                                                          .withValues(alpha: 0.2)
                                                      : _todos[index].priority ==
                                                          'Low'
                                                      ? Colors.green.withValues(
                                                          alpha: 0.2,
                                                        )
                                                      : Colors.grey.withValues(
                                                          alpha: 0.2,
                                                        ),
                                              borderRadius: BorderRadius.circular(
                                                12,
                                              ),
                                            ),
                                            child: Text(
                                              _todos[index].priority,
                                              style: TextStyle(
                                                color:
                                                    _todos[index].priority == 'High'
                                                        ? Colors.redAccent
                                                        : _todos[index].priority ==
                                                            'Medium'
                                                        ? Colors.orangeAccent
                                                        : _todos[index].priority ==
                                                            'Low'
                                                        ? Colors.green
                                                        : Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : null,
                          ),
                          trailing: Checkbox(
                            value:
                                _todos[index].todoStatus ==
                                Constants.todoStatus[1],
                            onChanged: (value) {
                              if (_todos[index].todoStatus ==
                                  Constants.todoStatus[1]) {
                                return;
                              }
                              if (value != null) {
                                markTodoComplete(_todos[index], index);
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
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
