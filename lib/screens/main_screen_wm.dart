import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:simpledo/data/export.dart';
import 'package:simpledo/di.dart';
import 'package:simpledo/helpers/date_time_extension.dart';
import 'package:simpledo/helpers/keyboard_helper.dart';
import 'package:simpledo/screens/main_screel_model.dart';
import 'package:simpledo/screens/main_screen.dart';

class DayTasksState {
  final DateTime day;
  final List<Task> _tasks;
  List<Task> get tasks => List.unmodifiable(_tasks);

  DayTasksState(this.day, this._tasks);
}

class MainScreenWM extends WidgetModel<MainScreen, MainScreenModel>
    with WidgetsBindingObserver, KeyboardHelperMixin {
  final int datesRadius;
  late final DateTime startDay =
      now.subtract(Duration(days: datesRadius)).onlyDate;
  late final DateTime endDay =
      now.add(Duration(days: datesRadius + 1)).onlyDate;
  late final FocusNode taskCreationFocusNode = FocusNode();
  late final PageController dayPageScrollController;
  late final ScrollController daySelectionScrollController;

  final EntityStateNotifier<DayTasksState> tasksState = EntityStateNotifier();
  ValueNotifier<Set<DateTime>> datesContainingActiveTasks = ValueNotifier({});

  DateTime get now => DateTime.now();

  MainScreenWM({
    required MainScreenModel model,
    required this.datesRadius,
  }) : super(model);

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    dayPageScrollController = PageController(initialPage: 7);
    daySelectionScrollController =
        ScrollController(initialScrollOffset: 7 * 50);
    _pullDayTasks(now);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    dayPageScrollController.dispose();
    daySelectionScrollController.dispose();
    taskCreationFocusNode.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void onKeyboardVisibilityChange(bool isKeyboardHidden) {
    if (isKeyboardHidden) {
      taskCreationFocusNode.unfocus();
    }
  }

  void nextDay() {
    final currentDay = tasksState.value?.data?.day ?? now;
    final targetDay = currentDay.add(const Duration(days: 1));
    if (!targetDay.isAfter(endDay)) {
      selectDay(targetDay);
    }
  }

  void previousDay() {
    final currentDay = tasksState.value?.data?.day ?? now;
    final targetDay = currentDay.subtract(const Duration(days: 1));
    if (!targetDay.isBefore(startDay)) {
      selectDay(targetDay);
    }
  }

  bool onScrollTaskDays(DragEndDetails info) {
    final velocity = info.primaryVelocity ?? 0;
    if (velocity > 300) {
      previousDay();
    } else if (velocity < -300) {
      nextDay();
    }
    return true;
  }

  void dismissKeyboard() {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  void focusToCreateTask() => taskCreationFocusNode.requestFocus();

  Future<void> createNewTask({
    required String content,
    required DateTime targetDate,
  }) async {
    final task = Task.create(content: content, targetDate: targetDate);
    tasksState.loading(tasksState.value?.data);
    await model.saveTask(task);
    final tasks = model.getTasksByDay(task.targetDate);
    tasksState.content(DayTasksState(task.targetDate, tasks));
    datesContainingActiveTasks.value = _getDatesContainingActiveTasks();
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
    datesContainingActiveTasks.value = _getDatesContainingActiveTasks();
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

  void selectDay(DateTime day) {
    _pullDayTasks(day);
    taskCreationFocusNode.unfocus();
  }

  void onPageChanged(int page) {
    final selectedDate = tasksState.value?.data?.day;
    final dayPosition =
        selectedDate!.onlyDate.difference(startDay).inDays.abs();
    final diff = page - dayPosition;
    final targetDate = diff > 0
        ? selectedDate.add(const Duration(days: 1))
        : selectedDate.subtract(const Duration(days: 1));

    selectDay(targetDate);
  }

  Set<DateTime> _getDatesContainingActiveTasks({
    DateTime? begin,
    DateTime? end,
  }) {
    final beginDate = begin ?? startDay;
    final endDate = end ?? endDay;

    final all = model.getAllTasks();
    final filtered = all
        .where((e) {
          return e.targetDate.isAfter(beginDate) &&
              e.targetDate.isBefore(endDate) &&
              !e.isCompleted;
        })
        .map((e) => e.targetDate.onlyDate)
        .toSet();
    return filtered;
  }

  void _pullDayTasks(DateTime day) {
    tasksState.loading(tasksState.value?.data);
    final tasks = model.getTasksByDay(day);
    final newState = DayTasksState(day, tasks);

    tasksState.content(newState);
    datesContainingActiveTasks.value = _getDatesContainingActiveTasks();
  }
}

MainScreenWM mainScreenWmFactory(
  BuildContext _, {
  int datesRadius = 2,
}) =>
    MainScreenWM(
      datesRadius: datesRadius,
      model: MainScreenModel(
        Injector.of(_).taskService,
      ),
    );
