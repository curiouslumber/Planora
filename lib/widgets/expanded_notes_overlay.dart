import 'package:flutter/material.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/utils/font_weights.dart';

class ExpandedNoteOverlay extends StatelessWidget {
  final Animation<double> animation;
  final int expandedIndex;
  final int crossAxisCount;
  final double spacing;
  final double padding;
  final double tileWidth;
  final double tileHeight;
  final BoxConstraints constraints;
  final VoidCallback onClose;
  final NotesModel note;
  final TextEditingController controller;

  const ExpandedNoteOverlay({
    super.key,
    required this.animation,
    required this.expandedIndex,
    required this.crossAxisCount,
    required this.spacing,
    required this.padding,
    required this.tileWidth,
    required this.tileHeight,
    required this.constraints,
    required this.onClose,
    required this.note,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Calculate row and col for expandedIndex
        final row = expandedIndex ~/ crossAxisCount;
        final col = expandedIndex % crossAxisCount;
        final startTop = padding + row * (tileHeight + spacing);
        final startLeft = padding + col * (tileWidth + spacing);
        final startRight = constraints.maxWidth - startLeft - tileWidth;
        final startBottom = constraints.maxHeight - startTop - tileHeight;
        // End positions
        final endTop = 24.0;
        final endLeft = 24.0;
        final endRight = 24.0;
        final endBottom = 24.0 + kBottomNavigationBarHeight;
        // Interpolate
        final top = startTop + (endTop - startTop) * animation.value;
        final left = startLeft + (endLeft - startLeft) * animation.value;
        final right = startRight + (endRight - startRight) * animation.value;
        final bottom =
            startBottom + (endBottom - startBottom) * animation.value;
        final borderRadius = 8.0 + (16.0 - 8.0) * animation.value;
        final boxShadowBlur = 0.0 + 16.0 * animation.value;
        final paddingAnim = 12.0 + (24.0 - 12.0) * animation.value;
        return Positioned(
          top: top,
          left: left,
          right: right,
          bottom: bottom,
          child: Opacity(
            opacity: animation.value,
            child: Material(
              color: Colors.transparent,
              child: AnimatedContainer(
                duration: Duration.zero, // controlled by AnimationController
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
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: onClose,
                      ),
                    ),
                    // Note content
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Note title
                        Text(
                          'Note $expandedIndex',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Editable note text field
                        Expanded(
                          child: TextField(
                            cursorColor:
                                Theme.of(context).colorScheme.onPrimary,
                            maxLines: null,
                            style: TextStyle(
                              fontWeight: FontWeights.regular,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Write your note here...',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withAlpha(150),
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
    );
  }
}
