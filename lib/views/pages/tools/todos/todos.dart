import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/todo_model.dart';
import 'package:planora/views/pages/create/create_todo.dart';
import 'package:intl/intl.dart';
import 'package:planora/views/pages/tools/todos/todo_page.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  List<TodoModel> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    setState(() => _isLoading = true);
    final todos = await HiveEvents.getTodosFromHive();
    setState(() {
      _todos = todos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ongoing = _todos.where((t) => t.todoStatus != 'completed').toList();
    final completed = _todos.where((t) => t.todoStatus == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTodos,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTodo()),
          );
          _fetchTodos();
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _todos.isEmpty
              ? Center(
                  child: Text(
                    'No todos yet.\nTap + to add your first!',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchTodos,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (ongoing.isNotEmpty)
                        ...[
                          Text('Ongoing', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          ...ongoing.map((todo) => _buildTodoTile(todo)),
                          const SizedBox(height: 24),
                        ],
                      if (completed.isNotEmpty)
                        ...[
                          Text('Completed', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          ...completed.map((todo) => _buildTodoTile(todo)),
                        ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildTodoTile(TodoModel todo) {
    final isDone = todo.todoStatus == 'completed';
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ListTile(
        tileColor: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Checkbox(
          value: isDone,
          onChanged: (val) async {
            if (isDone) return;
            final updated = todo.copyWith(
              todoStatus: 'completed',
              updatedAt: DateTime.now(),
              todo: todo.todo,
              doesRepeat: todo.doesRepeat,
              repeatOption: todo.repeatOption,
              selectedDays: todo.selectedDays,
              createdAt: todo.createdAt,
              priority: todo.priority,
            );
            await HiveEvents.updateTodoInHive(updated);
            _fetchTodos();
          },
        ),
        title: Text(
          todo.todo,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(todo.priority),
              backgroundColor: todo.priority == 'High'
                  ? Colors.redAccent
                  : todo.priority == 'Medium'
                      ? Colors.orangeAccent
                      : todo.priority == 'Low'
                          ? Colors.green
                          : Colors.grey,
              labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 8),
            Text(DateFormat.yMMMd().format(todo.createdAt),
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        trailing: isDone
            ? Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoPage(todo: todo)),
          );
        },
      ),
    );
  }
}