import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:planora/views/pages/tools/events/add_event.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<EventModel> events = [];
  Map<int, Map<String, int>> gridTileConstants = {
    0: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
    1: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    2: {'crossAxisCellCount': 1, 'mainAxisCellCount': 1},
    3: {'crossAxisCellCount': 2, 'mainAxisCellCount': 1},
  };

  void getEvents() async {
    events = await HiveEvents.getEventsFromHive();
    setState(() {});
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
                'Good Morning,',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeights.regular,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Noel Pinto!',
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
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Excellent! Your today’s plan is almost done',
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
                            value: 0.8,
                            color: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.4),
                          ),
                          Text(
                            '82%',
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
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                event.name,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${DateFormat('jm').format(event.startDate)} ${event.endDate != null ? ' - ${DateFormat('jm').format(event.endDate!)}' : ''}',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 12,
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
            Container(
              width: double.infinity,
              height: 60.0,
              alignment: Alignment.center,
              child: Text(
                'None to show here...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 24),
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
