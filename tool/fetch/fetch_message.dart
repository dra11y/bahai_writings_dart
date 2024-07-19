import 'dart:convert';

import 'package:bahai_writings/src/models/writings_base.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:http/http.dart' as http;
import 'package:html2md/html2md.dart' as html2md;

import '../logger.dart';

Future<String> fetchMessage(MessageBase message) async {
  final uri = Uri.parse(message.url).resolve('${message.id}.xhtml');
  logger.info(
      'Fetching message HTML for: ${message.formattedDateTitle} from $uri ...');
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception(
        'Failed to load message; statusCode: ${response.statusCode}');
  }
  final body = utf8.decode(response.bodyBytes);
  final BeautifulSoup bs = BeautifulSoup(body);
  final main = bs.body!.find('div')!;
  final md = html2md
      .convert(
        main.element!,
        rules: [
          html2md.Rule(
            'cite',
            filterFn: (node) {
              // logger.warn('nodeName = ${node.nodeName}');
              return node.nodeName == 'cite';
            },
            replacement: (content, node) => '**$content**',
          ),
        ],
      )
      .replaceAll(r'\', r'\\')
      .replaceAll(r'$', r'\$');
  return md;
}
