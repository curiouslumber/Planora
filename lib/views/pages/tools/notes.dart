import 'package:flutter/material.dart';
import 'package:planora/widgets/expanded_notes_overlay.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/databases/hive_events.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> with SingleTickerProviderStateMixin {
  int? expandedIndex;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<NotesModel> notes = [];
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    // Animation controller for expanding/collapsing note
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final loadedNotes = await HiveEvents.getNotesFromHive();
    setState(() {
      notes = loadedNotes;
      for (int i = 0; i < notes.length; i++) {
        _controllers[i] = TextEditingController(text: notes[i].content);
      }
    });
  }

  Future<void> _saveNote(int index) async {
    final note = notes[index];
    final updated = NotesModel(
      id: note.id,
      title: note.title,
      content: _controllers[index]?.text ?? '',
      createdAt: note.createdAt,
      updatedAt: DateTime.now(),
      color: note.color,
    );
    notes[index] = updated;
    await HiveEvents.addNotesToHive(updated);
    setState(() {});
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
                  itemCount: notes.length,
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
                            child: Text(
                              notes[index].title.isNotEmpty
                                  ? notes[index].title
                                  : 'Note ${index + 1}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Overlay for expanded note
              if (expandedIndex != null)
                ExpandedNoteOverlay(
                  animation: _animation,
                  expandedIndex: expandedIndex!,
                  crossAxisCount: crossAxisCount,
                  spacing: spacing,
                  padding: padding,
                  tileWidth: tileWidth,
                  tileHeight: tileHeight,
                  constraints: constraints,
                  onClose: () async {
                    await _saveNote(expandedIndex!);
                    _close();
                  },
                  note: notes[expandedIndex!],
                  controller: _controllers[expandedIndex!]!,
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
        onPressed: () async {
          // Add a new note
          final newNote = NotesModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'New Note',
            content: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            color: '0xFF4CAF50',
          );
          await HiveEvents.addNotesToHive(newNote);
          await _loadNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
