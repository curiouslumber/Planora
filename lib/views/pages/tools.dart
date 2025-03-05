import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

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
              return Container(
                decoration: BoxDecoration(
                  color:
                      index == 4
                          ? context.theme.colorScheme.inverseSurface
                          // ignore: deprecated_member_use
                          .withOpacity(0.9)
                          // ignore: deprecated_member_use
                          : context.theme.colorScheme.primary.withOpacity(0.9),
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
                                color: context.theme.colorScheme.onPrimary,
                                size: 40.0,
                              ),
                              Text(
                                toolsText[index],
                                style: TextStyle(
                                  color: context.theme.colorScheme.onPrimary,
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
                                  color: context.theme.colorScheme.onPrimary,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Icon(
                                Icons.add,
                                color: context.theme.colorScheme.onPrimary,
                                size: 20.0,
                                weight: 2.0,
                              ),
                            ],
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
