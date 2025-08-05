import 'package:flutter/material.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/utils/font_weights.dart';

class UpdateMeeting extends StatefulWidget {
  const UpdateMeeting({
    super.key,
    required this.updateMeetingInHive,
    required this.meeting,
    required this.selectedMeetingIndex,
  });

  final Future<void> Function(MeetingsModel meeting) updateMeetingInHive;
  final MeetingsModel meeting;
  final int selectedMeetingIndex;

  @override
  State<UpdateMeeting> createState() => _UpdateMeetingState();
}

class _UpdateMeetingState extends State<UpdateMeeting> {
  final TextEditingController meetingTitleController = TextEditingController();
  final TextEditingController meetingLinkController = TextEditingController();

  @override
  void initState() {
    meetingTitleController.text = widget.meeting.meetingTitle;
    meetingLinkController.text = widget.meeting.meetingLink;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            Row(
              children: [
                Text(
                  'Update Meeting',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            TextField(
              controller: meetingTitleController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeights.regular,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Meeting Title',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeights.regular,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            TextField(
              controller: meetingLinkController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.none,
              autocorrect: false,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeights.regular,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Meeting Link',
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeights.regular,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  final meeting = MeetingsModel(
                    id: widget.meeting.id,
                    meetingTitle: meetingTitleController.text,
                    meetingLink: meetingLinkController.text,
                    startTime: widget.meeting.startTime,
                    endTime: widget.meeting.endTime,
                  );
                  widget.updateMeetingInHive(meeting);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}