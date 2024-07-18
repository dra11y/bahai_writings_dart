import 'dart:async';
import 'dart:convert';

import 'package:badi_date/badi_date.dart';
import 'package:bahai_writings/src/extensions/date_time_extension.dart';
import 'package:bahai_writings/src/models/date.dart';
import 'package:bahai_writings/src/models/writings_base.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;

import '../logger.dart';

enum _MessageType {
  nawRuz,
  ridvan,
  message,
  pwp,
}

final Uri messagesUri = Uri.parse(
    'https://www.bahai.org/library/authoritative-texts/the-universal-house-of-justice/messages/');

Future<List<MessageBase>> fetchMessages() async {
  logger.info('Fetching UHJ Messages from $messagesUri ...');
  final response = await http.get(messagesUri);
  if (response.statusCode != 200) {
    throw Exception(
        'Failed to load UHJ Messages: statusCode ${response.statusCode} from $messagesUri');
  }
  logger.success('Fetch OK.');
  if (response.body.isEmpty) {
    throw Exception(
        'Failed to load UHJ Messages: body is empty from $messagesUri');
  }
  logger.info('Parsing HTML ...');
  final body = utf8.decode(response.bodyBytes);
  final BeautifulSoup bs = BeautifulSoup(body);
  final table = bs.find('table');
  if (table == null) {
    throw Exception('Could not find <table> element');
  }
  logger.success('Parse HTML OK.');
  logger.info('Finding messages ...');
  final rows = table.findAll('tr', class_: 'document-row');
  // final DateFormat dateFormat = DateFormat('d MMMM yyyy');
  // final DateFormat monthFormat = DateFormat('MMMM yyyy');
  final datePattern = RegExp(
    r'Naw-Rúz ((?<nawRuzCE>\d{4})|(?<nawRuzBE>\d{3}))'
    r'|Riḍván ((?<ridvanCE>\d{4})|(?<ridvanBE>\d{3}))'
    r'|(?<date>\d\d? [a-z]{3,} \d{4})'
    r'|(?<month>[a-z]{3,} \d{4})'
    '|(?<baha154>Bahá 154 B.E.)',
    caseSensitive: false,
  );

  final List<MessageBase> messages = [];

  final idPattern =
      RegExp(r'(?<year>\d{4})(?<month>\d{2})(?<day>\d{2})_(?<index>\d{3})');

  for (final (i, row) in rows.indexed) {
    final idMatch = idPattern.firstMatch(row.id);
    if (idMatch == null) {
      throw Exception('No id match for row $i: ${row.outerHtml}');
    }
    for (final name in idMatch.groupNames) {
      if (idMatch.namedGroup(name) == null) {
        throw Exception(
            'row $i id: ${row.id} failed to match for group: "$name"');
      }
    }
    final Date date = DateTime.parse(
            '${idMatch.namedGroup('year')!}-${idMatch.namedGroup('month')!}-${idMatch.namedGroup('day')!}')
        .date;
    final BadiDate badiDate = BadiDate.fromDate(date.utc);
    final number = int.parse(idMatch.namedGroup('index')!);
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

      final _MessageType type = switch (name) {
        'nawRuzCE' => _MessageType.nawRuz,
        'nawRuzBE' => _MessageType.nawRuz,
        'ridvanCE' => _MessageType.ridvan,
        'ridvanBE' => _MessageType.ridvan,
        'date' => _MessageType.message,
        'month' => title.contains('Peoples of the World')
            ? _MessageType.pwp
            : _MessageType.message,
        'baha154' => _MessageType.nawRuz,
        _ => throw UnimplementedError(),
      };

      switch (type) {
        case _MessageType.nawRuz:
          messages.add(NawRuzMessage(
              id: row.id,
              number: number,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
        case _MessageType.ridvan:
          messages.add(RidvanMessage(
              id: row.id,
              number: number,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
        case _MessageType.message:
          messages.add(Message(
              id: row.id,
              number: number,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
        case _MessageType.pwp:
          messages.add(PromiseOfWorldPeaceMessage(
              id: row.id,
              number: number,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
      }

      break;
    }
  }

  logger.success('Found ${messages.length} messages.');

  return messages..sort();
}
