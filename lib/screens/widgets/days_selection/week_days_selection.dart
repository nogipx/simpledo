import 'package:flutter/material.dart';
import 'package:simpledo/helpers/date_time_extension.dart';
import 'package:simpledo/screens/widgets/day_button.dart';
import 'package:simpledo/screens/widgets/days_selection/days_selection_interface.dart';

class WeekDaysSelection extends StatefulWidget implements DaysSelectionWidget {
  final ScrollController? scrollController;
  final DateTime dayInWeek;

  @override
  final DateTimeCallback? onSelectDay;
  @override
  final DateTimePredicate? dayHasTasksPredicate;
  @override
  final DateTime selectedDay;

  WeekDaysSelection({
    this.scrollController,
    this.onSelectDay,
    this.dayHasTasksPredicate,
    DateTime? dayInWeek,
    DateTime? selectedDay,
    Key? key,
  })  : dayInWeek = dayInWeek ?? DateTime.now().onlyDate,
        selectedDay = selectedDay ?? DateTime.now().onlyDate,
        super(key: key);

  @override
  State<WeekDaysSelection> createState() => _WeekDaysSelectionState();
}

class _WeekDaysSelectionState extends State<WeekDaysSelection> {
  late final weekdays = List.generate(
    7,
    (index) => widget.dayInWeek.weekStartDay.add(
      Duration(days: index),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (_) {
        _.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: widget.scrollController,
        child: Row(
          children: weekdays.map((day) {
            return DayButton(
              day: day,
              isSelected: widget.selectedDay.isSameDay(day),
              onTap: () => widget.onSelectDay?.call(day.onlyDate),
              hasTasks: widget.dayHasTasksPredicate?.call(day.onlyDate),
            );
          }).toList(),
        ),
      ),
    );
  }
}
