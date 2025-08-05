import 'package:planora/models/event_model.dart';
import 'package:hive/hive.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/models/notes_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/models/todo_model.dart';

class HiveEvents {
  static const String eventsBox = 'eventsBox';
  static const String notesBox = 'notesBox';
  static const String meetingsBox = 'meetingsBox';
  static const String imageBox = 'imageBox';
  static const String tasksBox = 'tasksBox';
  static const String todosBox = 'todosBox';

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

  static Future<void> deleteEventFromHive(EventModel event) async {
    var box = await Hive.openBox<EventModel>(eventsBox);
    await box.delete(event.id);
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

  // Tasks CRUD
  static Future<void> addTaskToHive(TaskModel task) async {
    var box = await Hive.openBox<TaskModel>(tasksBox);
    await box.add(task);
  }

  static Future<List<TaskModel>> getTasksFromHive() async {
    var box = await Hive.openBox<TaskModel>(tasksBox);
    return box.values.toList();
  }

  static Future<void> updateTaskInHive(TaskModel task) async {
    var box = await Hive.openBox<TaskModel>(tasksBox);
    int index = box.values.toList().indexWhere((e) => e.id == task.id);
    await box.putAt(index, task);
  }

  static Future<void> deleteTaskFromHive(TaskModel task) async {
    var box = await Hive.openBox<TaskModel>(tasksBox);
    await box.delete(task.id);
  }

  static Future<void> deleteTasksFromHive(Set<int> selectedTaskIndices) async {
    var box = await Hive.openBox<TaskModel>(tasksBox);
    final keysToDelete = selectedTaskIndices.map((index) => box.keyAt(index));
    await box.deleteAll(keysToDelete);
  }

  // Todos CRUD
  static Future<void> addTodoToHive(TodoModel todo) async {
    var box = await Hive.openBox<TodoModel>(todosBox);
    await box.add(todo);
  }

  static Future<List<TodoModel>> getTodosFromHive() async {
    var box = await Hive.openBox<TodoModel>(todosBox);
    return box.values.toList();
  }

  static Future<TodoModel?> getTodoById(String id) async {
    var box = await Hive.openBox<TodoModel>(todosBox);
    return box.values.toList().firstWhere((e) => e.id == id);
  }

  static Future<void> updateTodoInHive(TodoModel todo) async {
    var box = await Hive.openBox<TodoModel>(todosBox);
    int index = box.values.toList().indexWhere((e) => e.id == todo.id);
    await box.putAt(index, todo);
  }

  static Future<void> deleteTodoFromHive(TodoModel todo) async {
    var box = await Hive.openBox<TodoModel>(todosBox);
    await box.deleteAt(box.values.toList().indexWhere((e) => e.id == todo.id));
  }

  static Future<void> deleteTodosFromHive(Set<int> selectedTodoIndices) async {
    var box = await Hive.openBox<TodoModel>(todosBox);
    final keysToDelete = selectedTodoIndices.map((index) => box.keyAt(index));
    await box.deleteAll(keysToDelete);
  }
}
