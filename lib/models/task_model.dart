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
  final String taskStatus;
  @HiveField(5)
  final List<File> attachments;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.notes,
    this.taskStatus = "ongoing",
    this.attachments = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'notes': notes,
      'taskStatus': taskStatus,
      'attachments': attachments,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  TaskModel copyWith({
    required String name,
    required String notes,
    required String taskStatus,
    required List<File> attachments,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return TaskModel(
      id: id,
      userId: userId,
      name: name,
      notes: notes,
      taskStatus: taskStatus,
      attachments: attachments,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static TaskModel? fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      userId: map['userId'],
      name: map['name'],
      notes: map['notes'],
      taskStatus: map['taskStatus'],
      attachments: map['attachments'] as List<File>,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }
}
