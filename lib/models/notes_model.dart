import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 1)
class NotesModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String text;
  @HiveField(3)
  final DateTime createdAt;

  NotesModel({
    required this.id,
    required this.title,
    required this.text,
    required this.createdAt,
  });
}
