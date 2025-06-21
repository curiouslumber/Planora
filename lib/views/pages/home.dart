import 'dart:io';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:planora/utils/helper.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final UserModel? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventModel> events = [];
  Map<String, String> imageIdToUrl = {};
  TextEditingController searchController = TextEditingController();
  Map<int, Map<String, int>> gridTileConstants = {
    0: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
    1: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    2: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    3: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
  };

  DateTime now = DateTime.now();
  List<EventModel> todayUpcomingEvents = [];

  void getEvents() async {
    events = await HiveEvents.getEventsFromHive();
    todayUpcomingEvents =
        events.where((event) {
          final start = DateTime.parse(event.startTime);
          return start.year == now.year &&
              start.month == now.month &&
              start.day == now.day;
        }).toList();
    for (var event in events) {
      if (event.eventTileImage.isNotEmpty) {
        // Try to get the cached file
        final cachedFile = await CustomImageCacheManager()
            .getCachedImageByEventId(event.id);

        if (cachedFile != null) {
          // Store the local file path for the event
          imageIdToUrl[event.id] = cachedFile.path;
        } else {
          // Fallback: get the download URL if not cached
          String downloadUrl = await Helper.getDownloadUrl(
            event.eventTileImage,
          );

          // Cache the image
          File? cachedFile = await CustomImageCacheManager()
              .cacheImageByEventId(downloadUrl, event.id);
          if (cachedFile != null) {
            imageIdToUrl[event.id] = cachedFile.path;
          }
        }
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  String getCompletedEventsPercentage(List<EventModel> events) {
    if (events.isEmpty) return '-';
    final completedCount =
        events.where((e) => e.eventStatus == Constants.eventStatus[2]).length;
    final percent = (completedCount / events.length * 100).round();
    return '$percent%';
  }

  String getMilestoneMessage(String percent) {
    if (percent == "-") return "Start planning events to get started!";
    final int percentInt = int.parse(percent.replaceAll('%', ''));
    if (percentInt <= 0) return Constants.milestoneMessages[0]!;
    if (percentInt <= 1) return Constants.milestoneMessages[1]!;
    if (percentInt <= 26) return Constants.milestoneMessages[26]!;
    if (percentInt <= 50) return Constants.milestoneMessages[50]!;
    if (percentInt <= 75) return Constants.milestoneMessages[75]!;
    return Constants.milestoneMessages[100]!;
  }

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                        "15%",
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
                                      "4 of 12 completed",
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
                              // 24-hour timeline with event checkpoints
                              StepProgressIndicator(
                                height: 8.0,
                                currentStep: DateTime.now().hour,
                                progressColor:
                                    Theme.of(context).colorScheme.tertiary,
                                trackColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                checkpointColor:
                                    Theme.of(context).colorScheme.primary,
                                checkpointDiameter: 6.0,
                                checkpointHours:
                                    events
                                        .where((e) {
                                          final eventDate = DateTime.parse(
                                            e.startTime,
                                          );
                                          final now = DateTime.now();
                                          return eventDate.year == now.year &&
                                              eventDate.month == now.month;
                                        })
                                        .map(
                                          (e) =>
                                              DateTime.parse(e.startTime).hour,
                                        )
                                        .toSet(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  getMilestoneMessage(
                                    getCompletedEventsPercentage(events),
                                  ),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeights.semiBold,
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
                            '${DateFormat("jm").format(DateTime.parse(event.startTime))} - ${DateFormat("jm").format(DateTime.parse(event.endTime))}',
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
                                  final imagePathOrUrl =
                                      imageIdToUrl[event.id];
                                  if (imagePathOrUrl != null) {
                                    if (File(imagePathOrUrl).existsSync()) {
                                      // It's a file path
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.file(
                                          File(imagePathOrUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      // It's a network URL
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.network(
                                          imagePathOrUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  } else {
                                    // No image found
                                    return Container(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          trailing: Checkbox(
                            value: event.eventStatus == "completed",
                            checkColor: Theme.of(context).colorScheme.onPrimary,
                            fillColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            onChanged: (value) {},
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
                      children: [
                        Text(
                          'Past Events',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeights.semiBold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                      itemCount: events.length,
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
                            events[index].name,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeights.semiBold,
                            ),
                          ),
                          subtitle: Text(
                            '${DateFormat("jm").format(DateTime.parse(events[index].startTime))} - ${DateFormat("jm").format(DateTime.parse(events[index].endTime))}',
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
                                  .getCachedImageByEventId(events[index].id),
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
                                  final imagePathOrUrl =
                                      imageIdToUrl[events[index].id];
                                  if (imagePathOrUrl != null) {
                                    if (File(imagePathOrUrl).existsSync()) {
                                      // It's a file path
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.file(
                                          File(imagePathOrUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      // It's a network URL
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.network(
                                          imagePathOrUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  } else {
                                    // No image found
                                    return Container(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          trailing: Checkbox(
                            value: true,
                            onChanged: (value) {},
                            checkColor: Theme.of(context).colorScheme.onPrimary,
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
                          )
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
  final int currentStep;
  final Color progressColor;
  final Color trackColor;
  final Color checkpointColor;
  final double checkpointDiameter;
  final double height;
  final Set<int> checkpointHours;

  static const int _totalHours = 24;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.progressColor = Colors.blue,
    this.trackColor = Colors.grey,
    this.checkpointColor = Colors.white,
    this.checkpointDiameter = 8.0,
    this.height = 10.0,
    this.checkpointHours = const {},
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
                width: barWidth * (currentStep / _totalHours),
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Spots only at event hours
              ...checkpointHours.map((hour) {
                double positionX;
                if (hour == 0) {
                  // Place the first dot just inside the left border
                  positionX = checkpointDiameter / 2;
                } else if (hour == _totalHours) {
                  // Place the last dot just inside the right border
                  positionX = barWidth - checkpointDiameter / 2;
                } else {
                  positionX = hour * (barWidth / (_totalHours - 1));
                }
                final bool isPast = hour < currentStep;
                return Positioned(
                  left: positionX - checkpointDiameter / 2,
                  top: (height / 2) - checkpointDiameter / 2,
                  child: Container(
                    width: checkpointDiameter,
                    height: checkpointDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPast ? progressColor : checkpointColor,
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
