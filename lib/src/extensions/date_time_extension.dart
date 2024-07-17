import 'package:bahai_writings/src/extensions/int_extension.dart';
import 'package:intl/intl.dart';

import '../models/date.dart';

final _format = DateFormat('d MMM yyyy');

extension DateExtension on Date {
  String dMMMyyyy() => _format.format(dateTime);
  String yyyyMMdd() => '$year${month.padLeft(2)}${day.padLeft(2)}';
}

extension DateTimeExtension on DateTime {
  Date get date => Date(year, month, day);

  DateTime get beginningOfDay => DateTime(year, month, day);

  String dMMMyyyy() => _format.format(this);

  String yyyyMMdd() => '$year${month.padLeft(2)}${day.padLeft(2)}';
}
