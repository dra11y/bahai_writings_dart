import 'dart:async';
import 'dart:convert';

import 'package:badi_date/badi_date.dart';
import 'package:bahai_writings/src/extensions/date_time_extension.dart';
import 'package:bahai_writings/src/models/date.dart';
import 'package:bahai_writings/src/models/writings_base.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
              id: row.id,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
        case _MessageType.ridvan:
          messages.add(RidvanMessage(
              id: row.id,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
        case _MessageType.message:
          messages.add(Message(
              id: row.id,
              title: title,
              date: date,
              badiDate: badiDate,
              summary: summary,
              url: url));
        case _MessageType.pwp:
          messages.add(PromiseOfWorldPeaceMessage(
              id: row.id,
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
