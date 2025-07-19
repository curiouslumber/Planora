import 'package:flutter/material.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/task_model.dart';
import 'package:planora/views/pages/create/create_task.dart';
import 'package:planora/views/pages/tools/tasks/task_page.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<TaskModel> tasks = [];
  bool areTasksLoading = false;

  @override
  void initState() {
    super.initState();
    areTasksLoading = true;
    getTasks();
  }

  void getTasks() async {
    var tasksData = await HiveEvents.getTasksFromHive();
    setState(() {
      tasks = tasksData;
      areTasksLoading = false;
    });
  }

  void deleteTask(int index) async {
    await HiveEvents.deleteTaskFromHive(tasks[index]);
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body:
          areTasksLoading
              ? const Center(child: CircularProgressIndicator())
              : tasks.isEmpty
              ? const Center(child: Text('No tasks found'))
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  itemCount: tasks.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16.0,
                    crossAxisSpacing: 16.0,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskPage(task: task),
                          ),
                        );
                      },
                      onLongPress: () async {
                        final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Delete Task'),
                                content: const Text(
                                  'Are you sure you want to delete this task?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: Text('Cancel', 
                                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: Text('Delete', 
                                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (shouldDelete == true) {
                          deleteTask(index);
                        }
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                task.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Status: ${task.taskStatus}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTask()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
