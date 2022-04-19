import 'package:elementary/elementary.dart';
import 'package:simpledo/data/export.dart';
import 'package:simpledo/services/task_service.dart';

class MainScreenModel extends ElementaryModel {
  final TaskService _taskService;

  MainScreenModel(this._taskService);

  List<Task> getTasksByDay(DateTime day) => _taskService.getTasksByDay(day);

  List<Task> getAllTasks() => _taskService.getAllTasks();

  Future<void> saveTask(Task task) => _taskService.saveTask(task);

  Future<void> saveAllTasks(List<Task> tasks) =>
      _taskService.saveAllTasks(tasks);

  Future<void> deleteTask(Task task) => _taskService.deleteTask(task);
}
