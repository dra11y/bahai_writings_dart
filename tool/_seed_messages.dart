// DO NOT IMPORT THIS FILE!

// This file is to recover `messages.g.dart` in case lost so `build.dart` can run.
// To recover, copy this file to lib/src/generated/messages.g.dart

import 'dart:collection';

import 'package:bahai_writings/src/models/date.dart';
import 'package:bahai_writings/src/models/writings_base.dart';

/// EMPTY! Selected Messages of the Universal House of Justice
/// This class is a seed and contains no Messages.
class Messages {
  const Messages._();

  /// Statement to the first Bahá’í World Congress
  static final Date lastCE = Date(1963, 4, 30);

  static final UnmodifiableMapView<Date, Set<MessageBase>> allCE =
      UnmodifiableMapView({});
}
