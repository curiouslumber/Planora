import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomFab extends StatefulWidget {
  final VoidCallback? onCreateEvent;
  final VoidCallback? onCreateTask;

  const CustomFab({
    super.key,
    this.onCreateEvent,
    this.onCreateTask,
  });

  @override
  State<CustomFab> createState() => _CustomFabState();
}

class _CustomFabState extends State<CustomFab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Event button
        Positioned(
          bottom: kBottomNavigationBarHeight + 56,
          left: MediaQuery.of(context).size.width * 0.09,
          child: ScaleTransition(
            scale: _animation,
            child: FloatingActionButton.extended(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              heroTag: 'event',
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                'Create Event',
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
          ),
        ),

        // Task button
        Positioned(
          bottom: kBottomNavigationBarHeight + 56,
          right: MediaQuery.of(context).size.width * 0.09,
          child: ScaleTransition(
            scale: _animation,
            child: FloatingActionButton.extended(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              heroTag: 'task',
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () {
                if (widget.onCreateTask != null) {
                  widget.onCreateTask!();
                }
                _toggle();
              },
              label: Text(
                'Create Task',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              icon: Icon(
                Icons.check_box_outlined,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
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
