import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/utils/app_config.dart';
import 'base_repository.dart';

class MeetingsRepository extends BaseRepository<MeetingsModel, String> {
  MeetingsRepository() : super(boxName: 'meetings', collectionName: 'meetings');

  @override
  MeetingsModel fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MeetingsModel(
      id: doc.id,
      meetingTitle: data['meetingTitle'] ?? '',
      meetingLink: data['meetingLink'] ?? '',
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
    );
  }

  @override
  Map<String, dynamic> toMap(MeetingsModel meeting) {
    return {
      'id': meeting.id,
      'meetingTitle': meeting.meetingTitle,
      'meetingLink': meeting.meetingLink,
      'startTime': meeting.startTime,
      'endTime': meeting.endTime,
    };
  }

  @override
  String getId(MeetingsModel item) => item.id;

  /// Gets upcoming meetings (meetings with start time in the future)
  Future<List<MeetingsModel>> getUpcomingMeetings() async {
    final now = DateTime.now();
    
    if (AppConfig.isCloudSyncEnabled) {
      try {
        final query = FirebaseFirestore.instance
            .collection(collectionName)
            .where('startTime', isGreaterThanOrEqualTo: now)
            .orderBy('startTime');
            
        final snapshot = await query.get();
        return snapshot.docs.map((doc) => fromDocument(doc)).toList();
      } catch (e) {
        debugPrint('Error fetching upcoming meetings from cloud: $e');
      }
    }

    final meetings = await getAll();
    return meetings
        .where((meeting) => meeting.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  /// Gets past meetings (meetings with end time in the past)
  Future<List<MeetingsModel>> getPastMeetings() async {
    final now = DateTime.now();
    
    if (AppConfig.isCloudSyncEnabled) {
      try {
        final query = FirebaseFirestore.instance
            .collection(collectionName)
            .where('endTime', isLessThan: now)
            .orderBy('endTime', descending: true);
            
        final snapshot = await query.get();
        return snapshot.docs.map((doc) => fromDocument(doc)).toList();
      } catch (e) {
        debugPrint('Error fetching past meetings from cloud: $e');
      }
    }

    final meetings = await getAll();
    return meetings
        .where((meeting) => meeting.endTime.isBefore(now))
        .toList()
      ..sort((a, b) => b.endTime.compareTo(a.endTime));
  }
}
