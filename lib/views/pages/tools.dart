import 'package:flutter/material.dart';
import 'package:planora/views/pages/tools/calendar_tool.dart';
import 'package:planora/views/pages/tools/events.dart';
import 'package:planora/views/pages/tools/meetings.dart';
import 'package:planora/views/pages/tools/notes.dart';
import 'package:planora/views/pages/tools/people.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    final toolsText = ['Events', 'People', 'Calendar', 'Meetings', 'Notes'];
    final toolsIcons = [
      Icons.event,
      Icons.people,
      Icons.calendar_today,
      Icons.meeting_room,
      Icons.sticky_note_2_outlined,
    ];
    final toolPages = [Events(), People(), CalendarTool(), Meetings(), Notes()];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tools',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double itemSize =
              (constraints.maxWidth - 48) / 2; // Adjust for padding and spacing
          return GridView.builder(
            padding: const EdgeInsets.all(24.0),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemSize,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1, // Ensures square shape
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () =>
                        index == 5
                            ? ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Coming soon!',
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            )
                            : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => toolPages[index]),
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        index == 5
                            ? Theme.of(context).colorScheme.surfaceContainer
                            : Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Center(
                    child:
                        index != 5
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 16.0,
                              children: [
                                Icon(
                                  toolsIcons[index],
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 40.0,
                                ),
                                Text(
                                  toolsText[index],
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 4.0,
                              children: [
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.add,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                  size: 20.0,
                                  weight: 2.0,
                                ),
                              ],
                            ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
