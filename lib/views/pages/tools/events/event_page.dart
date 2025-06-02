import 'package:flutter/material.dart';
import 'package:planora/models/event_model.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required EventModel event});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event")),
      body: const Center(child: Text("Event Page")),
    );
  }
}
