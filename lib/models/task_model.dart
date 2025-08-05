import 'dart:io';

import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 4)
class TaskModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String notes;
  @HiveField(4)
  final bool doesRepeat;
  @HiveField(5)
  final String repeatOption;
  @HiveField(6)
  final List<String> selectedDays;
  @HiveField(7)
  final String taskStatus;
  @HiveField(8)
  final List<File> attachments;
  @HiveField(9)
  final DateTime createdAt;
  @HiveField(10)
  final DateTime updatedAt;
  @HiveField(11)
  final String priority;

  TaskModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.notes,
    this.doesRepeat = false,
    this.repeatOption = "never",
    this.selectedDays = const [],
    this.taskStatus = "ongoing",
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
    this.priority = "None",
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'notes': notes,
      'doesRepeat': doesRepeat,
      'repeatOption': repeatOption,
      'selectedDays': selectedDays,
      'taskStatus': taskStatus,
      'attachments': attachments,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'priority': priority,
    };
  }

  TaskModel copyWith({
    required String name,
    required String notes,
    required bool doesRepeat,
    required String repeatOption,
    required List<String> selectedDays,
    required String taskStatus,
    required List<File> attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String priority,
  }) {
    return TaskModel(
      id: id,
      userId: userId,
      name: name,
      notes: notes,
      doesRepeat: doesRepeat,
      repeatOption: repeatOption,
      selectedDays: selectedDays,
      taskStatus: taskStatus,
      attachments: attachments,
      createdAt: createdAt,
      updatedAt: updatedAt,
      priority: priority,
    );
  }

  static TaskModel? fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      notes: map['notes'],
      doesRepeat: map['doesRepeat'],
      repeatOption: map['repeatOption'],
      selectedDays: map['selectedDays'] as List<String>,
      taskStatus: map['taskStatus'],
      attachments: map['attachments'] as List<File>,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      priority: map['priority'] ?? 'None',
    );
  }
}
