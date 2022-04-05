import 'package:flutter_test/flutter_test.dart';
import 'package:test_task/data/dto/task_hive_dto.dart';
import 'package:test_task/data/entity/task.dart';

void main() {
  group('Task', () {
    final task1 = Task.create(content: '1');
    final task2 = Task.create(content: '2');

    test('twoTasksNotSame', () {
      expect(task1, isNot(equals(task2)));
    });

    test('taskIsSameAfterEdit', () {
      final editTask = task1.edit(isCompleted: true, content: 'isCompleted');
      expect(task1, equals(editTask));
    });

    test('dtoConversionSame', () {
      final task1 = Task.create(content: '1');
      final dto = TaskHiveDto.fromEntity(task1);
      final convertBackTask1 = Task.fromDto(dto);
      expect(task1, equals(convertBackTask1));
    });
  });
}
