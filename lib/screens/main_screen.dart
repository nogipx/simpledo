import 'package:elementary/elementary.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simpledo/helpers/date_time_extension.dart';
import 'package:simpledo/screens/main_screen_wm.dart';
import 'package:simpledo/screens/widgets/day_button.dart';
import 'package:simpledo/screens/widgets/task_creation_list_item.dart';
import 'package:simpledo/screens/widgets/task_view_list_item.dart';

class MainScreen extends ElementaryWidget<MainScreenWM> {
  final int datesRadius;

  const MainScreen({
    WidgetModelFactory wmFactory = mainScreenWmFactory,
    Key? key,
    this.datesRadius = 2,
  }) : super(wmFactory, key: key);

  @override
  Widget build(MainScreenWM wm) {
    final daysCount = datesRadius * 2 + 1;
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
                  final start = wm.now.subtract(Duration(days: datesRadius));
                  return NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (_) {
                      _.disallowIndicator();
                      return true;
                    },
                    child: ListView.separated(
                      itemCount: daysCount,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      primary: false,
                      physics: const ClampingScrollPhysics(),
                      controller: wm.daySelectionScrollController,
                      separatorBuilder: (_, __) => const SizedBox(width: 4),
                      itemBuilder: (context, index) {
                        final day = start.add(Duration(days: index));

                        return DayButton(
                          key: ValueKey(day),
                          day: day,
                          isSelected: data?.day.isSameDay(day) ?? false,
                          onTap: () => wm.selectDay(day),
                          hasTasks: wm.datesContainingActiveTasks.value
                              .contains(day.onlyDate),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: wm.onScrollTaskDays,
                onTap: wm.dismissKeyboard,
                onDoubleTap: wm.focusToCreateTask,
                child: _buildDayTasks(wm),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTasks(MainScreenWM wm) {
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
