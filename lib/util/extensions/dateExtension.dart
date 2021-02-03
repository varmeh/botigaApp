import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get dateCompleteWithTime =>
      DateFormat('d MMM, y hh:mm a').format(this.toLocal());

  String get dateFormatDayMonth => DateFormat('d MMM').format(this.toLocal());

  String get dateFormatWeekDayMonthDay =>
      DateFormat('E, MMM d').format(this.toLocal());

  String get dateFormatDayDateMonth =>
      DateFormat('E, d MMM').format(this.toLocal());

  String get dateFormatDayMonthComplete =>
      DateFormat('d MMMM').format(this.toLocal());

  String get dateFormatDayMonthTime =>
      DateFormat('d MMMM hh:mm a').format(this.toLocal());

  String get dateFormatCompleteWeekDayMonthDay =>
      DateFormat('EEEE, MMM d').format(this.toLocal());

  String get dateFormatTime => DateFormat('hh:mm a').format(this.toLocal());
}
