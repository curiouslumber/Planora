import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:intl/intl.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/constants.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.todo});

  final TodoModel todo;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late TodoModel _todo;

  @override
  void initState() {
    super.initState();
    _todo = widget.todo;
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _todo.todoStatus == Constants.todoStatus[1];
    return Scaffold(
      appBar: AppBar(
        title: Text(_todo.todo),
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
              todo: _todo.todo,
              todoStatus: _todo.todoStatus == Constants.todoStatus[1] ? Constants.todoStatus[0] : Constants.todoStatus[1],
              updatedAt: DateTime.now(),
              createdAt: _todo.createdAt,
              priority: _todo.priority,
              doesRepeat: _todo.doesRepeat,
              repeatOption: _todo.repeatOption,
              selectedDays: _todo.selectedDays,
            );
            HiveEvents.updateTodoInHive(_todo);
            FirebaseFirestoreService().updateTodoDocument(_todo.id, _todo);
          });
        },
        label: Text(isDone ? 'Mark as Undone' : 'Mark as Done', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.flag),
            title: Text('Priority', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            trailing: Chip(
              label: Text(_todo.priority),
              backgroundColor: _todo.priority == Constants.priority[2]
                  ? Colors.redAccent
                  : _todo.priority == Constants.priority[1]
                      ? Colors.orangeAccent
                      : _todo.priority == Constants.priority[0]
                          ? Colors.green
                          : Colors.grey,
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.repeat),
            title: Text('Repeat', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(_todo.repeatOption == Constants.repeatOptions[0]
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
            subtitle: Text(_todo.todoStatus == Constants.todoStatus[1] ? Constants.todoStatus[1] : Constants.todoStatus[0]),
          ),
        ],
      ),
    );
  }
}