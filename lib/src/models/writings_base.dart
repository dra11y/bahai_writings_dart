import 'package:badi_date/badi_date.dart';
import 'package:bahai_writings/src/extensions/badi_date_extension.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import '../extensions/extensions.dart';
import 'author.dart';
import 'date.dart';

part 'guardian_writings.dart';
part 'message.dart';
part 'sacred_writings.dart';

sealed class WritingsBase implements Comparable<WritingsBase> {
  const WritingsBase({
    required this.authors,
    required this.title,
    required this.sortTitle,
    this.subtitle,
    this.summary,
    this.isCompilation = false,
  });

  final Set<Author> authors;
  Author? get singleAuthor;
  final String title;
  final String sortTitle;
  final String? subtitle;
  final String? summary;
  final bool isCompilation;
}

mixin WritingsAuthorTitleComparable implements Comparable<WritingsBase> {
  Set<Author> get authors;
  String get sortTitle;

  @override
  int compareTo(WritingsBase other) => switch (other) {
        MessageBase() => compareTo(other),
        WritingsAuthorTitleComparable() => [
              authors.map((a) => a.sortIndex).minOrNull?.compareTo(
                  other.authors.map((a) => a.sortIndex).minOrNull ?? 0),
              sortTitle.compareTo(other.sortTitle),
            ].nonNulls.firstWhereOrNull((c) => c != 0) ??
            0,
      };
}
