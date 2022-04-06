import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_task/data/dto/task_hive_dto.dart';
import 'package:test_task/data/hive_types.dart';
import 'package:test_task/services/task_service.dart';

class Injector extends InheritedWidget {
  TaskService get taskService => _taskService;
  late TaskService _taskService;

  Injector({
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static Injector of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Injector>() as Injector;
  }

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskHiveDtoAdapter());

    final taskBox = await Hive.openBox<TaskHiveDto>(HiveTypes.taskName);
    _taskService = TaskService(taskBox);
  }
}
