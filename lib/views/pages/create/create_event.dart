import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/event_model.dart';
import 'package:planora/models/people_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/models/user_model.dart';
import 'package:planora/services/common/event_task_image_service.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:uuid/uuid.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key, this.user});

  final UserModel? user;

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  Set<PeopleModel> addedPeople = {};
  String taskOrEvent = "event";

  void addPeople(PeopleModel people) {
    setState(() {
      addedPeople.add(people);
    });
  }

  Future<void> addEvent(EventModel event) async {
    await FirebaseFirestoreService().createEventDocument(event: event);
    await HiveEvents.addEventToHive(event);
    EventTaskImageService.handleImageTileForEvent(event);
  }

  Future<void> addTask(TaskModel task) async {
    await FirebaseFirestoreService().createTaskDocument(task: task);
    await HiveEvents.addTaskToHive(task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
       body: 
       Column(
        children: [
       Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8.0,
                      children: [
                        Text(
                          'Title',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextField(
                          controller: _nameController,
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
                          taskOrEvent == "event"
                              ? 'Description' : 'Notes',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        TextField(
                          controller: _descriptionController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: true,
                          maxLines: null,
                          minLines: taskOrEvent == "task" ? 8 : 3,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeights.regular,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          keyboardType: TextInputType.multiline,
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
                              vertical: 24.0,
                              horizontal: 16.0,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      child:
                          taskOrEvent == "event"
                              ? Column(
                                spacing: 24.0,
                                children: [
                                  Row(
                                    spacing: 16.0,
                                    children: [
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8.0,
                                          children: [
                                            Text(
                                              'Start Date',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                            DateTimeField(
                                              dateFormat: DateFormat(
                                                'dd/MM/yyyy',
                                              ),
                                              firstDate: DateTime.now(),
                                              value: startDate,
                                              onChanged: (value) {
                                                setState(() {
                                                  startDate = value;
                                                });
                                              },
                                              mode:
                                                  DateTimeFieldPickerMode.date,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeights.regular,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(100),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 24.0,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        32.0,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8.0,
                                          children: [
                                            Text(
                                              'End Date (Optional)',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                            DateTimeField(
                                              value: endDate,
                                              onChanged: (value) {
                                                setState(() {
                                                  endDate = value;
                                                });
                                              },
                                              dateFormat: DateFormat(
                                                'dd/MM/yyyy',
                                              ),
                                              mode:
                                                  DateTimeFieldPickerMode.date,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeights.regular,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(100),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 24.0,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        32.0,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8.0,
                                          children: [
                                            Text(
                                              'Start Time',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                            DateTimeField(
                                              value: startTime,
                                              onChanged: (value) {
                                                setState(() {
                                                  startTime = value;
                                                });
                                              },
                                              mode:
                                                  DateTimeFieldPickerMode.time,
                                              initialPickerDateTime:
                                                  DateTime.now(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeights.regular,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(100),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 24.0,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        32.0,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 8.0,
                                          children: [
                                            Text(
                                              'End Time',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                            ),
                                            DateTimeField(
                                              value: endTime,
                                              onChanged: (value) {
                                                setState(() {
                                                  endTime = value;
                                                });
                                              },
                                              mode:
                                                  DateTimeFieldPickerMode.time,
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeights.regular,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.onSurface,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: '',
                                                hintStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight:
                                                      FontWeights.regular,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withAlpha(100),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 24.0,
                                                    ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        32.0,
                                                      ),
                                                  borderSide: BorderSide(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              : Container(),
                    ),
                    ],
                  ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        onPressed: () async {
          if (_nameController.text.isEmpty) {
            return;
          }

          if (taskOrEvent == "event") {
            EventModel event = EventModel(
              id: Uuid().v4(),
              userId: widget.user!.uid,
              name: _nameController.text,
              description: _descriptionController.text,
              eventTileImage: '',
              eventTileImageLocalUrl: '',
              isImageProcessing: false,
              startDate: startDate!.toString(),
              endDate: endDate?.toString(),
              startTime: startTime!.toString(),
              endTime:
                  endTime != null ? endTime!.toString() : startTime!.toString(),
              eventStatus: Constants.eventStatus[0],
              people: addedPeople.map((e) => e.id).toList(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            addEvent(event);
          } else {
            TaskModel task = TaskModel(
              id: Uuid().v4(),
              name: _nameController.text,
              notes: _descriptionController.text,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              taskStatus: Constants.taskStatus[0],
            );

            addTask(task);
          }

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