import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class EventModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String startTime;

  @HiveField(4)
  final String endTime;

  @HiveField(5)
  final bool isCompleted;

  EventModel({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.isCompleted = false,
  });

  // Format the start time for display
  String getFormattedStartTime() {
    try {
      final timeFormat = DateFormat('HH:mm');
      final dateTime = timeFormat.parse(startTime);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return startTime;
    }
  }

  // Format the end time for display
  String getFormattedEndTime() {
    try {
      final timeFormat = DateFormat('HH:mm');
      final dateTime = timeFormat.parse(endTime);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return endTime;
    }
  }

  // Get formatted date for display
  String getFormattedDate() {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final dateTime = dateFormat.parse(date);
      return DateFormat('EEEE, d MMMM yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  // Create a copy of this event with some fields changed
  EventModel copyWith({
    String? id,
    String? title,
    String? date,
    String? startTime,
    String? endTime,
    bool? isCompleted,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Convert event to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'isCompleted': isCompleted,
    };
  }

  // Create event from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      date: json['date'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}
