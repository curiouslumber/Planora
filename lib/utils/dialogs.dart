import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        confirmText,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
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
                      child: Text(
                        'Cancel',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        confirmText,
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
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
  if (kIsWeb) {
    await showDialog<void>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: title != null ? Text(title) : null,
            content: subtitle != null ? Text(subtitle) : null,
            actions: actions,
          ),
    );
  } else if (Platform.isIOS) {
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
      builder:
          (context) => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ...List.generate(
                actions.length,
                (index) =>
                    index > 0
                        ? Column(
                          children: [
                            const Divider(
                              height: 1,
                              indent: 16.0,
                              endIndent: 16.0,
                            ),
                            actions[index],
                          ],
                        )
                        : actions[index],
              ),
            ],
          ),
    );
  }
}