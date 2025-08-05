import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:uuid/uuid.dart';

class AddMeeting extends StatelessWidget {
  AddMeeting({super.key, required this.addMeetingToHive});

  final TextEditingController meetingTitleController = TextEditingController();
  final TextEditingController meetingLinkController = TextEditingController();
  final Future<void> Function(MeetingsModel meeting) addMeetingToHive;

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
                Text('Add Meeting', style: TextStyle(fontSize: 20)),
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
              margin: EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () {
                  final meetingTitle = meetingTitleController.text.trim();
                  final meetingLink = meetingLinkController.text.trim();
                  addMeetingToHive(
                    MeetingsModel(
                      id: Uuid().v4(),
                      meetingTitle: meetingTitle.isNotEmpty ? meetingTitle : DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.now()),
                      meetingLink: meetingLink,
                      startTime: DateTime.now(),
                      endTime: DateTime.now(),
                    ),
                  );
                  
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
