import 'package:bahai_writings/src/extensions/date_time_extension.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

final _iso8601 = DateFormat('yyyy-MM-dd');

/// Constantable, comparable class for naive Gregorian dates.
class Date implements Comparable<Date> {
  const Date(this.year, this.month, this.day)
      // Perform very basic sanity checks.
      : assert(year >= 1582 && year <= 3000, 'invalid year'),
        assert(month > 0 && month < 13, 'invalid month'),
        assert(
            day > 0 &&
                (month == 2
                    ? day < 30
                    : (month == 9 || month == 4 || month == 6 || month == 11)
                        ? day < 31
                        : day < 32),
            'invalid day for month $month');

  final int year;
  final int month;
  final int day;

  /// Returns midnight on the [DateTime] of `this`.
  DateTime get dateTime => DateTime(year, month, day);

  /// NOTE! Effectively adds the `duration` to midnight of `this`.
  Date add(Duration duration) => dateTime.add(duration).date;

  /// NOTE! Effectively computes the difference between midnights of `this` and `other`.
  Duration difference(Date other) => dateTime.difference(other.dateTime);

  bool isAfter(Date other) => dateTime.isAfter(other.dateTime);

  bool isOn(Date other) => this == other;

  bool isBefore(Date other) => dateTime.isBefore(other.dateTime);

  /// NOTE! Effectively subtracts the `duration` from midnight of `this`.
  Date subtract(Duration duration) => dateTime.subtract(duration).date;

  String toIso8601String() => _iso8601.format(dateTime);

  int get weekday => dateTime.weekday;

  @override
  int compareTo(Date other) =>
      [
        year.compareTo(other.year),
        month.compareTo(other.month),
        day.compareTo(other.day),
      ].firstWhereOrNull((c) => c != 0) ??
      0;

  @override
  bool operator ==(Object other) =>
      other is Date &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toCode();

  String toCode() => 'Date($year, $month, $day)';
}
