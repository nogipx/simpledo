import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task/data/dto/task_hive_dto.dart';
import 'package:test_task/data/export.dart';
import 'package:test_task/helpers/date_time_extension.dart';

class TaskService {
  final Box<TaskHiveDto> _taskBox;

  TaskService(this._taskBox);

  List<Task> getAllTasks() {
    final tasks = _taskBox.values.map((e) => Task.fromDto(e)).toList();
    return tasks;
  }

  Task? getTaskById(String id) {
    final dto = _taskBox.get(id);
    final result = dto != null ? Task.fromDto(dto) : null;
    return result;
  }

  List<Task> getTasksByDay(DateTime day) {
    final tasksByDay = _taskBox.values
        .where((e) => e.creationTime.isSameDay(day))
        .map((e) => Task.fromDto(e))
        .toList();
    return tasksByDay;
  }

  Future<void> saveTask(Task task) async =>
      _taskBox.put(task.id, TaskHiveDto.fromEntity(task));

  Future<void> saveAllTasks(List<Task> tasks) async {
    final mapTasks = Map.fromEntries(tasks.map(
      (e) => MapEntry(
        e.id,
        TaskHiveDto.fromEntity(e),
      ),
    ));
    await _taskBox.putAll(mapTasks);
  }

  Future<void> deleteTask(Task task) async => _taskBox.delete(task.id);
}
