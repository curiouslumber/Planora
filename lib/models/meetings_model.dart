import 'package:hive/hive.dart';

part 'meetings_model.g.dart';

@HiveType(typeId: 2)
class MeetingsModel {
  @HiveField(0)
  final String meetingTitle;
  @HiveField(1)
  final String meetingLink;
  @HiveField(2)
  final DateTime startTime;
  @HiveField(3)
  final DateTime endTime;

  MeetingsModel({
    required this.meetingTitle,
    required this.meetingLink,
    required this.startTime,
    required this.endTime,
  });
}
