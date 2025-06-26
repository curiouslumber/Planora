import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 4)
class TaskModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String notes;
  @HiveField(3)
  final String taskStatus;
  @HiveField(4)
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.name,
    required this.notes,
    this.taskStatus = "ongoing",
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
      'taskStatus': taskStatus,
      'createdAt': createdAt,
    };
  }

  TaskModel copyWith({
    required String name,
    required String notes,
    required String taskStatus,
  }) {
    return TaskModel(
      id: id,
      name: name,
      notes: notes,
      taskStatus: taskStatus,
      createdAt: createdAt,
    );
  }
}
