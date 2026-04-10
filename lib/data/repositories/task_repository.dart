import 'package:hive_flutter/hive_flutter.dart';

import '../models/task_model.dart';

class TaskRepository {
  static const String _boxName = 'tasksBox';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskModelAdapter());
    }
    await Hive.openBox<TaskModel>(_boxName);
  }

  Box<TaskModel> get _box => Hive.box<TaskModel>(_boxName);

  List<TaskModel> getTasks() {
    if (!Hive.isBoxOpen(_boxName)) return [];
    final items = _box.values.toList();
    if (items.isEmpty) return [];
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> addTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  /// FIX: Use _box.put(id, updatedTask) instead of task.save().
  /// copyWith() creates a NEW object not in a box, so .save() crashes
  /// with "HiveError: This object is currently not in a box."
  Future<void> updateTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  /// Wipes every task — called on logout so the next user starts fresh.
  Future<void> deleteAllTasks() async {
    await _box.clear();
  }
}
