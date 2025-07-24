import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 5)
class TodoModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String todo;
  @HiveField(4)
  final bool doesRepeat;
  @HiveField(5)
  final String repeatOption;
  @HiveField(6)
  final List<String> selectedDays;
  @HiveField(7)
  final String todoStatus;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final DateTime updatedAt;
  @HiveField(11)
  final String priority;

  TodoModel({
    required this.id,
    required this.userId,
    required this.todo,
    this.doesRepeat = false,
    this.repeatOption = "never",
    this.selectedDays = const [],
    this.todoStatus = "ongoing",
    required this.createdAt,
    required this.updatedAt,
    this.priority = "None",
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'todo': todo,
      'doesRepeat': doesRepeat,
      'repeatOption': repeatOption,
      'selectedDays': selectedDays,
      'todoStatus': todoStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'priority': priority,
    };
  }

  TodoModel copyWith({
    required String todo,
    required bool doesRepeat,
    required String repeatOption,
    required List<String> selectedDays,
    required String todoStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String priority,
  }) {
    return TodoModel(
      id: id,
      userId: userId,
      todo: todo,
      doesRepeat: doesRepeat,
      repeatOption: repeatOption,
      selectedDays: selectedDays,
      todoStatus: todoStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
      priority: priority,
    );
  }

  static TodoModel? fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      userId: map['userId'],
      todo: map['todo'],
      doesRepeat: map['doesRepeat'],
      repeatOption: map['repeatOption'],
      selectedDays: map['selectedDays'] as List<String>,
      todoStatus: map['todoStatus'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      priority: map['priority'] ?? 'None',
    );
  }
}
