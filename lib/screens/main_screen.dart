import 'package:elementary/elementary.dart';
import 'package:feature_flutter/feature_flutter.dart';
import 'package:feature_source_firebase/feature_source_firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simpledo/features.dart';
import 'package:simpledo/screens/main_screen_wm.dart';
import 'package:simpledo/screens/widgets/days_selection/radius_days_selection.dart';
import 'package:simpledo/screens/widgets/days_selection/week_days_selection.dart';
import 'package:simpledo/screens/widgets/task_creation_list_item.dart';
import 'package:simpledo/screens/widgets/task_view_list_item.dart';

class MainScreen extends ElementaryWidget<MainScreenWM> {
  const MainScreen({
    WidgetModelFactory wmFactory = mainScreenWmFactory,
    Key? key,
  }) : super(wmFactory, key: key);

  @override
  Widget build(MainScreenWM wm) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: EntityStateNotifierBuilder<DayTasksState>(
                listenableEntityState: wm.tasksState,
                builder: (context, data) {
                  return FeatureWidget.builder(
                    feature: Features.getFeatureByType<UseWeekDaysToggle>(),
                    builder: (context, feature) {
                      if (feature?.enabled ?? false) {
                        return WeekDaysSelection(
                          scrollController: wm.daySelectionScrollController,
                          selectedDay: data?.day,
                          onSelectDay: wm.selectDay,
                          dayHasTasksPredicate:
                              wm.datesContainingActiveTasks.value.contains,
                        );
                      } else {
                        return RadiusDaysSelection(
                          daysRadius: 2,
                          scrollController: wm.daySelectionScrollController,
                          startDay: wm.now,
                          selectedDay: data?.day,
                          onSelectDay: wm.selectDay,
                          dayHasTasksPredicate:
                              wm.datesContainingActiveTasks.value.contains,
                        );
                      }
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: wm.onScrollTaskDays,
                onTap: wm.dismissKeyboard,
                onDoubleTap: wm.focusToCreateTask,
                child: _DayTasks(wm: wm),
              ),
            ),
            GestureDetector(
              onHorizontalDragEnd: wm.onScrollTaskDays,
              onTap: wm.dismissKeyboard,
              onDoubleTap: wm.focusToCreateTask,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                    ),
                    if (kDebugMode)
                      IconButton(
                        onPressed: wm.navigateFeaturesDebug,
                        icon: const Icon(
                          Icons.settings_input_component,
                          color: Colors.grey,
                        ),
                      ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayTasks extends StatelessWidget {
  final MainScreenWM wm;

  const _DayTasks({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EntityStateNotifierBuilder<DayTasksState>(
      listenableEntityState: wm.tasksState,
      builder: (context, data) {
        final tasks = data?.tasks ?? [];
        if (tasks.isNotEmpty) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            primary: false,
            child: Column(
              children: [
                ReorderableListView.builder(
                  itemCount: tasks.length,
                  physics: const NeverScrollableScrollPhysics(),
                  onReorder: (o, n) async => wm.reorderTasks(
                    oldPosition: o,
                    newPosition: n,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskViewListItem(
                      key: ValueKey(task),
                      task: task,
                      onToggleComplete: (newState) async {
                        await wm.editTask(task.edit(
                          isCompleted: newState,
                        ));
                      },
                      onDeleteTask: () => wm.deleteTask(task),
                      onEditTask: (content) async {
                        await wm.editTask(task.edit(
                          content: content,
                        ));
                      },
                    );
                  },
                ),
                TaskCreationListItem(
                  focusNode: wm.taskCreationFocusNode,
                  onCreateTask: (content) => wm.createNewTask(
                    content: content,
                    targetDate:
                        wm.tasksState.value?.data?.day ?? DateTime.now(),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                TaskCreationListItem(
                  focusNode: wm.taskCreationFocusNode,
                  onCreateTask: (content) => wm.createNewTask(
                    content: content,
                    targetDate:
                        wm.tasksState.value?.data?.day ?? DateTime.now(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
