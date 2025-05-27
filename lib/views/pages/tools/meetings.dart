import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/meetings_model.dart';
import 'package:planora/utils/dialogs.dart';
import 'package:planora/views/pages/tools/meetings/add_meeting.dart';
import 'package:planora/views/pages/tools/meetings/update_meeting.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
  List<MeetingsModel> meetings = [];
  Set<int> selectedMeetingIndices = {};
  bool areMeetingsLoading = false;

  @override
  void initState() {
    areMeetingsLoading = true;
    HiveEvents.getMeetingsFromHive().then((value) {
      setState(() {
        meetings = value;
        areMeetingsLoading = false;
      });
    });
    super.initState();
  }

  Future<void> addMeetingToHive(MeetingsModel meeting) async {
    await HiveEvents.addMeetingToHive(meeting);
    HiveEvents.getMeetingsFromHive().then((value) {
      setState(() {
        meetings = value;
      });
    });
  }

  Future<void> updateMeetingToHive(
    int selectedMeetingIndex,
    MeetingsModel meeting,
  ) async {
    await HiveEvents.updateMeetingToHive(selectedMeetingIndex, meeting);
    HiveEvents.getMeetingsFromHive().then((value) {
      setState(() {
        meetings = value;
      });
    });
  }

  Future<void> deleteMeetings() async {
    if (selectedMeetingIndices.isNotEmpty) {
      await HiveEvents.deleteMeetingsFromHive(selectedMeetingIndices);
      final sortedIndices =
          selectedMeetingIndices.toList()..sort((a, b) => b.compareTo(a));
      for (var index in sortedIndices) {
        meetings.removeAt(index);
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${selectedMeetingIndices.length} ${selectedMeetingIndices.length > 1 ? 'meetings' : 'meeting'} deleted',
          ),
        ),
      );
      selectedMeetingIndices.clear();
      setState(() {});
    }
  }

  Future<void> startMeeting(int index) async {
    final meeting = meetings[index];
    String meetingLink = meeting.meetingLink;

    // Check if it's a known meeting platform
    if (meetingLink.contains('zoom.us')) {
      final zoomAppUrl = meetingLink.replaceFirst('https://', 'zoomus://');
      try {
        if (await canLaunchUrlString(zoomAppUrl)) {
          await launchUrlString(
            zoomAppUrl,
            mode: LaunchMode.externalApplication,
          );
          return; // Successfully launched Zoom app
        }
      } catch (e) {
        // Continue to web fallback
        print('Failed to launch Zoom app: $e');
      }
    }

    // Fallback to web URL
    try {
      await launchUrlString(meetingLink, mode: LaunchMode.platformDefault);
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // If everything fails, show an error to the user
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 100.0,
            content: Text(
              'Failed to launch meeting.',
              // ignore: use_build_context_synchronously
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            // ignore: use_build_context_synchronously
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    }
  }

  Future<void> updateMeeting(int index) async {
    final meeting = meetings[index];
    showDialog(
      context: context,
      builder:
          (context) => UpdateMeeting(
            updateMeetingToHive: updateMeetingToHive,
            selectedMeetingIndex: index,
            meeting: meeting,
          ),
    );
  }

  Future<void> copyMeetingLink(int index) async {
    final meeting = meetings[index];
    await Clipboard.setData(ClipboardData(text: meeting.meetingLink));
    // Show snackbar
    ScaffoldMessenger.of(
      // ignore: use_build_context_synchronously
      context,
    ).showSnackBar(SnackBar(content: Text('Meeting link copied to clipboard')));
    setState(() {});
  }

  Future<void> shareMeetingLink(int index) async {
    final meeting = meetings[index];
    await SharePlus.instance.share(ShareParams(text: meeting.meetingLink));
    setState(() {});
  }

  Future<void> deleteMeeting(int index) async {
    HiveEvents.deleteMeetingFromHive(index);
    meetings.removeAt(index);
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meetings"),
        actions: [
          if (selectedMeetingIndices.isNotEmpty) ...[
            IconButton(
              icon: Icon(CupertinoIcons.delete),
              onPressed:
                  () => confirmationDialog(
                    context,
                    deleteMeetings,
                    'Delete Meetings',
                    'Are you sure you want to delete the selected meetings?',
                    'Delete',
                  ),
            ),
          ],
        ],
      ),
      body:
          areMeetingsLoading
              ? const Center(child: CircularProgressIndicator())
              : meetings.isEmpty
              ? const Center(child: Text('No meetings found'))
              : ListView.builder(
                itemCount: meetings.length,
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  top: 16.0,
                ),
                itemBuilder:
                    (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        minTileHeight: 100.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        tileColor: Theme.of(context).colorScheme.primary,
                        title: Text(
                          meetings[index].meetingTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        subtitle: Container(
                          margin: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            meetings[index].meetingLink,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          onPressed: () => updateMeeting(index),
                        ),
                        leading:
                            selectedMeetingIndices.contains(index)
                                ? Checkbox(
                                  shape: CircleBorder(),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  value: selectedMeetingIndices.contains(index),
                                  onChanged:
                                      (value) => setState(() {
                                        if (value == true) {
                                          selectedMeetingIndices.add(index);
                                        } else {
                                          selectedMeetingIndices.remove(index);
                                        }
                                      }),
                                )
                                : null,
                        onLongPress:
                            () => setState(() {
                              if (selectedMeetingIndices.contains(index)) {
                                selectedMeetingIndices.remove(index);
                              } else {
                                selectedMeetingIndices.add(index);
                              }
                            }),
                        horizontalTitleGap: 16.0,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        onTap: () async {
                          if (kIsWeb) {
                            return showDialog<void>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: Text(meetings[index].meetingTitle),
                                    content: Text(meetings[index].meetingLink),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          'Start or Join Meeting',
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        onPressed: () => startMeeting(index),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Copy or Share Meeting Link',
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        onPressed:
                                            () => shareMeetingLink(index),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Update Meeting Details',
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        onPressed: () => updateMeeting(index),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Delete Meeting',
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                        onPressed:
                                            () => confirmationDialog(
                                              context,
                                              () => deleteMeeting(index),
                                              'Delete Meeting',
                                              'Are you sure you want to delete the selected meeting?',
                                              'Delete',
                                            ),
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                            );
                          } else {
                            return Platform.isIOS
                                ? actionSheet(
                                  context,
                                  actions: [
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        'Start or Join Meeting',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed: () => startMeeting(index),
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        'Copy or Share Meeting Link',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed: () => shareMeetingLink(index),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () => updateMeeting(index),
                                      child: Text(
                                        'Update Meeting Details',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        'Delete Meeting',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed:
                                          () => confirmationDialog(
                                            context,
                                            () => deleteMeeting(index),
                                            'Delete Meeting',
                                            'Are you sure you want to delete the selected meeting?',
                                            'Delete',
                                          ),
                                    ),
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      child: Text('Cancel'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                  title: meetings[index].meetingTitle,
                                  subtitle: meetings[index].meetingLink,
                                )
                                : actionSheet(
                                  context,
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'Start or Join Meeting',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed: () => startMeeting(index),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Copy or Share Meeting Link',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed: () => shareMeetingLink(index),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Update Meeting Details',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed: () => updateMeeting(index),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Delete Meeting',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                        ),
                                      ),
                                      onPressed:
                                          () => confirmationDialog(
                                            context,
                                            () => deleteMeeting(index),
                                            'Delete Meeting',
                                            'Are you sure you want to delete the selected meeting?',
                                            'Delete',
                                          ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                  title: meetings[index].meetingTitle,
                                  subtitle: meetings[index].meetingLink,
                                );
                          }
                        },
                      ),
                    ),
              ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        overlayOpacity: 0.4,
        spacing: 12,
        spaceBetweenChildren: 12,
        childrenButtonSize: const Size(56, 56),
        shape: const CircleBorder(),
        children: [
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.video_call),
            label: 'Add Meeting Link',
            labelShadow: List.empty(),
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AddMeeting(addMeetingToHive: addMeetingToHive),
              );
            },
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.schedule),
            label: 'Schedule for later',
            labelShadow: List.empty(),
            onTap: () {},
          ),
          SpeedDialChild(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            child: const Icon(Icons.north_west_sharp),
            label: 'Schedule Now',
            labelShadow: List.empty(),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
