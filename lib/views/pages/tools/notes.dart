import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/widgets/note_builder.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  int? selectedIndex;
  bool newNote = false;
  List<NotesModel> notes = [];
  late TextEditingController titleController;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    textController = TextEditingController();
    getNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    textController.dispose();
    super.dispose();
  }

  void getNotes() async {
    var notesData = await HiveEvents.getNotesFromHive();
    setState(() {
      notes = notesData;
    });
  }

  void openNote({int? index}) {
    if (index != null) {
      titleController.text = notes[index].title;
      textController.text = notes[index].text;
      selectedIndex = index;
      newNote = false;
    } else {
      titleController.clear();
      textController.clear();
      selectedIndex = null;
      newNote = true;
    }
    setState(() {});
  }

  Future<void> saveOrUpdateNote() async {
    if (newNote) {
      if (titleController.text.isEmpty && textController.text.isEmpty) return;
      final note = NotesModel(
        title:
            titleController.text.isEmpty ? "Title here" : titleController.text,
        text: textController.text,
        createdAt: DateTime.now(),
      );
      await HiveEvents.addNoteToHive(note);
    } else if (selectedIndex != null) {
      final oldNote = notes[selectedIndex!];
      if (oldNote.title != titleController.text ||
          oldNote.text != textController.text) {
        await HiveEvents.updateNoteToHive(
          titleController.text,
          textController.text,
          selectedIndex!,
        );
      }
    }
    notes = await HiveEvents.getNotesFromHive();
    setState(() {
      selectedIndex = null;
      newNote = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actionsPadding: EdgeInsets.only(right: 24.0),
        actions: [
          if (selectedIndex != null || newNote)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: saveOrUpdateNote,
            ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            itemCount: notes.length,
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemBuilder: (context, index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () => openNote(index: index),
                child:
                    isSelected
                        ? const SizedBox.shrink()
                        : Stack(
                          fit: StackFit.expand,
                          children: [
                            Hero(
                              tag: 'note_$index',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notes[index].title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.headlineSmall!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      ),
                                    ),
                                    Text(
                                      notes[index].text,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Transform.scale(
                                scale: 1.3,
                                child: Checkbox(
                                  value: false,
                                  onChanged: (value) {},
                                  shape: CircleBorder(),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              );
            },
          ),
          if (selectedIndex != null || newNote)
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: 'note_$selectedIndex',
                    child: NoteBuilder(
                      selectedIndex: selectedIndex,
                      titleController: titleController,
                      textController: textController,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton:
          selectedIndex == null
              ? FloatingActionButton(
                shape: CircleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                child: const Icon(Icons.add),
                onPressed: () => openNote(),
              )
              : null,
    );
  }
}
