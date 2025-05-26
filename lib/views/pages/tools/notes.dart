import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/utils/dialogs.dart';
import 'package:planora/widgets/note_builder.dart';

enum NoteMode { none, editing, creating, selecting }

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  NoteMode mode = NoteMode.none;
  int? selectedIndex;
  late List<NotesModel> notes = [];
  bool areNotesLoading = false;
  late TextEditingController titleController;
  late TextEditingController textController;
  Set<int> selectedNoteIndices = {};

  @override
  void initState() {
    super.initState();
    areNotesLoading = true;
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

  // Get all notes
  void getNotes() async {
    var notesData = await HiveEvents.getNotesFromHive();
    setState(() {
      notes = notesData;
      areNotesLoading = false;
    });
  }

  // Open Note
  void openNote({int? index}) {
    if (index != null) {
      titleController.text = notes[index].title;
      textController.text = notes[index].text;
      selectedIndex = index;
      mode = NoteMode.editing;
    } else {
      titleController.clear();
      textController.clear();
      selectedIndex = null;
      mode = NoteMode.creating;
    }
    setState(() {});
  }

  // Create or Update Existing Note
  Future<void> saveOrUpdateNote() async {
    if (mode == NoteMode.none) {
      setState(() {
        selectedIndex = null;
      });
      return;
    }

    final title = titleController.text.trim();
    final text = textController.text.trim();

    if (mode == NoteMode.creating) {
      if (title.isEmpty && text.isEmpty) {
        setState(() {
          selectedIndex = null;
          mode = NoteMode.none;
        });
        return;
      }
      final note = NotesModel(
        title: title.isEmpty ? "Title here" : title,
        text: text,
        createdAt: DateTime.now(),
      );
      await HiveEvents.addNoteToHive(note);
      setState(() {
        // Append new note to the end
        notes.add(note);
      });
    } else if (mode == NoteMode.editing && selectedIndex != null) {
      final oldNote = notes[selectedIndex!];
      if (oldNote.title != title || oldNote.text != text) {
        NotesModel newNote = NotesModel(
          title: title,
          text: text,
          createdAt: notes[selectedIndex!].createdAt,
        );
        await HiveEvents.updateNoteToHive(newNote, selectedIndex!);
        setState(() {
          // Update note with the new data
          notes[selectedIndex!] = newNote;
        });
      }
    }

    setState(() {
      selectedIndex = null;
      mode = NoteMode.none;
    });
  }

  Future<void> deleteNote() async {
    if (selectedIndex != null) {
      await HiveEvents.deleteNoteFromHive(selectedIndex!);
      notes.removeAt(selectedIndex!);
      setState(() {
        selectedIndex = null;
        mode = NoteMode.none;
      });
    }
  }

  Future<void> deleteNotes() async {
    if (selectedNoteIndices.isNotEmpty) {
      await HiveEvents.deleteNotesFromHive(selectedNoteIndices);
      final sortedIndices =
          selectedNoteIndices.toList()..sort((a, b) => b.compareTo(a));
      for (var index in sortedIndices) {
        notes.removeAt(index);
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${selectedNoteIndices.length} ${selectedNoteIndices.length > 1 ? 'notes' : 'note'} deleted',
          ),
        ),
      );
      selectedNoteIndices.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditingOrCreating =
        mode == NoteMode.editing || mode == NoteMode.creating;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actionsPadding: EdgeInsets.only(right: 24.0),
        actions: [
          if (selectedNoteIndices.isNotEmpty) ...[
            IconButton(
              icon: Icon(CupertinoIcons.delete),
              onPressed: () => confirmDeleteNotes(context, deleteNotes),
            ),
          ],
          if (isEditingOrCreating) ...[
            if (mode == NoteMode.editing)
              IconButton(
                icon: Icon(CupertinoIcons.delete),
                onPressed: deleteNote,
              ),
            IconButton(icon: Icon(Icons.close), onPressed: saveOrUpdateNote),
          ],
        ],
      ),
      body:
          notes.isNotEmpty || mode == NoteMode.creating
              ? Stack(
                children: [
                  GridView.builder(
                    itemCount: notes.length,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                        ),
                    itemBuilder: (context, index) {
                      final isSelected =
                          mode == NoteMode.editing && selectedIndex == index;
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
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.0,
                                          horizontal: 16.0,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8.0,
                                          children: [
                                            Text(
                                              notes[index].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.surface,
                                                  ),
                                            ),
                                            Text(
                                              notes[index].text,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
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
                                          value: selectedNoteIndices.contains(
                                            index,
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (selectedNoteIndices.contains(
                                                index,
                                              )) {
                                                selectedNoteIndices.remove(
                                                  index,
                                                );
                                              } else {
                                                selectedNoteIndices.add(index);
                                              }
                                            });
                                          },
                                          shape: CircleBorder(),
                                          side: BorderSide(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.surface,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      );
                    },
                  ),
                  if (isEditingOrCreating)
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
              )
              : !areNotesLoading
              ? Center(child: Text("No notes found"))
              : CircularProgressIndicator(),
      floatingActionButton:
          mode == NoteMode.none
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
