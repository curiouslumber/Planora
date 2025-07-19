import 'package:flutter/material.dart';

class CommonSnackbar {
  static void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    ));
  }
}