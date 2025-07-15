import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planora/bloc/task_bloc/task_bloc.dart';
import 'package:planora/models/task_model.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  final TaskModel task;

  const TaskPage({super.key, required this.task});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late TextEditingController _nameController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task.name);
    _notesController = TextEditingController(text: widget.task.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().add_jm().format(
      widget.task.createdAt,
    );

    return BlocProvider(
      create:
          (_) =>
              TaskBloc(firestore: FirebaseFirestore.instance)
                ..add(LoadTask(widget.task.id)),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            // Update controllers only if text changed (avoid cursor jump)
            if (_nameController.text != state.task.name) {
              _nameController.text = state.task.name;
              _nameController.selection = TextSelection.fromPosition(
                TextPosition(offset: _nameController.text.length),
              );
            }
            if (_notesController.text != state.task.notes) {
              _notesController.text = state.task.notes;
              _notesController.selection = TextSelection.fromPosition(
                TextPosition(offset: _notesController.text.length),
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: Text("Task"),
                actionsPadding: const EdgeInsets.only(right: 8.0),
                actions: [
                  IconButton(icon: const Icon(Icons.copy), onPressed: () => {}),
                ],
              ),
              body: SafeArea(
                bottom: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title section
                              TextField(
                                controller: _nameController,
                                onChanged:
                                    (value) => context.read<TaskBloc>().add(
                                      UpdateTask(
                                        taskId: state.task.id,
                                        name: value,
                                        taskStatus: state.task.taskStatus,
                                        notes: state.task.notes,
                                      ),
                                    ),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                cursorColor: Theme.of(context).colorScheme.onSurface,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                maxLines: null,
                              ),
                              const SizedBox(height: 16),

                              // Notes section
                              TextField(
                                controller: _notesController,
                                onChanged:
                                    (value) => context.read<TaskBloc>().add(
                                      UpdateTask(
                                        taskId: state.task.id,
                                        name: state.task.name,
                                        taskStatus: state.task.taskStatus,
                                        notes: value,
                                      ),
                                    ),
                                style: Theme.of(context).textTheme.bodyMedium,
                                cursorColor: Theme.of(context).colorScheme.onSurface,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Add details...',
                                  contentPadding: EdgeInsets.zero,
                                ),
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Footer with creation date
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          'Created: $formattedDate',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton:  null,
              // SpeedDial(
              //   icon: Icons.add,
              //   activeIcon: Icons.close,
              //   backgroundColor: Theme.of(context).colorScheme.primary,
              //   foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //   overlayOpacity: 0.4,
              //   spacing: 12,
              //   spaceBetweenChildren: 12,
              //   childrenButtonSize: const Size(56, 56),
              //   shape: const CircleBorder(),
              //   children: [
              //     SpeedDialChild(
              //       shape: const CircleBorder(),
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       child: Icon(Icons.videocam),
              //       label: 'Record Video',
              //       labelBackgroundColor: Colors.transparent,
              //       labelShadow: List.empty(),
              //       onTap: () {},
              //     ),

              //     SpeedDialChild(
              //       shape: const CircleBorder(),
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       child: Icon(Icons.audiotrack),
              //       label: 'Record Audio',
              //       labelBackgroundColor: Colors.transparent,
              //       labelShadow: List.empty(),
              //       onTap: () {},
              //     ),

              //     SpeedDialChild(
              //       shape: const CircleBorder(),
              //       backgroundColor: Theme.of(context).colorScheme.primary,
              //       foregroundColor: Theme.of(context).colorScheme.onPrimary,
              //       child: Icon(Icons.image),
              //       label: 'Add Image',
              //       labelBackgroundColor: Colors.transparent,
              //       labelShadow: List.empty(),
              //       onTap: () {},
              //     ),
              //   ],
              // ),
            );
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
