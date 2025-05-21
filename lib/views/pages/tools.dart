import 'package:flutter/material.dart';
import 'package:planora/views/pages/tools/calendar_tool.dart';
import 'package:planora/views/pages/tools/meetings.dart';
import 'package:planora/views/pages/tools/notes.dart';
import 'package:planora/views/pages/tools/people.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    final toolsText = ['Notes', 'People', 'Meetings', 'Calendar'];
    final toolsIcons = [
      Icons.sticky_note_2_outlined,
      Icons.people,
      Icons.meeting_room,
      Icons.calendar_month,
    ];
    final toolPages = [Notes(), People(), Meetings(), CalendarTool()];

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
            itemCount: 5,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: itemSize,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 1, // Ensures square shape
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => toolPages[index]),
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        index == 4
                            ? Theme.of(context).colorScheme.surfaceContainer
                            : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Center(
                    child:
                        index != 4
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
