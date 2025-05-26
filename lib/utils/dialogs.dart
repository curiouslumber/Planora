import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> confirmDeleteNotes(
  BuildContext context,
  Future<void> Function() deleteNotes,
) async {
  final confirmed =
      await (Platform.isIOS
          ? showCupertinoDialog<bool>(
            context: context,
            builder:
                (context) => CupertinoAlertDialog(
                  title: Text('Delete Notes'),
                  content: Text(
                    'Are you sure you want to delete the selected notes?',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
          )
          : showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Delete Notes'),
                  content: Text(
                    'Are you sure you want to delete the selected notes?',
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
          ));

  // If confirmed, delete the notes
  if (confirmed == true) {
    await deleteNotes();
  }
}
