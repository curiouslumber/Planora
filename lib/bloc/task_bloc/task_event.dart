part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent(this.taskId);

  final String taskId;

  @override
  List<Object> get props => [taskId];
}

// Events
class LoadTask extends TaskEvent {
  const LoadTask(super.taskId);
}

class UpdateTask extends TaskEvent {
  final String? name;
  final String? notes;
  final String? taskStatus;

  const UpdateTask({
    required String taskId,
    this.name,
    this.notes,
    this.taskStatus,
  }) : super(taskId);
}
