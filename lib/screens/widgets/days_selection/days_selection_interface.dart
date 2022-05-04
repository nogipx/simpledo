typedef DateTimePredicate = bool Function(DateTime);
typedef DateTimeCallback = void Function(DateTime);

abstract class DaysSelectionWidget {
  DateTimeCallback? get onSelectDay;
  DateTimePredicate? get dayHasTasksPredicate;
  DateTime get selectedDay;
}
