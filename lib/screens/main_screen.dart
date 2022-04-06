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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => wm.createNewTask(''),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.red,
            height: 100,
            child: EntityStateNotifierBuilder<DayTasksState>(
              listenableEntityState: wm.tasksState,
              builder: (context, data) {
                return ListView.builder(
                  itemCount: 14,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final day = wm.weekBeforeNow.add(Duration(days: index));

                    return DayButton(
                      day: day,
                      isToday: data?.day.isSameDay(day) ?? false,
                      onTap: () => wm.pullDayTasks(day),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: EntityStateNotifierBuilder<DayTasksState>(
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
            ),
          ),
        ],
      ),
    );
  }
}
