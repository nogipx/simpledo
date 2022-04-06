// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_hive_dto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskHiveDtoAdapter extends TypeAdapter<TaskHiveDto> {
  @override
  final int typeId = 1;

  @override
  TaskHiveDto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHiveDto(
      creationTime: fields[0] as DateTime,
      editTime: fields[1] as DateTime,
      content: fields[2] as String,
      isCompleted: fields[3] as bool,
      id: fields[4] as String,
      order: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveDto obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.creationTime)
      ..writeByte(1)
      ..write(obj.editTime)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHiveDtoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
