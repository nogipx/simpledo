extension ExtDateTime on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime get onlyDate => DateTime(year, month, day);

  String get shortWeekDay {
    switch (weekday) {
      case 1:
        return 'пн';
      case 2:
        return 'вт';
      case 3:
        return 'ср';
      case 4:
        return 'чт';
      case 5:
        return 'пт';
      case 6:
        return 'сб';
      case 7:
        return 'вс';
      default:
        return '';
    }
  }
}
