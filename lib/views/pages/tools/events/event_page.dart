import 'dart:io';

import 'package:action_slider/action_slider.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/cache_manager.dart';
import 'package:planora/utils/font_weights.dart';
import 'dart:math';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                surfaceTintColor: Theme.of(context).colorScheme.scrim,
                leadingWidth: 64.0,
                leading: MaterialButton(
                  elevation: 0.0,
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withValues(alpha: 0.8),
                  child: const Icon(Icons.arrow_back, size: 24.0),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  MaterialButton(
                    minWidth: 64.0,
                    height: 56.0,
                    elevation: 0.0,
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.8),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 24.0,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
                expandedHeight: 280.0,
                pinned: true,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: FutureBuilder<File?>(
                    future: CustomImageCacheManager().getCachedImageByEventId(
                      widget.event.id,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return ClipRRect(
                          // borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(snapshot.data!, fit: BoxFit.cover),
                        );
                      } else {
                        return Container(color: Colors.transparent);
                      }
                    },
                  ),
                  title: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth / 2,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Theme.of(
                            context,
                          ).colorScheme.surface.withValues(alpha: 0.9),
                        ),
                        child: Text(
                          widget.event.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize:
                                Theme.of(
                                  context,
                                ).textTheme.titleMedium!.fontSize,
                            fontWeight:
                                Theme.of(
                                  context,
                                ).textTheme.titleMedium!.fontWeight,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.event.attribution != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Photo by ',
                                    style: Theme.of(context).textTheme.bodyMedium!
                                        .copyWith(fontWeight: FontWeights.regular),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                      launchUrl(
                                        Uri.parse(
                                          widget.event.attribution!['profileUrl']!,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      widget.event.attribution!['name']!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    ' on ',
                                    style: Theme.of(context).textTheme.bodyMedium!
                                        .copyWith(fontWeight: FontWeights.regular),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    onPressed: () {
                                      launchUrl(
                                        Uri.parse(
                                          widget.event.attribution!['unsplashUrl']!,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Unsplash',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          if (widget.event.description.isNotEmpty)
                            Text(
                              widget.event.description,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeights.regular),
                            ),
                          Text(
                            'Meeting Time: ${DateFormat('jm').format(DateTime.parse(widget.event.startDate))} ${widget.event.endDate != null ? ' - ${DateFormat('jm').format(DateTime.parse(widget.event.endDate!))}' : ''}',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeights.regular,
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
      floatingActionButton: ActionSlider.standard(
        sliderBehavior: SliderBehavior.stretch,
        width: 300.0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        reverseSlideAnimationCurve: Curves.easeInOut,
        reverseSlideAnimationDuration: const Duration(milliseconds: 500),
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
        },
        child: Text(
          'Swipe to Complete',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
