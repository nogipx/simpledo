import 'package:flutter/material.dart';
import 'package:test_task/helpers/date_time_extension.dart';

class DayButton extends StatelessWidget {
  final VoidCallback? onTap;
  final DateTime day;
  final bool isSelected;
  final bool? hasTasks;

  late final bool _isToday = day.isSameDay(DateTime.now());

  DayButton({
    required this.day,
    this.onTap,
    this.isSelected = false,
    this.hasTasks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: SizedBox(
          width: 70,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  _isToday ? 0 : 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      child: Text(
                        day.day.toString(),
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: _textColor(context),
                            ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Stack(
                      children: [
                        Align(
                          child: Text(
                            day.shortWeekDay,
                            style:
                                Theme.of(context).textTheme.subtitle1?.copyWith(
                                      color: _textColor(context),
                                    ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          right: 0,
                          child: hasTasks ?? false
                              ? Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isToday) ...[
                const SizedBox(height: 4),
                Text(
                  'сегодня',
                  style: Theme.of(context).textTheme.caption?.copyWith(
                        // color: _textColor(context),
                        fontSize: 10,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _textColor(BuildContext context) {
    return isSelected
        ? Theme.of(context).colorScheme.primary
        : _isToday
            ? Colors.red.shade300
            : Colors.black87;
  }
}
