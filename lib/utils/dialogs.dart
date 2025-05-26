import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> confirmationDialog(
  BuildContext context,
  Future<void> Function() action,
  String title,
  String content,
  String confirmText,
) async {
  final confirmed =
      await (Platform.isIOS
          ? showCupertinoDialog<bool>(
            context: context,
            builder:
                (context) => CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(
                    content,
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(confirmText),
                    ),
                  ],
                ),
          )
          : showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(title),
                  content: Text(
                    content,
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(confirmText),
                    ),
                  ],
                ),
          ));

  // If confirmed, delete the notes
  if (confirmed == true) {
    await action();
  }
}

Future<void> actionSheet(
  BuildContext context, {
  required List<Widget> actions,
  String? title,
  String? subtitle,
}) async {
  if (Platform.isIOS) {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        message: subtitle != null ? Text(subtitle) : null,
        actions: actions,
      ),
    );
  } else {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ...actions
        ],
      ),
    );
  }
}