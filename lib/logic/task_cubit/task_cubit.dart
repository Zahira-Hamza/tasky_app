import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository _repository;

  TaskCubit(this._repository) : super(TaskInitial());

  void loadTasks() {
    emit(TaskLoading());
    try {
      final tasks = _repository.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(const TaskLoaded([]));
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _repository.addTask(task);
      loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// updateTask receives the ALREADY-modified copyWith() object.
  /// Repository now uses _box.put(id, task) which correctly overwrites
  /// the specific entry by key — no more "not in a box" crash.
  Future<void> updateTask(TaskModel task) async {
    try {
      await _repository.updateTask(task);
      loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      loadTasks();
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
