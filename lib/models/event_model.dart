import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? userId;
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
  final String? meeting;
  @HiveField(12)
  final String eventStatus;
  @HiveField(13)
  final DateTime createdAt;
  @HiveField(14)
  final DateTime updatedAt;
  @HiveField(15)
  final Map<String, String>? attribution;
  @HiveField(16, defaultValue: true)
  final bool isSynced;

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
    this.meeting,
    this.eventStatus = "upcoming",
    required this.createdAt,
    required this.updatedAt,
    this.attribution,
    this.isSynced = true,
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
      'meeting': meeting,
      'eventStatus': eventStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'attribution': attribution,
      'isSynced': isSynced,
    };
  }

  EventModel copyWith({
    String? id,
    String? userId,
    String? eventTileImage,
    String? eventTileImageLocalUrl,
    bool? isImageProcessing,
    String? name,
    String? description,
    String? startDate,
    String? endDate,
    String? startTime,
    String? endTime,
    String? meeting,
    String? eventStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, String>? attribution,
    bool? isSynced,
  }) {
    return EventModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventTileImage: eventTileImage ?? this.eventTileImage,
      eventTileImageLocalUrl: eventTileImageLocalUrl ?? this.eventTileImageLocalUrl,
      isImageProcessing: isImageProcessing ?? this.isImageProcessing,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      meeting: meeting ?? this.meeting,
      eventStatus: eventStatus ?? this.eventStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      attribution: attribution ?? this.attribution,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  static EventModel fromJson(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      userId: map['userId'],
      eventTileImage: map['eventTileImage'],
      eventTileImageLocalUrl: map['eventTileImageLocalUrl'],
      isImageProcessing: map['isImageProcessing'],
      name: map['name'],
      description: map['description'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      meeting: map['meeting'],
      eventStatus: map['eventStatus'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      attribution: map['attribution'],
      isSynced: map['isSynced'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'eventTileImage': eventTileImage,
      'eventTileImageLocalUrl': eventTileImageLocalUrl,
      'isImageProcessing': isImageProcessing,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'meeting': meeting,
      'eventStatus': eventStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'attribution': attribution,
      'isSynced': isSynced,
    };
  }
}
