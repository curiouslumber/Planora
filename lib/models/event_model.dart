import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String eventTileImage;
  @HiveField(2)
  final String eventTileImageLocalUrl;
  @HiveField(3)
  final bool isImageProcessing;
  @HiveField(4)
  final String name;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final String startDate;
  @HiveField(7)
  final String? endDate;
  @HiveField(8)
  final String startTime;
  @HiveField(9)
  final String endTime;
  @HiveField(10)
  final List<String>? people;
  @HiveField(11)
  final String? meeting;
  @HiveField(12)
  final String eventStatus;
  @HiveField(13)
  final DateTime createdAt;
  @HiveField(14)
  final DateTime updatedAt;

  EventModel({
    required this.id,
    required this.eventTileImage,
    this.eventTileImageLocalUrl = "",
    this.isImageProcessing = false,
    required this.name,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.startTime,
    required this.endTime,
    this.people = const [],
    this.meeting,
    this.eventStatus = "upcoming",
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'eventTileImage': eventTileImage,
      'eventTileImageLocalUrl': eventTileImageLocalUrl,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'people': people,
      'meeting': meeting,
      'eventStatus': eventStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  EventModel copyWith({
    required String eventTileImage,
    required String eventStatus,
    required String eventTileImageLocalUrl,
    required bool isImageProcessing,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) {
    return EventModel(
      id: id,
      eventTileImage: eventTileImage,
      eventTileImageLocalUrl: eventTileImageLocalUrl,
      isImageProcessing: isImageProcessing,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      people: people,
      meeting: meeting,
      eventStatus: eventStatus,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
