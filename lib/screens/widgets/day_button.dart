import 'package:flutter/material.dart';
import 'package:test_task/helpers/date_time_extension.dart';

class DayButton extends StatelessWidget {
  final VoidCallback? onTap;
  final DateTime day;
  final bool isToday;

  const DayButton({
    required this.day,
    this.onTap,
    this.isToday = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              day.day.toString(),
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: _textColor(context),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              day.shortWeekDay,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: _textColor(context),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Color _textColor(BuildContext context) =>
      isToday ? Theme.of(context).primaryColor : Colors.black87;
}
