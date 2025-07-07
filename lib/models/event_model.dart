import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String eventTileImage;
  @HiveField(3)
  final String eventTileImageLocalUrl;
  @HiveField(4)
  final bool isImageProcessing;
  @HiveField(5)
  final String name;
  @HiveField(6)
  final String description;
  @HiveField(7)
  final String startDate;
  @HiveField(8)
  final String? endDate;
  @HiveField(9)
  final String startTime;
  @HiveField(10)
  final String endTime;
  @HiveField(11)
  final List<String>? people;
  @HiveField(12)
  final String? meeting;
  @HiveField(13)
  final String eventStatus;
  @HiveField(14)
  final DateTime createdAt;
  @HiveField(15)
  final DateTime updatedAt;
  @HiveField(16)
  final Map<String, String>? attribution;

  EventModel({
    required this.id,
    required this.userId,
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
    this.attribution,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
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
      'attribution': attribution,
    };
  }

  EventModel copyWith({
    required String userId,
    required String eventTileImage,
    required String eventStatus,
    required String eventTileImageLocalUrl,
    required bool isImageProcessing,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Map<String, String>? attribution
  }) {
    return EventModel(
      id: id,
      userId: userId,
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
      attribution: attribution,
    );
  }
}
