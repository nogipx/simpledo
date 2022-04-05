import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

@immutable
class Task {
  final DateTime creationTime;
  final DateTime editTime;
  final String content;
  final bool isCompleted;
  final String id;

  @override
  int get hashCode => hashValues(runtimeType, id);

  const Task._({
    required this.creationTime,
    required this.editTime,
    required this.content,
    required this.id,
    this.isCompleted = false,
  });

  factory Task.create({
    required String content,
  }) {
    final now = DateTime.now();
    return Task._(
      creationTime: now,
      editTime: now,
      content: content,
      id: const Uuid().v4(),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) || other is Task && id == other.id;
  }

  Task edit({
    String? content = '',
    bool? isCompleted,
  }) =>
      Task._(
        creationTime: creationTime,
        editTime: DateTime.now(),
        content: content != null && content.isNotEmpty ? content : this.content,
        id: id,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}
