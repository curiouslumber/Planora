import 'dart:io';
import 'dart:typed_data';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/people_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/firebase/firebase_ai_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/services/firebase/firebase_storage_service.dart';
import 'package:planora/services/pinecone/pinecone_vector_service.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:uuid/uuid.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key, this.user});

  final UserModel? user;

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  Set<PeopleModel> addedPeople = {};

  void addPeople(PeopleModel people) {
    setState(() {
      addedPeople.add(people);
    });
  }

  Future<void> addEvent(EventModel event) async {
    await FirebaseFirestoreService().createEventDocument(event: event);
    await HiveEvents.addEventToHive(event);
  }

  void generateImageTileAsync(
    EventModel event,
    String eventName,
    String eventDescription,
  ) async {
    String imagePrompt = eventName + eventDescription;
    String? semanticSearchResponse = await PineconeVectorService.semanticSearch(
      imagePrompt,
    );

    // If semantic search response is not null, update the event
    if (semanticSearchResponse != null) {
      EventModel updatedEvent = event.copyWith(
        eventTileImage: semanticSearchResponse,
      );

      await HiveEvents.updateEventInHive(updatedEvent);
      await FirebaseFirestoreService().updateEventDocument(
        event.id,
        updatedEvent,
      );
      if (mounted) {
        setState(() {});
      }
      return;
    }

    // If semantic search response is null, generate the image
    Uint8List? imageBytes = await FirebaseAiService().generateImage(
      imagePrompt,
    );
    if (imageBytes != null) {
      String? gsUrl = await FirebaseStorageService().uploadImageUsingBytes(
        '${eventName.replaceAll(' ', '_')}.png',
        'event_images',
        imageBytes,
      );
      if (gsUrl != null) {
        EventModel updatedEvent = event.copyWith(eventTileImage: gsUrl);
        await HiveEvents.updateEventInHive(updatedEvent);
        await FirebaseFirestoreService().updateEventDocument(
          event.id,
          updatedEvent,
        );
        // Create the new index in pinecone
        await PineconeVectorService.upsertNewIndex(imagePrompt, gsUrl);
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create New Event")),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: kFloatingActionButtonMargin * 6,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24.0,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Event Name',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextField(
                          controller: _eventNameController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
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
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Event Description',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextField(
                          controller: _eventDescriptionController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: '',
                            hintStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeights.regular,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
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
                      ],
                    ),
                    Row(
                      spacing: 16.0,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                dateFormat: DateFormat('dd/MM/yyyy'),
                                firstDate: DateTime.now(),
                                value: startDate,
                                onChanged: (value) {
                                  setState(() {
                                    startDate = value;
                                  });
                                },
                                mode: DateTimeFieldPickerMode.date,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'End Date (Optional)',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                value: endDate,
                                onChanged: (value) {
                                  setState(() {
                                    endDate = value;
                                  });
                                },
                                dateFormat: DateFormat('dd/MM/yyyy'),
                                mode: DateTimeFieldPickerMode.date,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 16.0,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'Start Time',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                value: startTime,
                                onChanged: (value) {
                                  setState(() {
                                    startTime = value;
                                  });
                                },
                                mode: DateTimeFieldPickerMode.time,
                                initialPickerDateTime: DateTime.now(),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Text(
                                'End Time',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              DateTimeField(
                                value: endTime,
                                onChanged: (value) {
                                  setState(() {
                                    endTime = value;
                                  });
                                },
                                mode: DateTimeFieldPickerMode.time,
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeights.regular,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeights.regular,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withAlpha(100),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide: BorderSide(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (Platform.isLinux)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'People',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            for (var person in addedPeople)
                              Chip(label: Text(person.name), onDeleted: () {}),
                            if (addedPeople.length < 5)
                              Chip(
                                avatar: Icon(Icons.add),
                                label: Text("Add People"),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (Platform.isLinux)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Meeting Details',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 8.0,
                            children: [
                              Chip(label: Text("Create new")),
                              Text("or"),
                              Chip(label: Text("Add Existing")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        onPressed: () async {

          if (_eventNameController.text.isEmpty) {
            return;
          }

          EventModel event = EventModel(
            id: Uuid().v4(),
            eventTileImage: '',
            name: _eventNameController.text,
            description: _eventDescriptionController.text,
            startDate: startDate!.toString(),
            endDate: endDate?.toString(),
            startTime: startTime!.toString(),
            endTime:
                endTime != null ? endTime!.toString() : startTime!.toString(),
            eventStatus: Constants.eventStatus[0],
            people: addedPeople.map((e) => e.id).toList(),
          );

          // Add event to Hive
          await addEvent(event);

          // Asynchronously function to generate event image tile
          generateImageTileAsync(
            event,
            _eventNameController.text,
            _eventDescriptionController.text,
          );


          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        label: Text(
          "Create",
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeights.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

extension on EventModel {
  EventModel copyWith({required String eventTileImage}) {
    return EventModel(
      id: id,
      eventTileImage: eventTileImage,
      eventTileImageId: eventTileImageId,
      name: name,
      description: description,
      startDate: startDate,
      endDate: endDate,
      startTime: startTime,
      endTime: endTime,
      people: people,
      meeting: meeting,
      eventStatus: eventStatus,
    );
  }
}
