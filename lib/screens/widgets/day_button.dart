import 'package:flutter/material.dart';
import 'package:simpledo/helpers/date_time_extension.dart';

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
                  deviceLanguage == 'ru' ? 'сегодня' : 'today',
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
    if (isSelected) {
      return Theme.of(context).colorScheme.primary;
    }
    if (_isToday) {
      return Theme.of(context).colorScheme.primary.withAlpha(130);
      return Colors.indigo.shade400;
    }
    if (day.weekday > 5) {
      return Colors.red.shade300;
    }
    return Colors.black87;
  }
}
