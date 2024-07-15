import 'package:bahai_writings/src/extensions/int_extension.dart';
import 'package:intl/intl.dart';

final _format = DateFormat('d MMM yyyy');

extension DateTimeExtension on DateTime {
  DateTime get beginningOfDay => DateTime(year, month, day);

  String dMMMyyyy() => _format.format(this);

  String yyyyMMdd() => '$year${month.padLeft(2)}${day.padLeft(2)}';

  String toCode({bool time = false}) => [
        'DateTime(',
        '$year',
        ', $month',
        ', $day',
        if (time) ', $hour, $minute, $second',
        ')',
      ].join();
}
