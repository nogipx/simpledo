import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:test_task/helpers/date_time_extension.dart';
import 'package:test_task/screens/main_screen_wm.dart';
import 'package:test_task/screens/widgets/day_button.dart';
import 'package:test_task/screens/widgets/task_creation_list_item.dart';
import 'package:test_task/screens/widgets/task_view_list_item.dart';

class MainScreen extends ElementaryWidget<MainScreenWM> {
  final int datesRadius;

  const MainScreen({
    WidgetModelFactory wmFactory = mainScreenWmFactory,
    Key? key,
    this.datesRadius = 15,
  }) : super(wmFactory, key: key);

  @override
  Widget build(MainScreenWM wm) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 80,
              child: EntityStateNotifierBuilder<DayTasksState>(
                listenableEntityState: wm.tasksState,
                builder: (context, data) {
                  return ListView.separated(
                    itemCount: datesRadius,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    primary: false,
                    physics: const ClampingScrollPhysics(),
                    controller: wm.daySelectionScrollController,
                    separatorBuilder: (_, __) => const SizedBox(width: 4),
                    itemBuilder: (context, index) {
                      final day = wm.weekBeforeNow.add(Duration(days: index));

                      return DayButton(
                        key: ValueKey(day),
                        day: day,
                        isSelected: data?.day.isSameDay(day) ?? false,
                        onTap: () => wm.selectDay(day),
                        hasTasks: wm.datesContainingActiveTasks.value
                            .contains(day.onlyDate),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: datesRadius,
                controller: wm.dayPageScrollController,
                physics: const BouncingScrollPhysics(),
                allowImplicitScrolling: true,
                onPageChanged: wm.onPageChanged,
                itemBuilder: (context, index) {
                  return EntityStateNotifierBuilder<DayTasksState>(
                    listenableEntityState: wm.tasksState,
                    loadingBuilder: (context, _) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    builder: (context, data) {
                      final tasks = data?.tasks ?? [];
                      if (tasks.isNotEmpty) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
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
                                onCreateTask: (content) => wm.createNewTask(
                                  content: content,
                                  targetDate: wm.tasksState.value?.data?.day ??
                                      DateTime.now(),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            TaskCreationListItem(
                              onCreateTask: (content) => wm.createNewTask(
                                content: content,
                                targetDate: wm.tasksState.value?.data?.day ??
                                    DateTime.now(),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
