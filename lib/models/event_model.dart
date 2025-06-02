import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String objective;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  final DateTime? endDate;
  @HiveField(4)
  final DateTime startTime;
  @HiveField(5)
  final DateTime endTime;
  @HiveField(6)
  final Set<int>? people;
  @HiveField(7)
  final String? meetingLink;

  EventModel({
    required this.name,
    required this.objective,
    required this.startDate,
    this.endDate,
    required this.startTime,
    required this.endTime,
    this.people,
    this.meetingLink,
  });
}
