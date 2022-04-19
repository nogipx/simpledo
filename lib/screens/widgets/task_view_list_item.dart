import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpledo/data/export.dart';
import 'package:simpledo/helpers/keyboard_helper.dart';

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
    with WidgetsBindingObserver, KeyboardHelperMixin {
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

  Timer? _contentDebounce;

  @override
  void dispose() {
    super.dispose();
    _hasEditFocus.dispose();
    _contentFocus.dispose();
    _contentController.dispose();
    _content.dispose();
    _contentDebounce?.cancel();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  Future<void> onKeyboardVisibilityChange(bool isKeyboardHidden) async {
    if (isKeyboardHidden) {
      await widget.onEditTask?.call(_contentController.text);
      _contentFocus.unfocus();
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
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 250,
                ),
                child: TextFormField(
                  focusNode: _contentFocus,
                  controller: _contentController,
                  maxLines: null,
                  onEditingComplete: () {
                    widget.onEditTask?.call(_contentController.text);
                  },
                  onChanged: _debounceOnChangeContent,
                  onFieldSubmitted: (_) async {
                    await widget.onEditTask?.call(_contentController.text);
                    _contentFocus.unfocus();
                  },
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                  decoration: InputDecoration(
                    hintText: 'Изменить задачу',
                    hintStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: Colors.grey.shade400,
                        ),
                    border: InputBorder.none,
                  ),
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

  Future<void> _debounceOnChangeContent(String text) async {
    _contentDebounce?.cancel();
    _contentDebounce = Timer(
      const Duration(milliseconds: 300),
      () async {
        await widget.onEditTask?.call(_contentController.text);
      },
    );
  }
}
