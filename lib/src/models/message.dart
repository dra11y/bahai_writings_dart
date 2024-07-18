part of 'writings_base.dart';

class Message extends MessageBase with MessageContentMixin {
  Message({
    required super.id,
    required super.number,
    required super.title,
    required super.date,
    required super.badiDate,
    required super.summary,
    required super.url,
  });
}

class RidvanMessage extends MessageBase with MessageContentMixin {
  RidvanMessage({
    required super.id,
    required super.number,
    required super.title,
    required super.date,
    required super.badiDate,
    required super.summary,
    required super.url,
  });
}

class NawRuzMessage extends MessageBase with MessageContentMixin {
  NawRuzMessage({
    required super.id,
    required super.number,
    required super.title,
    required super.date,
    required super.badiDate,
    required super.summary,
    required super.url,
  });
}

class PromiseOfWorldPeaceMessage extends MessageBase with MessageContentMixin {
  PromiseOfWorldPeaceMessage({
    required super.id,
    required super.number,
    required super.title,
    required super.date,
    required super.badiDate,
    required super.summary,
    required super.url,
  });
}

/// ------------------------------------------------------------
/// Messages of the Universal House of Justice
/// ------------------------------------------------------------
sealed class MessageBase implements WritingsBase {
  const MessageBase({
    required this.id,
    required this.number,
    required this.title,
    required this.date,
    required this.badiDate,
    required this.summary,
    required this.url,
  }) : sortTitle = title;

  final String id;

  final int number;

  @override
  final String title;

  String get content;

  String get formattedDateTitle => '$formattedDate: $title';

  String get formattedDate => switch (this) {
        RidvanMessage() => 'Riḍván ${date.year} (${badiDate.year} B.E.)',
        NawRuzMessage() => 'Naw-Rúz ${date.year} (${badiDate.year} B.E.)',
        PromiseOfWorldPeaceMessage() =>
          DateFormat('MMMM yyyy').format(date.utc),
        Message() => '${date.dMMMyyyy()} (${badiDate.dMMMMyyyBE()})',
      };

  /// The publication date of the message.
  final Date date;

  /// The [BadiDate] of the publication date of the message.
  final BadiDate badiDate;

  @override
  final String summary;

  /// The URL of the source text of the message.
  final String url;

  @override
  final Set<Institution> authors = const {UHJ()};

  @override
  final Institution singleAuthor = const UHJ();

  @override
  final String sortTitle;

  @override
  final String? subtitle = null;

  @override
  final bool isCompilation = false;

  @override
  int compareTo(WritingsBase other) => switch (other) {
        MessageBase() => [
              date.compareTo(other.date),
              sortTitle.compareTo(other.sortTitle),
            ].firstWhereOrNull((c) => c != 0) ??
            0,
        WritingsAuthorTitleComparable() => compareTo(other),
      };

  @override
  String toString() => toCode();

  String toCode() => [
        '$runtimeType(',
        "    id: '$id',",
        "    number: $number,",
        "    title: '${title.escapeSingle()}',",
        '    date: ${date.toCode()},',
        '    badiDate: ${badiDate.toCode()},',
        "    summary: '${summary.escapeSingle()}',",
        "    url: '${url.escapeSingle()}',",
        ')',
      ].join('\n');

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, date, badiDate, url, summary);

  @override
  bool operator ==(Object other) =>
      other is MessageBase &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.badiDate == badiDate &&
      other.summary == summary &&
      other.url == url;
}
