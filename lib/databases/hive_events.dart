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

  static Future<List<NotesModel>> getNotesFromHive() async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    return box.values.toList();
  }
}
