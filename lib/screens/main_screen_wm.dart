import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:test_task/data/export.dart';
import 'package:test_task/di.dart';
import 'package:test_task/helpers/date_time_extension.dart';
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
  ValueNotifier<Set<DateTime>> datesContainingTasks = ValueNotifier({});

  late PageController dayPageScrollController;
  late ScrollController daySelectionScrollController;

  DateTime get now => DateTime.now();
  DateTime get weekBeforeNow => now.subtract(const Duration(days: 7));
  DateTime get weekAfterNow => now.add(const Duration(days: 7));

  MainScreenWM(MainScreenModel model) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    dayPageScrollController = PageController(initialPage: 7);
    daySelectionScrollController =
        ScrollController(initialScrollOffset: 7 * 50);
    pullDayTasks(now);
  }

  @override
  void dispose() {
    super.dispose();
    dayPageScrollController.dispose();
    daySelectionScrollController.dispose();
  }

  void pullDayTasks(DateTime day) {
    tasksState.loading(tasksState.value?.data);
    final tasks = model.getTasksByDay(day);
    final newState = DayTasksState(day, tasks);

    tasksState.content(newState);
    datesContainingTasks.value = getDatesContainingTasks();
  }

  Future<void> createNewTask({
    required String content,
    required DateTime targetDate,
  }) async {
    final task = Task.create(content: content, targetDate: targetDate);
    tasksState.loading(tasksState.value?.data);
    await model.saveTask(task);
    final tasks = model.getTasksByDay(task.targetDate);
    tasksState.content(DayTasksState(task.targetDate, tasks));
    datesContainingTasks.value = getDatesContainingTasks();
  }

  Future<void> editTask(Task task) async {
    tasksState.loading(tasksState.value?.data);
    await model.saveTask(task);
    final tasks = model.getTasksByDay(task.targetDate);
    tasksState.content(DayTasksState(task.targetDate, tasks));
  }

  Future<void> deleteTask(Task task) async {
    tasksState.loading(tasksState.value?.data);
    await model.deleteTask(task);
    final tasks = model.getTasksByDay(task.targetDate);
    tasksState.content(DayTasksState(task.targetDate, tasks));
    datesContainingTasks.value = getDatesContainingTasks();
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

  Set<DateTime> getDatesContainingTasks({
    DateTime? begin,
    DateTime? end,
  }) {
    final beginDate = begin ?? weekBeforeNow;
    final endDate = end ?? weekAfterNow;

    final all = model.getAllTasks();
    final filtered = all
        .where((e) {
          return e.targetDate.isAfter(beginDate) &&
              e.targetDate.isBefore(endDate);
        })
        .map((e) => e.targetDate.onlyDate)
        .toSet();
    return filtered;
  }

  void selectDay(DateTime day) {
    final dayPosition =
        weekBeforeNow.onlyDate.difference(day.onlyDate).inDays.abs();
    daySelectionScrollController.animateTo(
      dayPosition * 51,
      curve: Curves.linearToEaseOut,
      duration: const Duration(milliseconds: 300),
    );
    pullDayTasks(day);
  }

  void onPageChanged(int page) {
    final selectedDate = tasksState.value?.data?.day;
    final dayPosition =
        selectedDate!.onlyDate.difference(weekBeforeNow).inDays.abs();
    final diff = page - dayPosition;
    final targetDate = diff > 0
        ? selectedDate.add(const Duration(days: 1))
        : selectedDate.subtract(const Duration(days: 1));

    selectDay(targetDate);
  }
}

MainScreenWM mainScreenWmFactory(BuildContext _) =>
    MainScreenWM(MainScreenModel(
      Injector.of(_).taskService,
    ));
