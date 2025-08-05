part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoaded extends TaskState {
  final TaskModel task;
  const TaskLoaded(this.task);
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
}
