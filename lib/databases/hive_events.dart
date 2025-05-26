import 'package:planora/models/event_model.dart';
import 'package:hive/hive.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';

class HiveEvents {
  static const String eventsBox = 'eventsBox';
  static const String notesBox = 'notesBox';
  static const String meetingsBox = 'meetingsBox';

  static Future<void> addEventToHive(EventModel event) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    await box.add(event);
  }

  static Future<List<EventModel>> getEventsFromHive() async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    return box.values.toList();
  }

// Notes CRUD
  static Future<void> addNoteToHive(NotesModel note) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    await box.add(note);
  }

  static Future<List<NotesModel>> getNotesFromHive() async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    return box.values.toList();
  }

  static Future<void> updateNoteToHive(
    NotesModel note,
    int selectedIndex,
  ) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    await box.putAt(selectedIndex, note);
  }

  static Future<void> deleteNoteFromHive(int index) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    await box.deleteAt(index);
  }

  static Future<void> deleteNotesFromHive(Set<int> selectedNoteIndices) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    final keysToDelete = selectedNoteIndices.map((index) => box.keyAt(index));
    await box.deleteAll(keysToDelete);
  }

// Meetings CRUD
  static Future<void> addMeetingToHive(MeetingsModel meeting) async {
    var box = await Hive.openBox<MeetingsModel>(meetingsBox);
    await box.add(meeting);
  }

  static Future<List<MeetingsModel>> getMeetingsFromHive() async {
    var box = await Hive.openBox<MeetingsModel>(meetingsBox);
    return box.values.toList();
  }

  static Future<void> updateMeetingToHive(
    int selectedIndex,
    MeetingsModel meeting
  ) async {
    var box = await Hive.openBox<MeetingsModel>(meetingsBox);
    await box.putAt(selectedIndex, meeting);
  }

  static Future<void> deleteMeetingFromHive(int index) async {
    var box = await Hive.openBox<MeetingsModel>(meetingsBox);
    await box.deleteAt(index);
  }

  static Future<void> deleteMeetingsFromHive(Set<int> selectedMeetingIndices) async {
    var box = await Hive.openBox<MeetingsModel>(meetingsBox);
    final keysToDelete = selectedMeetingIndices.map((index) => box.keyAt(index));
    await box.deleteAll(keysToDelete);
  }
}
