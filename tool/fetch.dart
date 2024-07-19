import 'dart:io';

import 'package:bahai_writings/src/generated/messages.g.dart';
import 'package:bahai_writings/src/models/date.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'fetch/fetch_message.dart';
import 'logger.dart';

Future<void> main() async {
  final List<String> libraryUrls = [];
  final Map<int, Set<String>> ids = {};
  for (int year = Messages.firstCE.year; year <= Messages.lastCE.year; year++) {
    // for (int year = 1997; year == 1997; year++) {
    logger.info('Fetching available $year UHJ Messages content ...');
    final boy = Date(year, 1, 1);
    ids[year] = {};
    final messages = Messages.ceRange(boy, boy.endOfYear);
    final Map<String, String> map = {};
    for (final message in messages) {
      ids[year]!.add(message.id);

      try {
        map[message.id] =
            message.content.replaceAll(r'\', r'\\').replaceAll(r'$', r'\$');
        logger.debug('Content for ${message.id} already exists, skipping.');
        continue;
      } catch (e) {
        if (e is! UnimplementedError) {
          rethrow;
        }
      }

      map[message.id] = await fetchMessage(message);
    }

    final library = Library((lib) => lib
      ..body.add(
        declareFinal('messages$year',
                type: refer((Map<String, String>).toString()))
            .assign(
              literalMap(map),
            )
            .statement,
      ));

    final emitter = DartEmitter(useNullSafetySyntax: true);
    final unformatted = library.accept(emitter).toString();
    final code = DartFormatter().format(unformatted);

    final libraryUrl = '/src/generated/messages_content.$year.g.dart';
    libraryUrls.add(libraryUrl);

    final file = File('lib$libraryUrl');
    await file.writeAsString(code);

    logger.success('Wrote $year library file: ${file.path}');
  }

  final library = Library((lib) => lib
    ..directives.addAll([
      // Directive.import('/src/models/message_content.dart'),
      // Directive.import('/src/models/writings_base.dart'),
      for (final url in libraryUrls) Directive.import(url),
    ])
    ..body.add(
      Mixin(
        (ext) => ext
          ..name = 'MessageContentMixin'
          ..methods.addAll([
            Method(
              (m) => m
                ..name = 'id'
                ..returns = refer((String).toString())
                ..type = MethodType.getter,
            ),
            Method(
              (m) => m
                ..name = 'content'
                ..lambda = true
                ..returns = refer((String).toString())
                ..type = MethodType.getter
                ..body = Code([
                  'switch (id) {',
                  for (final year in ids.keys)
                    for (final id in ids[year]!)
                      "'$id' => messages$year['$id']!,",
                  '_ => throw UnimplementedError(),',
                  '}',
                ].join('\n')),
            ),
          ]),
      ),
    ));

  final emitter = DartEmitter(useNullSafetySyntax: true);
  final code = DartFormatter().format(library.accept(emitter).toString());

  final libraryUrl = '/src/generated/messages_content.g.dart';
  libraryUrls.add(libraryUrl);

  final file = File('lib$libraryUrl');
  await file.writeAsString(code.toString());

  logger.success('Wrote main extension library file: ${file.path}');
}
