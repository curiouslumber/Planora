import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:planora/databases/hive_events.dart';
import 'package:planora/models/task_model.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final FirebaseFirestore firestore;
  Timer? _debounce;
  TaskModel? _currentTask;

  TaskBloc({required this.firestore}) : super(TaskInitial()) {
    on<LoadTask>(_onLoadTask);
    on<UpdateTask>(_onUpdateTask);
  }

  Future<void> _onLoadTask(LoadTask event, Emitter<TaskState> emit) async {
    try {
      final tasks = await HiveEvents.getTasksFromHive();
      if (tasks.isNotEmpty) {
        _currentTask = tasks.firstWhere((task) => task.id == event.taskId);
        emit(TaskLoaded(_currentTask!));
      } else {
        emit(TaskError('Task not found.'));
      }
    } catch (e) {
      emit(TaskError('Error loading task.'));
    }
  }

  void _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) {
    if (_currentTask == null) return;
    _currentTask = _currentTask!.copyWith(
      name: event.name ?? _currentTask!.name,
      notes: event.notes ?? _currentTask!.notes,
      doesRepeat: _currentTask!.doesRepeat,
      repeatOption: _currentTask!.repeatOption,
      selectedDays: _currentTask!.selectedDays,
      taskStatus: event.taskStatus ?? _currentTask!.taskStatus,
      attachments: _currentTask!.attachments,
      createdAt: _currentTask!.createdAt,
      updatedAt: DateTime.now(),
      priority: _currentTask!.priority,
    );
    emit(TaskLoaded(_currentTask!));

    // Debounce save
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      // Save to Hive
      await HiveEvents.updateTaskInHive(_currentTask!);
      // Sync to Firestore
      await firestore
          .collection('tasks')
          .doc(_currentTask!.id)
          .set(_currentTask!.toFirestore());
      // Optionally: handle errors, retries, dirty flags, etc.
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
