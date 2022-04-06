import 'package:elementary/elementary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:test_task/data/export.dart';
import 'package:test_task/di.dart';
import 'package:test_task/screens/main_screel_model.dart';
import 'package:test_task/screens/main_screen.dart';

class DayTasksState {
  final DateTime day;
  final List<Task> _tasks;
  List<Task> get tasks => List.unmodifiable(_tasks);

  DayTasksState(this.day, this._tasks);
}

class MainScreenWM extends WidgetModel<MainScreen, MainScreenModel> {
  final EntityStateNotifier<DayTasksState> tasksState = EntityStateNotifier();

  DateTime get now => DateTime.now();
  DateTime get weekBeforeNow => now.subtract(const Duration(days: 7));

  MainScreenWM(MainScreenModel model) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    pullDayTasks(now);
  }

  void pullDayTasks(DateTime day) {
    tasksState.loading(tasksState.value?.data);
    final tasks = model.getTasksByDay(day);
    final newState = DayTasksState(day, tasks);
    tasksState.content(newState);
  }

  Future<void> createNewTask(String content) async {
    final task = Task.create(content: content);
    tasksState.loading(tasksState.value?.data);
    await model.saveTask(task);
    final tasks = model.getTasksByDay(task.creationTime);
    tasksState.content(DayTasksState(task.creationTime, tasks));
  }

  Future<void> editTask(Task task) async {
    tasksState.loading(tasksState.value?.data);
    await model.saveTask(task);
    final tasks = model.getTasksByDay(task.creationTime);
    tasksState.content(DayTasksState(task.creationTime, tasks));
  }

  Future<void> deleteTask(Task task) async {
    tasksState.loading(tasksState.value?.data);
    await model.deleteTask(task);
    final tasks = model.getTasksByDay(task.creationTime);
    tasksState.content(DayTasksState(task.creationTime, tasks));
  }

  Future<void> reorderTasks({
    required int oldPosition,
    required int newPosition,
  }) async {
    final data = tasksState.value!.data!;
    final currentTasks = data._tasks;

    final o = oldPosition;
    final n = newPosition > oldPosition ? newPosition - 1 : newPosition;

    final task = currentTasks.removeAt(o);
    currentTasks.insert(n, task);

    tasksState.content(DayTasksState(data.day, currentTasks));
    await model.saveAllTasks(currentTasks);
  }
}

MainScreenWM mainScreenWmFactory(BuildContext _) =>
    MainScreenWM(MainScreenModel(
      Injector.of(_).taskService,
    ));
