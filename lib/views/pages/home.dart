import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
import 'package:planora/views/pages/tools/events/add_event.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.user});

  final UserModel? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventModel> events = [];
  Map<String, String> imageIdToUrl = {};
  Map<int, Map<String, int>> gridTileConstants = {
    0: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
    1: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    2: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    3: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
  };

  void getEvents() async {
    events = await HiveEvents.getEventsFromHive();
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
      appBar: AppBar(
        toolbarHeight: 100,
        actionsPadding: EdgeInsets.only(right: 32),
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: GestureDetector(
            onTap: () {},
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Ionicons.notifications_outline,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ],
            ),
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8),
              Text(
                DateTime.now().hour < 12
                    ? Constants.greetingMorning
                    : DateTime.now().hour < 18
                    ? Constants.greetingAfternoon
                    : Constants.greetingEvening,
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
                      Theme.of(context).textTheme.headlineLarge!.fontFamily,
                  fontWeight: FontWeights.semiBold,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 4),
              height: MediaQuery.of(context).size.height * 0.22,
              padding: EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8.0,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      getMilestoneMessage(getCompletedEventsPercentage(events)),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeights.medium,
                      ),
                      maxLines: 3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 6,
                            strokeAlign: 8,
                            value:
                                double.tryParse(
                                  getCompletedEventsPercentage(
                                    events,
                                  ).replaceAll('%', ''),
                                ) ??
                                0,
                            color: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.4),
                          ),
                          Text(
                            getCompletedEventsPercentage(events),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeights.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
                if (events.length == 2)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: InkWell(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEvent(),
                            ),
                          ),
                      child: DottedBorder(
                        options: CircularDottedBorderOptions(
                          color: Theme.of(context).colorScheme.onSurface,
                          padding: const EdgeInsets.all(6.0),
                          dashPattern: const [2, 2],
                        ),
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (events.isEmpty)
              InkWell(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddEvent()),
                    ),
                child: SizedBox(
                  width: double.infinity,
                  height: 100.0,
                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: Radius.circular(8.0),
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(180),
                      padding: EdgeInsets.all(16.0),
                      stackFit: StackFit.expand,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(180),
                        ),
                        Text(
                          "Create Event or Schedule a Meeting",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(180),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (events.isNotEmpty)
              StaggeredGrid.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(
                  events.length < 3 ? events.length + 1 : 4,
                  (index) {
                    if (events.length > 3 && index == 3) {
                      return StaggeredGridTile.count(
                        crossAxisCellCount:
                            gridTileConstants[3]!['crossAxisCellCount']!,
                        mainAxisCellCount:
                            gridTileConstants[3]!['mainAxisCellCount']!,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "View More",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.surface,
                                  fontFamily:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.fontFamily,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "+${events.length - 3} schedule",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).colorScheme.surface,
                                  fontFamily:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (events.length == 1 && index == 1) {
                      return StaggeredGridTile.count(
                        crossAxisCellCount:
                            gridTileConstants[1]!['crossAxisCellCount']!,
                        mainAxisCellCount:
                            gridTileConstants[1]!['mainAxisCellCount']!,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: Radius.circular(8.0),
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(180),
                              padding: EdgeInsets.all(16.0),
                              stackFit: StackFit.expand,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 4.0,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.9),
                                  ),
                                  Text(
                                    "Add Event",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (events.length == 2 && index == 2) {
                      return Container();
                    }

                    if (events.length == 3 && index == 3) {
                      return StaggeredGridTile.count(
                        crossAxisCellCount:
                            gridTileConstants[3]!['crossAxisCellCount']!,
                        mainAxisCellCount:
                            gridTileConstants[3]!['mainAxisCellCount']!,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: Radius.circular(8.0),
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(180),
                              padding: EdgeInsets.all(16.0),
                              stackFit: StackFit.expand,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 4.0,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.9),
                                  ),
                                  Text(
                                    "Add Event/Meeting",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.9),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    final event = events.asMap().entries.elementAt(index).value;

                    return StaggeredGridTile.count(
                      crossAxisCellCount:
                          gridTileConstants[index]!['crossAxisCellCount']!,
                      mainAxisCellCount:
                          gridTileConstants[index]!['mainAxisCellCount']!,
                    child: GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder:
                                    (context) => EventPage(
                                      event: event,
                                      imageUrl: imageIdToUrl[event.id]!,
                                    ),
                            ),
                          ),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                              if (event.eventTileImage.isNotEmpty)
                                FutureBuilder<File?>(
                                  future: CustomImageCacheManager()
                                      .getCachedImageByEventId(event.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        snapshot.hasData) {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                        child: Image.file(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      );
                                    } else {
                                      final imagePathOrUrl =
                                          imageIdToUrl[event.id];
                                      if (imagePathOrUrl != null &&
                                          File(imagePathOrUrl).existsSync()) {
                                        // It's a file path
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                          child: Image.file(
                                            File(imagePathOrUrl),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        );
                                      } else {
                                        // It's a network URL or null
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                          child: Image.network(
                                            imagePathOrUrl ?? '',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                                padding: EdgeInsets.only(bottom: 12),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceContainer
                                            .withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              event.name,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.85),
                                                fontSize: 14,
                                                fontWeight: FontWeights.bold,
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '${DateFormat('jm').format(DateTime.parse(event.startDate))} ${event.endDate != null ? ' - ${DateFormat('jm').format(DateTime.parse(event.endDate!))}' : ''}',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.85),
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeights.semiBold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeights.semiBold,
              ),
            ),
            const SizedBox(height: 16),
            // Container(
            //   width: double.infinity,
            //   height: 60.0,
            //   alignment: Alignment.center,
            //   child: Text(
            //     'Start by completing your first event!',
            //     style: TextStyle(
            //       color: Theme.of(
            //         context,
            //       ).colorScheme.onSurface.withValues(alpha: 0.8),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.125,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.125,
                  viewportFraction: 0.35,
                  padEnds: false,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: false,
                  onPageChanged: (index, reason) {},
                  scrollDirection: Axis.horizontal,
                ),
                items: List.generate(events.length + 1, (index) {
                  if (events.length == index) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.125,
                      width: MediaQuery.of(context).size.width * 0.35,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            size: 24,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height * 0.125,
                    width: MediaQuery.of(context).size.width * 0.35,
                    margin: EdgeInsets.only(right: index < 3 ? 16.0 : 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (events[index].eventTileImage.isNotEmpty)
                          FutureBuilder<File?>(
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
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                );
                              } else {
                                final imagePathOrUrl =
                                    imageIdToUrl[events[index].id];
                                if (imagePathOrUrl != null &&
                                    File(imagePathOrUrl).existsSync()) {
                                  // It's a file path
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.file(
                                      File(imagePathOrUrl),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  );
                                } else {
                                  // It's a network URL or null
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      imagePathOrUrl ?? '',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainer
                                .withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  events[index].name,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeights.bold,
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${DateFormat('jm').format(DateTime.parse(events[index].startDate))} ${events[index].endDate != null ? ' - ${DateFormat('jm').format(DateTime.parse(events[index].endDate!))}' : ''}',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeights.semiBold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 32.0),
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
    );
  }
}
