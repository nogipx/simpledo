import 'package:elementary/elementary.dart';
import 'package:test_task/data/export.dart';
import 'package:test_task/services/task_service.dart';

class MainScreenModel extends ElementaryModel {
  final TaskService _taskService;

  MainScreenModel(this._taskService);

  List<Task> getTasksByDay(DateTime day) => _taskService.getTasksByDay(day);

  Future<void> saveTask(Task task) => _taskService.saveTask(task);
  Future<void> saveAllTasks(List<Task> tasks) =>
      _taskService.saveAllTasks(tasks);

  Future<void> deleteTask(Task task) => _taskService.deleteTask(task);
}
