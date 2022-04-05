import 'package:hive/hive.dart';
import 'package:test_task/data/entity/task.dart';
import 'package:test_task/data/hive_types.dart';

part 'task_hive_dto.g.dart';

@HiveType(typeId: HiveTypes.task)
class TaskHiveDto {
  @HiveField(0)
  final DateTime creationTime;
  @HiveField(1)
  final DateTime editTime;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final bool isCompleted;
  @HiveField(4)
  final String id;

  TaskHiveDto({
    required this.creationTime,
    required this.editTime,
    required this.content,
    required this.isCompleted,
    required this.id,
  });

  factory TaskHiveDto.fromEntity(Task obj) {
    return TaskHiveDto(
      creationTime: obj.creationTime,
      editTime: obj.editTime,
      content: obj.content,
      isCompleted: obj.isCompleted,
      id: obj.id,
    );
  }
}
