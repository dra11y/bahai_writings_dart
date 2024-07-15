import 'package:badi_date/badi_date.dart';
import 'package:badi_date/names.dart';
import 'package:bahai_writings/src/extensions/int_extension.dart';

extension BadiDateExtension on BadiDate {
  String yyyMMdd() => '$year${month.padLeft(2)}${day.padLeft(2)}';

  String get monthName => isAyyamIHa ? ayyamIHa : monthNames[month]!;

  String dMMMMyyyBE() => '$day $monthName $year B.E.';

  String toCode() => [
        'BadiDate(',
        'year: $year',
        'year: $month',
        'year: $day',
        ')',
      ].join();
}
