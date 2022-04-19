import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpledo/helpers/date_time_extension.dart';

class TaskCreationListItem extends StatefulWidget {
  final FutureOr<void> Function(String content)? onCreateTask;
  final FocusNode? focusNode;

  const TaskCreationListItem({
    Key? key,
    this.onCreateTask,
    this.focusNode,
  }) : super(key: key);

  @override
  State<TaskCreationListItem> createState() => _TaskCreationListItemState();
}

class _TaskCreationListItemState extends State<TaskCreationListItem> {
  late final FocusNode _contentFocus = (widget.focusNode ?? FocusNode())
    ..addListener(() {
      _hasCreationFocus.value = _contentFocus.hasPrimaryFocus;
    });
  late final TextEditingController _contentController = TextEditingController()
    ..addListener(() {
      _content.value = _contentController.text;
    });

  late final ValueNotifier<bool> _hasCreationFocus = ValueNotifier(false);
  late final ValueNotifier<String> _content = ValueNotifier('');

  @override
  void dispose() {
    super.dispose();
    if (widget.focusNode == null) {
      _contentFocus.dispose();
    }
    _contentController.dispose();
    _hasCreationFocus.dispose();
    _content.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: _hasCreationFocus,
            builder: (context, hasFocus, _) {
              return InkWell(
                onTap: hasFocus
                    ? () {
                        _contentController.clear();
                        _contentFocus.unfocus();
                      }
                    : null,
                child: Icon(
                  hasFocus ? Icons.clear : Icons.add,
                  color: Colors.grey,
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              focusNode: _contentFocus,
              controller: _contentController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: deviceLanguage == 'ru' ? 'Новая задача' : 'New task',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.subtitle1?.copyWith(
                      color: Colors.grey.shade400,
                    ),
              ),
              onFieldSubmitted: (text) {
                if (_hasCreationFocus.value) {
                  widget.onCreateTask?.call(text);
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          ValueListenableBuilder<bool>(
            valueListenable: _hasCreationFocus,
            builder: (context, hasFocus, _) {
              return ValueListenableBuilder<String>(
                valueListenable: _content,
                builder: (context, content, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: hasFocus && content.isNotEmpty
                        ? InkWell(
                            key: const Key('canSave'),
                            onTap: () async {
                              await widget.onCreateTask
                                  ?.call(_contentController.text);
                              _contentController.clear();
                              _contentFocus.unfocus();
                            },
                            child: Icon(
                              Icons.save_outlined,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : const SizedBox(
                            key: Key('cannotSave'),
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
