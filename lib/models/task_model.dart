import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 4)
class TaskModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String taskTileImage;
  @HiveField(2)
  final String taskTileImageLocalUrl;
  @HiveField(3)
  final bool isImageProcessing;
  @HiveField(4)
  final String name;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final String taskStatus;
  @HiveField(7)
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.taskTileImage,
    this.isImageProcessing = false,
    this.taskTileImageLocalUrl = "",
    required this.name,
    required this.description,
    this.taskStatus = "ongoing",
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'taskTileImage': taskTileImage,
      'taskTileImageLocalUrl': taskTileImageLocalUrl,
      'name': name,
      'description': description,
      'taskStatus': taskStatus,
      'createdAt': createdAt,
    };
  }

  TaskModel copyWith({
    required String taskTileImage,
    required String taskStatus,
    required String taskTileImageLocalUrl,
    required bool isImageProcessing,
  }) {
    return TaskModel(
      id: id,
      taskTileImage: taskTileImage,
      taskTileImageLocalUrl: taskTileImageLocalUrl,
      name: name,
      description: description,
      createdAt: createdAt,
      taskStatus: taskStatus,
      isImageProcessing: isImageProcessing,
    );
  }
}
