part of 'writings_base.dart';

class Message extends MessageBase {
  Message({
    required super.date,
    required super.title,
    required super.summary,
    required super.url,
  });

  @override
  String toCode() => [
        '$runtimeType(',
        'date: ${date.toCode()}',
        ", title: '${title.escapeSingle()}'",
        if (summary != null) ", summary: '${summary!.escapeSingle()}'",
        ", url: '$url'",
        ',)',
      ].join();
}

class NawRuzMessage extends MessageBase {
  NawRuzMessage({
    int? be,
    int? year,
    required super.title,
    required super.summary,
    required super.url,
  })  : assert((be == null) != (year == null)),
        super(
          badiDate: BadiDate(year: be ?? year! - 1843, day: 1, month: 1),
          isBadiDate: be != null,
        );

  @override
  String toCode() => [
        '$runtimeType(',
        isBadiDate ? 'be: $be' : 'year: $year',
        ", title: '${title.escapeSingle()}'",
        if (summary != null) ", summary: '${summary!.escapeSingle()}'",
        ", url: '$url'",
        ',)',
      ].join();
}

class RidvanMessage extends MessageBase {
  RidvanMessage({
    int? be,
    int? year,
    required super.title,
    required super.summary,
    required super.url,
  })  : assert((be == null) != (year == null)),
        super(
          badiDate: BadiDate(year: be ?? year! - 1843, day: 13, month: 2),
          isBadiDate: be != null,
        );

  @override
  String toCode() => [
        '$runtimeType(',
        isBadiDate ? 'be: $be' : 'year: $year',
        ", title: '${title.escapeSingle()}'",
        if (summary != null) ", summary: '${summary!.escapeSingle()}'",
        ", url: '$url'",
        ',)',
      ].join();
}

/// ------------------------------------------------------------
/// Messages of the Universal House of Justice
/// ------------------------------------------------------------
sealed class MessageBase implements WritingsBase {
  MessageBase({
    BadiDate? badiDate,
    DateTime? date,
    bool? isBadiDate,
    required this.title,
    required this.url,
    required this.summary,
  })  : sortTitle = title,
        isCompilation = false,
        assert((badiDate == null) != (date == null)),
        isBadiDate = isBadiDate ?? badiDate != null,
        date = date ?? badiDate!.startDateTime.beginningOfDay,
        badiDate = badiDate ?? BadiDate.fromDate(date!);

  int get be => badiDate.year;
  int get year => date.year;
  final bool isBadiDate;
  final BadiDate badiDate;
  final DateTime date;
  final String url;

  @override
  final Set<Institution> authors = const {UHJ()};

  @override
  Institution? get singleAuthor => authors.singleOrNull;

  @override
  final String title;

  @override
  final String sortTitle;

  @override
  String? get subtitle => null;

  @override
  final String? summary;

  @override
  final bool isCompilation;

  @override
  int compareTo(WritingsBase other) => switch (other) {
        MessageBase() => date.compareTo(other.date),
        WritingsAuthorTitleComparable() => compareTo(other),
      };

  String toCode();

  @override
  String toString() => [
        '$runtimeType(',
        '    title: $title,',
        '    date: $date,',
        '    badiDate: $badiDate,',
        '    summary: $summary,',
        '    url: $url,',
        ')',
      ].join('\n');
}
