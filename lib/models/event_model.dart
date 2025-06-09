import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String eventTileImage;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String startDate;
  @HiveField(5)
  final String? endDate;
  @HiveField(6)
  final String startTime;
  @HiveField(7)
  final String endTime;
  @HiveField(8)
  final List<String>? people;
  @HiveField(9)
  final String? meeting;
  @HiveField(10)
  final String eventStatus;

  EventModel({
    required this.id,
    this.eventTileImage = '',
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

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'eventTileImage': eventTileImage,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'people': people,
      'meeting': meeting,
      'eventStatus': eventStatus,
    };
  }
}
