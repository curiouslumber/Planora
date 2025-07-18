import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/people_model.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';
import 'package:uuid/uuid.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  Set<PeopleModel> addedPeople = {};
  String taskOrEvent = "task";

  void addPeople(PeopleModel people) {
    setState(() {
      addedPeople.add(people);
    });
  }

  Future<void> addTask(TaskModel task) async {
    await HiveEvents.addTaskToHive(task);
    // If internet is available, add to firestore
    try {
      await FirebaseFirestoreService().createTaskDocument(task: task);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0,
        ),
        child: Column(
          spacing: 16.0,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Text(
                  'Task',
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
                  taskOrEvent == "event" ? 'Description' : 'Notes',
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
                  minLines: 8,
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
          ],
        ),
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

          TaskModel task = TaskModel(
            id: Uuid().v4(),
            name: _nameController.text,
            notes: _descriptionController.text,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            taskStatus: Constants.taskStatus[0],
          );

          addTask(task);

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
