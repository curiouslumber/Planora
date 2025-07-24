import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomFab extends StatefulWidget {
  final VoidCallback? onCreateEvent;
  final VoidCallback? onCreateTodo;

  const CustomFab({super.key, this.onCreateEvent, this.onCreateTodo});

  @override
  State<CustomFab> createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab> {
  bool _isOpen = false;

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (_isOpen)
          Positioned(
            bottom: kBottomNavigationBarHeight + 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                // Event button
                FloatingActionButton.extended(
                  heroTag: 'event',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  extendedPadding: EdgeInsets.symmetric(horizontal: 16),
                  label: Text(
                    'Event',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  icon: Icon(
                    Icons.event,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    if (widget.onCreateEvent != null) {
                      widget.onCreateEvent!();
                    }
                    _toggle();
                  },
                ),

                // Todo button
                FloatingActionButton.extended(
                  heroTag: 'todo',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    if (widget.onCreateTodo != null) {
                      widget.onCreateTodo!();
                    }
                    _toggle();
                  },
                  label: Text(
                    'Todo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  icon: Icon(
                    Icons.check_box_outlined,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),

        // Main FAB
        Positioned(
          bottom: kBottomNavigationBarHeight - 8,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: const CircleBorder(),
            onPressed: _toggle,
            child: Icon(
              _isOpen ? Icons.close : Ionicons.add,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
