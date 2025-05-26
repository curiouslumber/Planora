import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Meetings extends StatelessWidget {
  const Meetings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text("Add Meetings")),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        overlayOpacity: 0.4,
        spacing: 12,
        spaceBetweenChildren: 12,
        childrenButtonSize: const Size(56, 56),
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.video_call),
            label: 'Add Meeting Link',
            labelShadow: List.empty(),
            onTap: () {
              // Implement your logic here
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.schedule),
            label: 'Schedule for later',
            labelShadow: List.empty(),
            onTap: () {
              // Implement your logic here
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.north_west_sharp),
            label: 'Schedule Now',
            labelShadow: List.empty(),
            onTap: () {
              // Implement your logic here
            },
          ),
        ],
      ),
    );
  }
}
