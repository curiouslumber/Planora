import 'package:planora/models/event_model.dart';
import 'package:hive/hive.dart';
import 'package:planora/models/notes_model.dart';

class HiveEvents {
  static const String eventsBox = 'eventsBox';
  static const String notesBox = 'notesBox';

  static Future<void> addEventToHive(EventModel event) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    await box.add(event);
  }

  static Future<List<EventModel>> getEventsFromHive() async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    return box.values.toList();
  }

  static Future<void> addNoteToHive(NotesModel note) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    await box.add(note);
  }

  static Future<bool> updateNoteToHive(
    String title,
    String text,
    int index,
  ) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    NotesModel? note = box.get(index);
    if (note == null) return false;
    NotesModel? newNote = NotesModel(
      title: title,
      text: text,
      createdAt: note.createdAt,
    );
    await box.putAt(index, newNote);
    return true;
  }

  static Future<List<NotesModel>> getNotesFromHive() async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    return box.values.toList();
  }
}
