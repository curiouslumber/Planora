import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/task_model.dart';
import 'package:intl/intl.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.todo});

  final TaskModel todo;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TaskModel _todo;

  @override
  void initState() {
    super.initState();
    _todo = widget.todo;
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _todo.taskStatus == 'completed';
    return Scaffold(
      appBar: AppBar(
        title: Text(_todo.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit page
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // TODO: Confirm and delete task
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _todo = _todo.copyWith(
              name: _todo.name,
              notes: _todo.notes,
              doesRepeat: _todo.doesRepeat,
              repeatOption: _todo.repeatOption,
              selectedDays: _todo.selectedDays,
              taskStatus: isDone ? 'ongoing' : 'completed',
              attachments: _todo.attachments,
              createdAt: _todo.createdAt,
              updatedAt: DateTime.now(),
              priority: _todo.priority,
            );
            HiveEvents.updateTaskInHive(_todo);
            FirebaseFirestoreService().updateTaskDocument(_todo.id, _todo);
          });
        },
        icon: Icon(isDone ? Icons.undo : Icons.check, color: Theme.of(context).colorScheme.onPrimary),
        label: Text(isDone ? 'Mark as Undone' : 'Mark as Done', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        backgroundColor: isDone
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_todo.notes.isNotEmpty)
            ListTile(
              leading: Icon(Icons.notes),
              title: Text('Notes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Text(_todo.notes),
            ),
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('Priority', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            trailing: Chip(
              label: Text(_todo.priority),
              backgroundColor: _todo.priority == 'High'
                  ? Colors.redAccent
                  : _todo.priority == 'Medium'
                      ? Colors.orangeAccent
                      : _todo.priority == 'Low'
                          ? Colors.green
                          : Colors.grey,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text('Repeat', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(_todo.repeatOption == 'never'
                ? 'Does not repeat'
                : '${_todo.repeatOption} (${_todo.selectedDays.join(", ")})'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Created', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_todo.createdAt)),
          ),
          ListTile(
            leading: Icon(Icons.update),
            title: Text('Last Updated', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(DateFormat.yMMMd().add_jm().format(_todo.updatedAt)),
          ),
          ListTile(
            leading: Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked),
            title: Text('Status', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(isDone ? 'Completed' : 'Ongoing'),
          ),
          if (_todo.attachments.isNotEmpty)
            ListTile(
              leading: Icon(Icons.attach_file),
              title: Text('Attachments', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              subtitle: Wrap(
                spacing: 8,
                children: _todo.attachments
                    .map((file) => Chip(label: Text(file.path.split('/').last)))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}