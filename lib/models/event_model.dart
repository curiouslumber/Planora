import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime startDate;
  @HiveField(4)
  final DateTime? endDate;
  @HiveField(5)
  final DateTime startTime;
  @HiveField(6)
  final DateTime endTime;
  @HiveField(7)
  final Set<String>? people;
  @HiveField(8)
  final String? meeting;
  @HiveField(9)
  final String eventStatus;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.startTime,
    required this.endTime,
    this.people,
    this.meeting,
    this.eventStatus = "upcoming",
  });
}
