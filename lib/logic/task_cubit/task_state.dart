import 'package:equatable/equatable.dart';
import '../../data/models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  const TaskLoaded(this.tasks);

  @override
  List<Object> get props => [tasks];

  List<TaskModel> get achievedTasks =>
      tasks.where((t) => t.isCompleted).toList();

  /// High priority tasks that are NOT yet completed — shown in the home card
  List<TaskModel> get highPriorityTasks =>
      tasks.where((t) => t.isHighPriority && !t.isCompleted).toList();

  /// All non-completed tasks regardless of priority — shown in "My Tasks" list
  List<TaskModel> get myTasks =>
      tasks.where((t) => !t.isCompleted).toList();

  /// Only completed tasks — shown in Completed tab
  List<TaskModel> get completedTasks =>
      tasks.where((t) => t.isCompleted).toList();
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object> get props => [message];
}
