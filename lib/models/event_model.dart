import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final DateTime startTime;
  @HiveField(3)
  final DateTime endTime;

  EventModel({
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}
