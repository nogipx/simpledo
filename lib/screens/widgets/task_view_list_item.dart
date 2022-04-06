import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_task/data/export.dart';

class TaskViewListItem extends StatefulWidget {
  final FutureOr<void> Function(String content)? onEditTask;
  final FutureOr<void> Function()? onDeleteTask;
  final FutureOr<void> Function(bool newState)? onToggleComplete;
  final Task task;

  const TaskViewListItem({
    required this.task,
    this.onEditTask,
    this.onDeleteTask,
    this.onToggleComplete,
    Key? key,
  }) : super(key: key);

  @override
  State<TaskViewListItem> createState() => _TaskViewListItemState();
}

class _TaskViewListItemState extends State<TaskViewListItem>
    with WidgetsBindingObserver {
  late final FocusNode _contentFocus = FocusNode()
    ..addListener(() {
      _hasEditFocus.value = _contentFocus.hasFocus;
    });
  late final TextEditingController _contentController = TextEditingController(
    text: widget.task.content,
  )..addListener(() {
      _content.value = _contentController.text;
    });

  late final ValueNotifier<bool> _hasEditFocus = ValueNotifier(false);
  late final ValueNotifier<String> _content = ValueNotifier('');
  late final ValueNotifier<bool> _isKeyboardVisible = ValueNotifier(false)
    ..addListener(() {
      if (!_isKeyboardVisible.value) {
        _contentFocus.unfocus();
      }
    });

  @override
  void dispose() {
    super.dispose();
    _contentFocus.dispose();
    _contentController.dispose();
    _hasEditFocus.dispose();
    _content.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance?.window.viewInsets.bottom;
    if (bottomInset != null) {
      final newValue = bottomInset > 0.0;
      if (newValue != _isKeyboardVisible.value) {
        setState(() {
          _isKeyboardVisible.value = newValue;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _hasEditFocus,
            builder: (context, hasFocus, _) {
              if (hasFocus) {
                return InkWell(
                  onTap: _contentController.clear,
                  child: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),
                );
              } else {
                return InkWell(
                  onTap: () =>
                      widget.onToggleComplete?.call(!widget.task.isCompleted),
                  child: !widget.task.isCompleted
                      ? const Icon(
                          Icons.check_box_outline_blank_rounded,
                          color: Colors.grey,
                        )
                      : Icon(
                          Icons.check,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                );
              }
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onLongPress: () {},
              child: TextFormField(
                focusNode: _contentFocus,
                controller: _contentController,
                onEditingComplete: () {
                  widget.onEditTask?.call(_contentController.text);
                },
                onFieldSubmitted: (text) {
                  widget.onEditTask?.call(text);
                  _contentFocus.unfocus();
                },
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                decoration: const InputDecoration(
                  hintText: 'Изменить задание',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          ValueListenableBuilder<bool>(
            valueListenable: _hasEditFocus,
            builder: (context, hasFocus, _) {
              return ValueListenableBuilder<String>(
                valueListenable: _content,
                builder: (context, content, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: hasFocus
                        ? InkWell(
                            key: const Key('canDelete'),
                            onTap: () async {
                              await widget.onDeleteTask?.call();
                              _contentController.clear();
                              _contentFocus.unfocus();
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                          )
                        : const SizedBox(
                            key: Key('cannotDelete'),
                          ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}