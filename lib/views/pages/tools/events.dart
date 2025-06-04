import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/dialogs.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:planora/views/pages/tools/events/add_event.dart';
import 'package:planora/views/pages/tools/events/event_page.dart';

enum EventMode { none, selecting }

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<EventModel> events = [];
  Set<int> checkedEvents = {};
  EventMode mode = EventMode.none;

  @override
  void initState() {
    getEvents();
    super.initState();
  }

  Future<void> getEvents() async {
    events = await HiveEvents.getEventsFromHive();
    setState(() {});
  }

  Future<void> deleteEvents() async {
    await HiveEvents.deleteEventsFromHive(checkedEvents);
    setState(() {
      checkedEvents.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        actionsPadding: EdgeInsets.only(right: 8.0),
        actions: [
          if (checkedEvents.isNotEmpty)
            IconButton(
              icon: const Icon(CupertinoIcons.delete),
              onPressed:
                  () => confirmationDialog(
                    context,
                    () => deleteEvents(),
                    "Delete Events",
                    "Are you sure you want to delete ${checkedEvents.length} ${checkedEvents.length > 1 ? "events" : "event"}?",
                    "Delete",
                  ),
            ),

          IconButton(
            onPressed: () {
              setState(() {
                if (mode == EventMode.selecting) {
                  checkedEvents.clear();
                }
                mode =
                    mode == EventMode.selecting
                        ? EventMode.none
                        : EventMode.selecting;
              });
            },
            icon:
                mode == EventMode.selecting
                    ? Icon(Icons.radio_button_checked)
                    : Icon(Icons.radio_button_unchecked),
          ),
        ],
      ),
      body: Center(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          itemCount: events.length,
          separatorBuilder:
              (context, index) => Divider(color: Colors.transparent),
          itemBuilder: (context, index) {
            final event = events[index];
            return GestureDetector(
              onLongPress: () {
                setState(() {
                  if (checkedEvents.contains(event.hashCode)) {
                    checkedEvents.remove(event.hashCode);
                  } else {
                    checkedEvents.add(event.hashCode);
                  }
                });
              },
              onTap: () {
                if (mode == EventMode.selecting) {
                  if (checkedEvents.contains(event.hashCode)) {
                    setState(() {
                      checkedEvents.remove(event.hashCode);
                    });
                    return;
                  }
                  setState(() {
                    checkedEvents.add(event.hashCode);
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventPage(event: event),
                    ),
                  );
                }
              },
              child: Container(
                height: 200.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.network(
                              "https://th.bing.com/th/id/OIP.4eWWTUHB9wIPvudLm1DIcAHaEK?cb=iwp2&rs=1&pid=ImgDetMain",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: Container(
                              padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimary.withAlpha(200),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                                size: 16.0,
                            ),
                          ),
                        ),
                          if (checkedEvents.contains(event.hashCode) ||
                              mode == EventMode.selecting)
                            Positioned(
                              left: 8.0,
                              top: 8.0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  checkedEvents.contains(event.hashCode)
                                      ? Icons.check
                                      : null,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 16.0,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 8.0,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    event.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeights.medium,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                    event.description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeights.light,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            color: Theme.of(context).colorScheme.onPrimary,
                            indent: 16.0,
                            endIndent: 16.0,
                          ),
                          Flexible(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FittedBox(
                                  child: Text(
                                      DateFormat(
                                        'd MMM yyyy',
                                      ).format(event.startDate),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                      "${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
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
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEvent()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
  