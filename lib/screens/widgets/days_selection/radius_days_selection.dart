import 'package:flutter/material.dart';
import 'package:simpledo/helpers/date_time_extension.dart';
import 'package:simpledo/screens/widgets/day_button.dart';
import 'package:simpledo/screens/widgets/days_selection/days_selection_interface.dart';

class RadiusDaysSelection extends StatelessWidget
    implements DaysSelectionWidget {
  final ScrollController? scrollController;
  final int daysRadius;
  final DateTime startDay;

  @override
  final void Function(DateTime)? onSelectDay;
  @override
  final bool Function(DateTime)? dayHasTasksPredicate;
  @override
  final DateTime selectedDay;

  RadiusDaysSelection({
    required this.daysRadius,
    this.scrollController,
    this.onSelectDay,
    this.dayHasTasksPredicate,
    DateTime? startDay,
    DateTime? selectedDay,
    Key? key,
  })  : assert(daysRadius > 0),
        startDay = startDay ?? DateTime.now().onlyDate,
        selectedDay = selectedDay ?? DateTime.now().onlyDate,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final radiusRange = List.generate(daysRadius, (i) => i + 1);

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (_) {
        _.disallowIndicator();
        return true;
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              ...radiusRange.reversed.map((index) {
                final day = startDay.subtract(Duration(days: index));
                return Builder(builder: (_) => _buildButton(day));
              }),
              const SizedBox(width: 4),
              Builder(builder: (_) => _buildButton(startDay)),
              const SizedBox(width: 4),
              ...radiusRange.map((index) {
                final day = startDay.add(Duration(days: index));
                return Builder(builder: (_) => _buildButton(day));
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(DateTime day) {
    return DayButton(
      day: day,
      isSelected: selectedDay.isSameDay(day),
      onTap: () => onSelectDay?.call(day.onlyDate),
      hasTasks: dayHasTasksPredicate?.call(day.onlyDate),
    );
  }
}
