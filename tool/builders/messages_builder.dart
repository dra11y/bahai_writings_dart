import 'dart:async';

import 'package:bahai_writings/src/extensions/badi_date_extension.dart';
import 'package:bahai_writings/src/extensions/date_time_extension.dart';
import 'package:bahai_writings/src/models/writings_base.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pubspec_manager/pubspec_manager.dart';

Builder messagesBuilder(BuilderOptions _) => MessagesBuilder();

class MessagesBuilder implements Builder {
  static final Uri messagesUri = Uri.parse(
      'https://www.bahai.org/library/authoritative-texts/the-universal-house-of-justice/messages/');

  AssetId assetId(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      path.join('lib', 'src', 'generated', 'messages.g.dart'),
    );
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final response = await http.get(messagesUri);
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load UHJ Messages: statusCode ${response.statusCode} from $messagesUri');
    }
    if (response.body.isEmpty) {
      throw Exception(
          'Failed to load UHJ Messages: body is empty from $messagesUri');
    }
    final BeautifulSoup bs = BeautifulSoup(response.body);
    final table = bs.find('table');
    if (table == null) {
      throw Exception('Could not find <table> element');
    }
    final rows = table.findAll('tr', class_: 'document-row');
    final DateFormat dateFormat = DateFormat('d MMMM yyyy');
    final DateFormat monthFormat = DateFormat('MMMM yyyy');
    final datePattern = RegExp(
      r'Naw-Rúz ((?<nawRuzCE>\d{4})|(?<nawRuzBE>\d{3}))'
      r'|Riḍván ((?<ridvanCE>\d{4})|(?<ridvanBE>\d{3}))'
      r'|(?<date>\d\d? [a-z]{3,} \d{4})'
      r'|(?<month>[a-z]{3,} \d{4})'
      '|(?<baha154>Bahá 154 B.E.)',
      caseSensitive: false,
    );
    final Map<DateTime, int> seenDates = {};
    String seenLetter(DateTime date) {
      final seenCount = seenDates[date];
      seenDates[date] = (seenCount ?? 0) + 1;
      if (seenCount == null) {
        return '';
      }
      return String.fromCharCode(seenCount + 96);
    }

    final code = StringBuffer()
      ..writeln('class Messages {')
      ..writeln('const Messages._();');

    final Map<int, Set<String>> all = {};
    final Set<String> allNawRuz = {};
    final Set<String> allRidvan = {};

    for (final (i, row) in rows.indexed) {
      final dateCol = row.find('td', class_: 'col-date')!;
      final title = row.find('td', class_: 'col-to')!.text;
      final summary = row.find('td', class_: 'col-summary')!.text;
      final uri = messagesUri.resolve(dateCol.find('a')!.getAttrValue('href')!);
      final url = uri.toString();
      final matches = datePattern.firstMatch(dateCol.text);
      if (matches == null) {
        throw UnimplementedError(
            'Cannot parse date format: ${dateCol.text}, for row $i: ${row.outerHtml}');
      }
      for (final name in matches.groupNames) {
        final text = matches.namedGroup(name);
        if (text == null) {
          continue;
        }

        final MessageBase message;
        switch (name) {
          case 'nawRuzCE':
            message = NawRuzMessage(
              ce: int.parse(text),
              title: title,
              summary: summary,
              url: url,
            );
          case 'nawRuzBE':
            message = NawRuzMessage(
              be: int.parse(text),
              title: title,
              summary: summary,
              url: url,
            );
          case 'ridvanCE':
            message = RidvanMessage(
              ce: int.parse(text),
              title: title,
              summary: summary,
              url: url,
            );
          case 'ridvanBE':
            message = RidvanMessage(
              be: int.parse(text),
              title: title,
              summary: summary,
              url: url,
            );
          case 'date':
            message = Message(
              date: dateFormat.parse(text),
              title: title,
              summary: summary,
              url: url,
            );
          case 'month':
            message = Message(
              date: monthFormat.parse(text),
              title: title,
              summary: summary,
              url: url,
            );

          /// TODO: Handle BadiDate parsing for potential future outliers
          /// This one seems to be a Naw Ruz message:
          case 'baha154':
            message = NawRuzMessage(
              be: 154,
              title: title,
              summary: summary,
              url: url,
            );

          default:
            throw UnimplementedError();
        }

        final String altDate = switch (message) {
          Message() => message.badiDate.dMMMMyyyBE(),
          _ => message.isBadiDate
              ? message.date.dMMMyyyy()
              : '${message.badiDate.year} B.E.',
        };

        final comments = <String>[
          '/// ${dateCol.text} ($altDate): $title',
          '/// $summary',
        ];

        final letter = seenLetter(message.date);
        final aliases = <String>{
          'ce${message.date.yyyyMMdd()}$letter',
          'be${message.badiDate.yyyMMdd()}$letter',
          if (message is NawRuzMessage) ...{
            'nawRuz${message.be}$letter',
            'nawRuz${message.ce}$letter',
          },
          if (message is RidvanMessage) ...{
            'ridvan${message.be}$letter',
            'ridvan${message.ce}$letter',
          },
        };

        all.putIfAbsent(message.be, () => {});
        all.putIfAbsent(message.ce, () => {});
        all[message.be]!.add('be${message.badiDate.yyyMMdd()}$letter');
        all[message.ce]!.add('ce${message.date.yyyyMMdd()}$letter');

        switch (message) {
          case NawRuzMessage():
            allNawRuz.add('nawRuz${message.be}$letter');
          case RidvanMessage():
            allRidvan.add('ridvan${message.be}$letter');
          case Message():
            break;
        }

        code.writeln();
        code.writeln(comments.join('\n'));
        code.writeln(
            'static final ${message.runtimeType} ${aliases.first} = ${message.toCode()};');
        for (final alias in aliases.skip(1)) {
          code.writeln();
          code.writeln(comments.join('\n'));
          code.writeln(
              'static final ${message.runtimeType} $alias = ${aliases.first};');
        }

        break;
      }
    }

    code.writeln();
    code.writeln('/// All Selected Universal House of Justice Messages');
    code.writeln(
        'static final Set<MessageBase> all = {${all.entries.where((e) => e.key > 1000).map((e) => e.value).expand((v) => v).join(',')},};');
    for (final be in all.keys.where((k) => k < 1000)) {
      code.writeln();
      code.writeln(
          '/// All Selected $be B.E. Universal House of Justice Messages');
      code.writeln(
          'static final Set<MessageBase> all$be = {${all[be]!.join(',')},};');
    }
    for (final ce in all.keys.where((k) => k > 1000)) {
      code.writeln();
      code.writeln(
          '/// All Selected $ce C.E. Universal House of Justice Messages');
      code.writeln(
          'static final Set<MessageBase> all$ce = {${all[ce]!.join(',')},};');
    }

    code.writeln();
    code.writeln(
        '/// All Selected Naw-Rúz Universal House of Justice Messages');
    code.writeln(
        'static final Set<NawRuzMessage> allNawRuz = {${allNawRuz.join(',')},};');

    code.writeln();
    code.writeln('/// All Selected Riḍván Universal House of Justice Messages');
    code.writeln(
        'static final Set<RidvanMessage> allRidvan = {${allRidvan.join(',')},};');

    code.writeln('}');

    final latest = seenDates.keys.max;

    final codeWithHeader = [
      '// GENERATED CODE - DO NOT MODIFY BY HAND',
      "import '/src/models/writings_base.dart';",
      '/// Selected Messages of the Universal House of Justice',
      '/// Latest: ${latest.dMMMyyyy()}',
      '/// Source: $messagesUri',
      code.toString(),
    ].join('\n');

    /// Create an idempotent build ID based on the latest publication date
    /// and count of publications on that date.
    /// This way, we can use both SemVer and CalVer!
    final latestCount = seenDates[latest]!;

    /// First publication build ID of a date will not end with a
    /// disambiguation letter. Second will end with `b`, third with `c`, etc.
    /// Letters should only appear when there are multiple publications
    /// on the latest date.
    /// Letters may be skipped on pub.dev.
    final buildLetter =
        latestCount == 1 ? '' : String.fromCharCode(latestCount + 96);

    final buildId = DateFormat('yyMMdd').format(latest) + buildLetter;

    final pubspec = PubSpec.load();
    final sv = pubspec.version.semVersion;
    final version = '${sv.major}.${sv.minor}.${sv.patch}+$buildId';
    pubspec.version.set(version);
    pubspec.save();

    final output = DartFormatter().format(codeWithHeader);

    return buildStep.writeAsString(assetId(buildStep), output);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': ['src/generated/messages.g.dart']
      };
}
