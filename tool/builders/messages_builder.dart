import 'dart:async';

import 'package:badi_date/badi_date.dart';
import 'package:bahai_writings/src/extensions/badi_date_extension.dart';
import 'package:bahai_writings/src/extensions/date_time_extension.dart';
import 'package:bahai_writings/src/models/date.dart';
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

enum _MessageType {
  nawRuz,
  ridvan,
  message,
  pwp,
}

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
    final Map<Date, int> seenDates = {};
    String disambiguate(Date date) {
      final seenCount = seenDates[date];
      seenDates[date] = (seenCount ?? 0) + 1;
      if (seenCount == null) {
        return '';
      }
      return String.fromCharCode(seenCount + 97);
    }

    final List<MessageBase> messages = [];

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

        final Date date;
        final BadiDate badiDate;
        final _MessageType type;

        switch (name) {
          case 'nawRuzCE':
            type = _MessageType.nawRuz;
            final ce = int.parse(text);
            badiDate = BadiDate(year: ce - 1843, month: 1, day: 1);
            date = badiDate.startDateTime.date;
          case 'nawRuzBE':
            type = _MessageType.nawRuz;
            final be = int.parse(text);
            badiDate = BadiDate(year: be, month: 1, day: 1);
            date = badiDate.startDateTime.date;
          case 'ridvanCE':
            type = _MessageType.ridvan;
            final ce = int.parse(text);
            badiDate = BadiDate(year: ce - 1843, month: 2, day: 13);
            date = badiDate.startDateTime.date;
          case 'ridvanBE':
            type = _MessageType.ridvan;
            final be = int.parse(text);
            badiDate = BadiDate(year: be, month: 2, day: 13);
            date = badiDate.startDateTime.date;
          case 'date':
            type = _MessageType.message;
            final dateTime = dateFormat.parse(text);
            date = dateTime.date;
            badiDate = BadiDate.fromDate(dateTime);

          /// The Promise of World Peace
          case 'month':
            type = title.contains('Peoples of the World')
                ? _MessageType.pwp
                : _MessageType.message;
            final dateTime = monthFormat.parse(text);
            date = dateTime.date;
            badiDate = BadiDate.fromDate(dateTime);

          /// TODO: Handle BadiDate parsing for potential future outliers
          /// This one seems to be a Naw Ruz message:
          case 'baha154':
            type = _MessageType.nawRuz;
            badiDate = BadiDate(year: 154, month: 1, day: 1);
            date = badiDate.startDateTime.date;
          default:
            throw UnimplementedError();
        }

        switch (type) {
          case _MessageType.nawRuz:
            messages.add(NawRuzMessage(
                title: title,
                date: date,
                badiDate: badiDate,
                summary: summary,
                url: url));
          case _MessageType.ridvan:
            messages.add(RidvanMessage(
                title: title,
                date: date,
                badiDate: badiDate,
                summary: summary,
                url: url));
          case _MessageType.message:
            messages.add(Message(
                title: title,
                date: date,
                badiDate: badiDate,
                summary: summary,
                url: url));
          case _MessageType.pwp:
            messages.add(PromiseOfWorldPeaceMessage(
                title: title,
                date: date,
                badiDate: badiDate,
                summary: summary,
                url: url));
        }

        break;
      }
    }

    messages.sort();

    final Map<int, Set<String>> all = {};
    final Set<String> ridvan = {};
    final Set<String> nawRuz = {};

    final List<String> blocks = [];

    for (final message in messages) {
      final disamb = disambiguate(message.date);

      final addStandardRefs = message is! PromiseOfWorldPeaceMessage;

      final Set<String> refs = {};
      all[message.date.year] ??= {};
      all[message.badiDate.year] ??= {};

      if (addStandardRefs) {
        final ceRef = 'ce${message.date.yyyyMMdd()}$disamb';
        final beRef = 'be${message.badiDate.yyyMMdd()}$disamb';
        refs.add(ceRef);
        refs.add(beRef);
        all[message.date.year]!.add(ceRef);
        all[message.badiDate.year]!.add(beRef);
      }

      switch (message) {
        case RidvanMessage():
          final beRidvan = 'ridvan${message.badiDate.year}$disamb';
          final ceRidvan = 'ridvan${message.date.year}$disamb';
          refs.add(beRidvan);
          refs.add(ceRidvan);
          ridvan.add(beRidvan);
          break;

        case NawRuzMessage():
          final beNawRuz = 'nawRuz${message.badiDate.year}$disamb';
          final ceNawRuz = 'nawRuz${message.date.year}$disamb';
          refs.add(beNawRuz);
          refs.add(ceNawRuz);
          nawRuz.add(beNawRuz);
          break;

        case Message():
          break;

        case PromiseOfWorldPeaceMessage():
          final ceRef = 'ce198510';
          final pwpRef = 'pwp';
          refs.add(ceRef);
          refs.add(pwpRef);
          all[message.date.year]!.add(ceRef);
          all[message.badiDate.year]!.add(ceRef);

          break;
      }

      final String doc = [
        '/// ${message.formattedDate}: ${message.title}',
        '/// ${message.summary}',
      ].join('\n');

      final block = StringBuffer();

      block.writeln();
      block.writeln(doc);
      block.writeln('static final ${refs.first} = ${message.toCode()};');
      for (final ref in refs.skip(1)) {
        block.writeln(doc);
        block.writeln('static final $ref = ${refs.first};');
      }

      blocks.add(block.toString());
    }

    final code = StringBuffer()
      ..writeln('class Messages {')
      ..writeln('const Messages._();');

    code.writeln();

    code.writeAll(blocks.reversed);

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
        'static final Set<NawRuzMessage> allNawRuz = {${nawRuz.join(',')},};');

    code.writeln();
    code.writeln('/// All Selected Riḍván Universal House of Justice Messages');
    code.writeln(
        'static final Set<RidvanMessage> allRidvan = {${ridvan.join(',')},};');

    code.writeln('}');

    final latest = seenDates.keys.max;

    final codeWithHeader = [
      '// GENERATED CODE - DO NOT MODIFY BY HAND',
      "import 'package:badi_date/badi_date.dart';",
      "import '/src/models/date.dart';",
      "import '/src/models/writings_base.dart';",
      '/// Selected Messages of the Universal House of Justice',
      '/// Latest in this build: ${latest.dMMMyyyy()}',
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

    final buildId = DateFormat('yyMMdd').format(latest.dateTime) + buildLetter;

    final pubspec = PubSpec.load();
    final sv = pubspec.version.semVersion;
    final versionString = '${sv.major}.${sv.minor}.${sv.patch}+$buildId';
    final version = pubspec.version.set(versionString).semVersion;
    pubspec.save();

    // final file = File('CHANGELOG.md');
    // final log = parseChangelog(file.readAsStringSync());

    // final release = Release(version, DateTime.now());
    // final change = Change('Added', description);
    // release.add(change);
    // log.add(release);

    final output = DartFormatter().format(codeWithHeader);

    return buildStep.writeAsString(assetId(buildStep), output);
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        r'$lib$': ['src/generated/messages.g.dart']
      };
}
