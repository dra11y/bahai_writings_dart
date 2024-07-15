// build_runner terminates after change to pubspec.yaml #2638
// https://github.com/dart-lang/build/issues/2638

import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main(_) async {
  while (true) {
    final process =
        await Process.start('dart', ['run', 'build_runner', 'watch', '-d']);

    unawaited(process.stdout.transform(utf8.decoder).forEach(stdout.write));
    unawaited(process.stderr.transform(utf8.decoder).forEach(stderr.write));
    await process.exitCode;
  }
}
