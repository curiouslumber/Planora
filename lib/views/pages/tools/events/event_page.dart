import 'dart:io';
import 'dart:math';

import 'package:action_slider/action_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/widgets/common_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.event});

  final EventModel event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late ConfettiController confettiController;

  @override
  void initState() {
    super.initState();
    confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  void markEventAsCompleted() {
    EventModel updatedEvent = widget.event.copyWith(
      eventStatus: Constants.eventStatus[2],
      userId: widget.event.userId,
      eventTileImage: widget.event.eventTileImage,
      eventTileImageLocalUrl: widget.event.eventTileImageLocalUrl,
      isImageProcessing: widget.event.isImageProcessing,
      createdAt: widget.event.createdAt,
      updatedAt: DateTime.now(),
      attribution: widget.event.attribution,
    );
    HiveEvents.updateEventInHive(updatedEvent);
  }

  void deleteEvent() {
    HiveEvents.deleteEventFromHive(widget.event);
    Navigator.pop(context);
    setState(() {});
    CommonSnackbar.showSnackbar(context, 'Event deleted successfully', Theme.of(context).colorScheme.primary);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          _circularAppBarButton(
            icon: Icons.share,
            onTap: () {},
          ),
          _circularAppBarButton(
            icon: Icons.favorite_border,
            onTap: () {},
          ),
          _circularAppBarButton(
            icon: Icons.delete_outline,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Event'),
                    content: const Text(
                      'Are you sure you want to delete this event?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteEvent();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            iconColor: Colors.red,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          FutureBuilder<File?>(
            future: CustomImageCacheManager().getCachedImageByEventId(
              widget.event.id,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.file(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.38,
                      ),
                      if (widget.event.attribution != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                            bottom: 32.0,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Photo by ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeights.regular,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 12,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onSurface,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                        widget
                                            .event
                                            .attribution!['profileUrl']!,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    widget.event.attribution!['name']!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Text(
                                  ' on ',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeights.regular,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onSurface,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    launchUrl(
                                      Uri.parse(
                                        widget
                                            .event
                                            .attribution!['unsplashUrl']!,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Unsplash',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return Container(
                  width: double.infinity,
                  color: Colors.transparent,
                );
              }
            },
          ),
          Transform.translate(
            offset: const Offset(0, -28),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.62,
              padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.0,
                children: [
                  Text(
                    widget.event.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeights.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.0,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      Text(
                        "${DateFormat('MMMM dd').format(DateTime.parse(widget.event.startDate))} - ${DateFormat.jm().format(DateTime.parse(widget.event.startTime))}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeights.regular,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Meeting Notes",
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeights.bold),
                      ),
                      Icon(
                        Icons.edit,
                        size: 20.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ],
                  ),
                  widget.event.description.isNotEmpty
                      ? Text(
                        widget.event.description,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeights.regular,
                        ),
                      )
                      : Text(
                        "No notes added yet",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeights.regular,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                ],
              ),
            ),
          ),

          // Confetti widget
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              pauseEmissionOnLowFrameRate: true,
              shouldLoop: false,
              numberOfParticles: Random().nextInt(50) + 20,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          widget.event.eventStatus != Constants.eventStatus[2]
              ? ActionSlider.standard(
                sliderBehavior: SliderBehavior.stretch,
                width: 300.0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                reverseSlideAnimationCurve: Curves.easeInOut,
                reverseSlideAnimationDuration: const Duration(
                  milliseconds: 500,
                ),
                toggleColor: Theme.of(context).colorScheme.onPrimary,
                icon: Icon(
                  Icons.send,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                loadingIcon: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                successIcon: Icon(
                  Icons.check,
                  size: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                action: (controller) async {
                  controller.loading(); //starts loading animation
                  await Future.delayed(const Duration(seconds: 3));

                  // Success Event
                  controller.success(); //starts success animation
                  confettiController.play();

                  // Update event status
                  markEventAsCompleted();
                },
                child: Text(
                  'Mark Complete',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ElevatedButton.icon(
                  onPressed: null, // disabled
                  icon: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text(
                    'Event Completed',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    disabledBackgroundColor:
                        Theme.of(context).colorScheme.surface,
                    minimumSize: Size(300, 48),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
    );
  }

  Widget _circularAppBarButton({
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        color: iconColor ?? Theme.of(context).colorScheme.onSurface,
        onPressed: onTap,
        splashRadius: 20,
      ),
    );
  }
}
