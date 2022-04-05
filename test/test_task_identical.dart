import 'package:flutter_test/flutter_test.dart';
import 'package:test_task/data/task.dart';

void main() {
  group('Task_areTasksSame', () {
    final task1 = Task.create(content: 'a');
    final task2 = Task.create(content: '');

    test('twoTasksNotSame', () {
      expect(task1, isNot(equals(task2)));
    });

    test('taskIsSameAfterEdit', () {
      final editTask = task1.edit(isCompleted: true, content: 'isCompleted');
      expect(task1, equals(editTask));
    });
  });
}
