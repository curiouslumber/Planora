import 'package:flutter/material.dart';

class CommonSnackbar {
  static void showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    backgroundColor: color,
    ));
  }
}