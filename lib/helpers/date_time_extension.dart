import 'dart:io';

final deviceLanguage = Platform.localeName.substring(0, 2);

extension ExtDateTime on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get _isRus => deviceLanguage == 'ru';

  DateTime get onlyDate => DateTime(year, month, day);

  String get shortWeekDay {
    switch (weekday) {
      case 1:
        return _isRus ? 'пн' : 'mon';
      case 2:
        return _isRus ? 'вт' : 'tue';
      case 3:
        return _isRus ? 'ср' : 'thu';
      case 4:
        return _isRus ? 'чт' : 'wed';
      case 5:
        return _isRus ? 'пт' : 'fri';
      case 6:
        return _isRus ? 'сб' : 'sat';
      case 7:
        return _isRus ? 'вс' : 'sun';
      default:
        return '';
    }
  }

  DateTime get weekStartDay {
    final weekStartDay = subtract(Duration(days: weekday - 1));
    return weekStartDay.onlyDate;
  }

  DateTime get weekEndDay {
    final weekStartDay = add(Duration(days: 7 - weekday));
    return weekStartDay.onlyDate;
  }
}
