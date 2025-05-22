import 'package:flutter/material.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with SingleTickerProviderStateMixin {
  int? expandedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Animation controller for expanding/collapsing note
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  // Handle expanding a note tile
  void _expand(int index) {
    setState(() {
      expandedIndex = index;
    });
    _controller.forward(from: 0);
  }

  // Handle closing the expanded note
  void _close() {
    // Animate back to grid position before removing overlay
    _controller.reverse().then((_) {
      setState(() {
        expandedIndex = null;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate grid tile positions and sizes
    final gridKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Grid parameters
          const crossAxisCount = 2;
          const spacing = 16.0;
          const padding = 12.0;
          final gridWidth = constraints.maxWidth - 2 * padding;
          final tileWidth = (gridWidth - spacing) / crossAxisCount;
          final tileHeight = tileWidth; // square tiles

          return Stack(
            children: [
              // Main grid of notes
              Center(
                child: GridView.builder(
                  key: gridKey,
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                  ),
                  padding: const EdgeInsets.all(padding),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _expand(index),
                      child: Hero(
                        tag: 'note_$index',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(index.toString()),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Overlay for expanded note
              if (expandedIndex != null)
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    // Calculate row and col for expandedIndex
                    final row = expandedIndex! ~/ crossAxisCount;
                    final col = expandedIndex! % crossAxisCount;
                    final startTop = padding + row * (tileHeight + spacing);
                    final startLeft = padding + col * (tileWidth + spacing);
                    final startRight =
                        constraints.maxWidth - startLeft - tileWidth;
                    final startBottom =
                        constraints.maxHeight - startTop - tileHeight;
                    // End positions
                    final endTop = 24.0;
                    final endLeft = 24.0;
                    final endRight = 24.0;
                    final endBottom = 24.0 + kBottomNavigationBarHeight;
                    // Interpolate
                    final top =
                        startTop + (endTop - startTop) * _animation.value;
                    final left =
                        startLeft + (endLeft - startLeft) * _animation.value;
                    final right =
                        startRight + (endRight - startRight) * _animation.value;
                    final bottom =
                        startBottom +
                        (endBottom - startBottom) * _animation.value;
                    final borderRadius = 8.0 + (16.0 - 8.0) * _animation.value;
                    final boxShadowBlur = 0.0 + 16.0 * _animation.value;
                    final paddingAnim = 12.0 + (24.0 - 12.0) * _animation.value;
                    return Positioned(
                      top: top,
                      left: left,
                      right: right,
                      bottom: bottom,
                      child: Opacity(
                        opacity: _animation.value,
                        child: Material(
                          color: Colors.transparent,
                          child: AnimatedContainer(
                            duration:
                                Duration
                                    .zero, // controlled by AnimationController
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(borderRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: boxShadowBlur,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(paddingAnim),
                            child: Stack(
                              children: [
                                // Close button in the top right
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                    ),
                                    onPressed: _close,
                                  ),
                                ),
                                // Note content
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Note title
                                    Text(
                                      'Note ${expandedIndex!}',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Editable note text field
                                    Expanded(
                                      child: TextField(
                                        maxLines: null,
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onPrimary,
                                          fontSize: 18,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Write your note here...',
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.6),
                                          ),
                                          border: InputBorder.none,
                                        ),
                                        autofocus: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        onPressed: () {
          // Add your action here
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
