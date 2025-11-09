import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _todayFormat = DateFormat('HH:mm');
  static final DateFormat _thisWeekFormat = DateFormat('EEE');
  static final DateFormat _thisYearFormat = DateFormat('MMM d');
  static final DateFormat _defaultFormat = DateFormat('MMM d, y');

  static String format(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final lastWeek = today.subtract(const Duration(days: 7));
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Today, ${_todayFormat.format(date)}';
    }

    if (dateToCompare == yesterday) {
      return 'Yesterday, ${_todayFormat.format(date)}';
    }

    if (date.isAfter(lastWeek) && date.isBefore(yesterday)) {
      return _thisWeekFormat.format(date);
    }

    if (date.year == now.year) {
      return _thisYearFormat.format(date);
    }

    return _defaultFormat.format(date);
  }
}