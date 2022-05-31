import 'package:feature_flutter/feature_flutter.dart';
import 'package:feature_source_firebase/feature_source_firebase.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simpledo/data/dto/task_hive_dto.dart';
import 'package:simpledo/data/hive_types.dart';
import 'package:simpledo/services/task_service.dart';

// ignore: must_be_immutable
class Injector extends InheritedWidget {
  TaskService get taskService => _taskService;

  late TaskService _taskService;

  Injector({
    required Widget child,
    Key? key,
  }) : super(
          key: key,
          child: FeaturesProvider(
            manager: Features.I,
            child: child,
          ),
        );

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
