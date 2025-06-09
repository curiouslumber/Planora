import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String eventTileImage;
  @HiveField(2)
  final List<double> eventTileVector;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String description;
  @HiveField(5)
  final String startDate;
  @HiveField(6)
  final String? endDate;
  @HiveField(7)
  final String startTime;
  @HiveField(8)
  final String endTime;
  @HiveField(9)
  final List<String>? people;
  @HiveField(10)
  final String? meeting;
  @HiveField(11)
  final String eventStatus;

  EventModel({
    required this.id,
    this.eventTileImage = '',
    this.eventTileVector = const [],
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
      'eventTileVector': eventTileVector,
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
