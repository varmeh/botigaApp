import 'package:intl/intl.dart';

extension DateExtension on DateTime {
  String get dateCompleteWithTime =>
      DateFormat('d MMM, y hh:mm a').format(this);

  String get dateFormatDayMonth => DateFormat('d MMM').format(this);

  String get dateFormatDayMonthComplete => DateFormat('d MMMM').format(this);

  String get dateFormatDayMonthTime =>
      DateFormat('d MMMM hh:mm a').format(this);
}
