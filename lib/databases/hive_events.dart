import 'package:planora/models/event_model.dart';
import 'package:hive/hive.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/models/people_model.dart';

class HiveEvents {
  static const String eventsBox = 'eventsBox';
  static const String notesBox = 'notesBox';
  static const String meetingsBox = 'meetingsBox';
  static const String peopleBox = 'peopleBox';
  static const String imageBox = 'imageBox';

// Events CRUD
  static Future<void> addEventToHive(EventModel event) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    await box.add(event);
  }

  static Future<List<EventModel>> getEventsFromHive() async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    return box.values.toList();
  }

  static Future<void> updateEventInHive(
    EventModel event,
  ) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    int index = box.values.toList().indexWhere((e) => e.id == event.id);
    await box.putAt(index, event);
  }

  static Future<void> deleteEventFromHive(int index) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    await box.deleteAt(index);
  }

  static Future<void> deleteEventsFromHive(
    Set<int> selectedEventIndices,
  ) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    final keysToDelete = selectedEventIndices.map((index) => box.keyAt(index));
    await box.deleteAll(keysToDelete);
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

  static Future<void> updateNoteInHive(
    NotesModel note,
  ) async {
    var box = await Hive.openBox<NotesModel>(notesBox);
    int index = box.values.toList().indexWhere((e) => e.id == note.id);
    await box.putAt(index, note);
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

  static Future<void> updateMeetingInHive(
    MeetingsModel meeting
  ) async {
    var box = await Hive.openBox<MeetingsModel>(meetingsBox);
    int index = box.values.toList().indexWhere((e) => e.id == meeting.id);
    await box.putAt(index, meeting);
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

  // People CRUD
  static Future<void> addPeopleToHive(PeopleModel people) async {
    var box = await Hive.openBox<PeopleModel>(peopleBox);
    await box.add(people);
  }

  static Future<List<PeopleModel>> getPeopleFromHive() async {
    var box = await Hive.openBox<PeopleModel>(peopleBox);
    return box.values.toList();
  }

  static Future<void> updatePeopleInHive(
    PeopleModel people,
  ) async {
    var box = await Hive.openBox<PeopleModel>(peopleBox);
    int index = box.values.toList().indexWhere((e) => e.id == people.id);
    await box.putAt(index, people);
  }

  static Future<void> deletePeopleFromHive(int index) async {
    var box = await Hive.openBox<PeopleModel>(peopleBox);
    await box.deleteAt(index);
  }

  static Future<void> deletePeoplesFromHive(
    Set<int> selectedPeopleIndices,
  ) async {
    var box = await Hive.openBox<PeopleModel>(peopleBox);
    final keysToDelete = selectedPeopleIndices.map((index) => box.keyAt(index));
    await box.deleteAll(keysToDelete);
  }
}
