import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/services/firebase/firebase_firestore_service.dart';
import 'package:planora/utils/constants.dart';
import 'package:planora/utils/font_weights.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key, required this.todo});

  final TodoModel todo;

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  late String _priority;
  late final TextEditingController _nameController;
  final List<String> recurringEventDays = ["M", "Tu", "W", "Th", "F", "Sa", "Su"];
  bool isRecurring = false;
  String repeatOption = "never";
  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();
    // Initialize form fields with existing todo data
    _nameController = TextEditingController(text: widget.todo.todo);
    _priority = widget.todo.priority;
    // Initialize other fields if they exist in your TodoModel
    // For example: repeatOption = widget.todo.repeatOption;
    // selectedDays = List.from(widget.todo.selectedDays);
  }

  Future<void> updateTodo() async {
    final updatedTodo = widget.todo.copyWith(
      todo: _nameController.text,
      priority: _priority,
      updatedAt: DateTime.now(),
      doesRepeat: widget.todo.doesRepeat,
      repeatOption: widget.todo.repeatOption,
      selectedDays: widget.todo.selectedDays,
      todoStatus: widget.todo.todoStatus,
      createdAt: widget.todo.createdAt,
    );

    await HiveEvents.updateTodoInHive(updatedTodo);
    try {
      await FirebaseFirestoreService().updateTodoDocument(updatedTodo.id, updatedTodo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update todo in cloud')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8.0,
              children: [
                Text(
                  'Todo',
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
                  decoration: InputDecoration(
                    hintText: 'Enter todo',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeights.regular,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
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
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeights.regular,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                DropdownButton<String>(
                  value: _priority,
                  items: Constants.priority.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _priority = value;
                      });
                    }
                  },
                ),
              ],
            ),
            // Add other form fields here as needed
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text('Save Changes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () async {
          if (_nameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a todo')),
            );
            return;
          }

          await updateTodo();
          if (mounted) {
            Navigator.pop(context, true); // Return true to indicate success
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
