import 'dart:async';
import 'dart:io';

import 'package:badi_date/badi_date.dart';
import 'package:bahai_writings/src/extensions/badi_date_extensions.dart';
import 'package:bahai_writings/src/extensions/date_time_extension.dart';
import 'package:bahai_writings/src/generated/messages.g.dart';
import 'package:bahai_writings/src/models/date.dart';
import 'package:bahai_writings/src/models/writings_base.dart';
import 'package:change/change.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart';
import 'package:pubspec_manager/pubspec_manager.dart';

import 'build/fetch_messages.dart';
import 'build/logger.dart';

Future<void> main() async {
  final messages = await fetchMessages();

  final previousMessages = Messages.allCE.values.expand((m) => m).toList();
  final newMessages =
      messages.whereNot((m) => previousMessages.contains(m)).toList()..sort();

  logger.info('Generating code ...');

  final Map<Date, int> seenDates = {};
  String disambiguate(Date date) {
    final seenCount = seenDates[date];
    seenDates[date] = (seenCount ?? 0) + 1;
    if (seenCount == null) {
      return '';
    }
    return String.fromCharCode(seenCount + 97);
  }

  final Map<Date, Set<String>> allCE = {};
  final Map<BadiDate, Set<String>> allBE = {};
  final Set<String> ridvan = {};
  final Set<String> nawRuz = {};

  final List<String> blocks = [];

  for (final message in messages) {
    final disamb = disambiguate(message.date);

    final addStandardRefs = message is! PromiseOfWorldPeaceMessage;

    final Set<String> refs = {};
    allCE[message.date] ??= {};
    allBE[message.badiDate] ??= {};

    if (addStandardRefs) {
      final ceRef = 'ce${message.date.yyyyMMdd()}$disamb';
      final beRef = 'be${message.badiDate.yyyMMdd()}$disamb';
      refs.add(ceRef);
      refs.add(beRef);
      allCE[message.date]!.add(ceRef);
      allBE[message.badiDate]!.add(beRef);
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
        allCE[message.date]!.add(ceRef);
        allBE[message.badiDate]!.add(ceRef);

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

  final firstCE = allCE.keys.min;
  final firstBE = allBE.keys.min;
  final lastCE = allCE.keys.max;
  final lastBE = allBE.keys.max;

  code.writeln('''
        /// All Selected Universal House of Justice Messages by Gregorian Date
        static final UnmodifiableMapView<Date, Set<MessageBase>> allCE = UnmodifiableMapView({${allCE.entries.map((e) => '${e.key.toCode()}: ${e.value}').join(',')},});
        
        /// All Selected Universal House of Justice Messages by Badi Date
        static final UnmodifiableMapView<BadiDate, Set<MessageBase>> allBE = UnmodifiableMapView({${allBE.entries.map((e) => '${e.key.toCode()}: ${e.value}').join(',')},});

        /// All Selected Naw-Rúz Universal House of Justice Messages
        static final UnmodifiableSetView<NawRuzMessage> allNawRuz = UnmodifiableSetView({${nawRuz.join(',')},});

        /// All Selected Riḍván Universal House of Justice Messages
        static final UnmodifiableSetView<RidvanMessage> allRidvan = UnmodifiableSetView({${ridvan.join(',')},});

        /// The first [BadiDate] with messages in the current build
        static final BadiDate firstBE = ${firstBE.toCode()};

        /// The last [BadiDate] with messages in the current build
        static final BadiDate lastBE = ${lastBE.toCode()};

        /// The first Gregorian [Date] with messages in the current build
        static final Date firstCE = ${firstCE.toCode()};

        /// The last Gregorian [Date] with messages in the current build
        static final Date lastCE = ${lastCE.toCode()};

        /// Get the set of available messages in this build that were
        /// published on the given [BadiDate] (null if none)
        static UnmodifiableSetView<MessageBase>? be(BadiDate badiDate) {
          final Set<MessageBase>? set = allBE[badiDate];
          if (set != null) {
            return UnmodifiableSetView(set);
          }
          return null;
        }

        /// Get the set of available messages in this build that were
        /// published on the given Gregorian [Date] (null if none)
        static UnmodifiableSetView<MessageBase>? ce(Date date) {
          final Set<MessageBase>? set = allCE[date];
          if (set != null) {
            return UnmodifiableSetView(set);
          }
          return null;
        }

        /// Get the set of available messages in this build that were
        /// published within the given [BadiDate] range (empty if none)
        static UnmodifiableSetView<MessageBase> beRange(
            [BadiDate? start, BadiDate? end]) {
          start ??= firstBE;
          end ??= lastBE;
          if (start.compareTo(end) > 0) {
            final temp = start;
            start = end;
            end = temp;
          }
          final Set<MessageBase> set = {};
          for (final e in allBE.entries) {
            if (e.key.compareTo(start) >= 0 && e.key.compareTo(end) <= 0) {
              set.addAll(e.value);
            }
          }
          return UnmodifiableSetView(set);
        }

        /// Get the set of available messages in this build that were
        /// published within the given Gregorian [Date] range (empty if none)
        static UnmodifiableSetView<MessageBase> ceRange([Date? start, Date? end]) {
          start ??= firstCE;
          end ??= lastCE;
          if (start.compareTo(end) > 0) {
            final temp = start;
            start = end;
            end = temp;
          }
          final Set<MessageBase> set = {};
          for (final e in allCE.entries) {
            if (e.key.compareTo(start) >= 0 && e.key.compareTo(end) <= 0) {
              set.addAll(e.value);
            }
          }
          return UnmodifiableSetView(set);
        }
    ''');

  code.writeln('}');

  final latest = seenDates.keys.max;

  final codeWithHeader = [
    '// GENERATED CODE - DO NOT MODIFY BY HAND\n',
    '// DO NOT DELETE THIS FILE because tool/build.dart depends on it!\n',
    "import 'package:badi_date/badi_date.dart';",
    "import 'package:collection/collection.dart';",
    "import '/src/extensions/badi_date_extensions.dart';",
    "import '/src/models/date.dart';",
    "import '/src/models/writings_base.dart';\n",
    '/// Selected Messages of the Universal House of Justice',
    '/// Latest in this build: ${latest.dMMMyyyy()}',
    '/// Source: $messagesUri',
    code.toString(),
  ].join('\n');

  final output = DartFormatter().format(codeWithHeader);
  final outFile = File('lib/src/generated/messages.g.dart');
  final existingOutput = await outFile.readAsString();

  if (output == existingOutput && newMessages.isEmpty) {
    logger.success('No changes.');
    return;
  }

  await outFile.writeAsString(output);

  final bumpMinor = newMessages.isEmpty;

  if (bumpMinor) {
    logger.warn('CODE FORMAT CHANGED -- Edit CHANGELOG!');
  } else {
    logger.success('Code generation OK.');
  }

  logger.info('Reading pubspec.yaml and CHANGELOG ...');

  final pubspec = PubSpec.load();
  final sv = pubspec.version.semVersion;
  final currentVersion = sv.toString();

  logger.info('Current version: $currentVersion');

  final changelogFile = File('CHANGELOG.md');
  final changelog = parseChangelog(changelogFile.readAsStringSync());

  String buildId = DateFormat('yyyyMMdd').format(latest.dateTime);
  final String newBaseVersion =
      '${sv.major}.${bumpMinor ? sv.minor + 1 : sv.minor}.${sv.patch}+$buildId';
  String newVersion = newBaseVersion;
  while (newVersion == currentVersion || changelog.has(newVersion)) {
    logger.warn('Version conflict: $newVersion');
    final String currentLetter =
        RegExp(r'[a-z]$').stringMatch(newVersion) ?? 'a';
    final newLetter = String.fromCharCode(currentLetter.codeUnitAt(0) + 1);
    newVersion = newBaseVersion + newLetter;
  }

  logger.info('New version: $newVersion');

  final version = pubspec.version.set(newVersion).semVersion;
  pubspec.save();

  logger.success('Update pubspec.yaml OK.');

  logger.info('Updating CHANGELOG ...');
  final release = Release(version, DateTime.now());
  final changes = newMessages.reversed.map((m) => Change(
      'Added', [Text('${m.runtimeType}: ${m.formattedDate}: ${m.title}')]));
  release.addAll(changes);
  changelog.add(release);

  await changelogFile.writeAsString(printChangelog(changelog));

  logger.success('Update CHANGELOG OK.');
  if (bumpMinor) {
    logger.error(
        'MINOR VERSION BUMPED! Check and edit CHANGELOG as needed. NO AUTO-RELEASE.');
    exit(1);
  }

  logger.success('Build OK.');
}
