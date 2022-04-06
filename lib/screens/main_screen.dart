import 'package:elementary/elementary.dart';
import 'package:flutter/material.dart';
import 'package:test_task/helpers/date_time_extension.dart';
import 'package:test_task/screens/main_screen_wm.dart';
import 'package:test_task/screens/widgets/day_button.dart';

class MainScreen extends ElementaryWidget<MainScreenWM> {
  const MainScreen({
    WidgetModelFactory wmFactory = mainScreenWmFactory,
    Key? key,
  }) : super(wmFactory, key: key);

  @override
  Widget build(MainScreenWM wm) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => wm.createNewTask(
            content: '',
            targetDate: wm.tasksState.value?.data?.day ?? DateTime.now(),
          ),
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80,
              child: EntityStateNotifierBuilder<DayTasksState>(
                listenableEntityState: wm.tasksState,
                builder: (context, data) {
                  return ListView.separated(
                    itemCount: 14,
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
                        hasTasks: wm.datesContainingTasks.value
                            .contains(day.onlyDate),
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: PageView.builder(
                itemCount: 14,
                controller: wm.dayPageScrollController,
                physics: const ClampingScrollPhysics(),
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
                        return ReorderableListView.builder(
                          itemCount: tasks.length,
                          onReorder: (o, n) async => wm.reorderTasks(
                            oldPosition: o,
                            newPosition: n,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Padding(
                              key: ValueKey(task),
                              padding: const EdgeInsets.all(8),
                              child: Text(task.id),
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text('no tasks'));
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
