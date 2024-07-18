import 'package:badi_date/badi_date.dart';
import 'package:badi_date/names.dart';
import 'package:bahai_writings/src/extensions/int_extension.dart';
import 'package:collection/collection.dart';

extension BadiDateExtension on BadiDate {
  String yyyMMdd() => '$year${month.padLeft(2)}${day.padLeft(2)}';

  String get monthName => isAyyamIHa ? ayyamIHa : monthNames[month]!;

  String dMMMMyyyBE() => '$day $monthName $year B.E.';

  String toCode() => 'BadiDate(year: $year, month: $month, day: $day)';
}

extension ComparableBadiDateExtension on BadiDate {
  int compareTo(BadiDate other) =>
      [
        year.compareTo(other.year),
        dayOfYear.compareTo(other.dayOfYear),
      ].firstWhereOrNull((c) => c != 0) ??
      0;
}

extension IterableComparableBadiDateExtension on Iterable<BadiDate> {
  BadiDate get min => minOrNull ?? (throw StateError('No element'));
  BadiDate get max => maxOrNull ?? (throw StateError('No element'));

  BadiDate? get minOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) > 0) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  BadiDate? get maxOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) < 0) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }
}
