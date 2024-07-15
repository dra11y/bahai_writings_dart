import 'package:bahai_writings/src/extensions/string_extension.dart';
import 'package:collection/collection.dart';

sealed class Author implements Comparable<Author> {
  String get name;
  String get title;

  const Author();

  static Author? fromName(String name) {
    final String normalized = name.normalizedForSearch();
    return const <Author>[
      Bahaullah(),
      TheBab(),
      AbdulBaha(),
      ShoghiEffendi(),
      UHJ(),
    ].firstWhereOrNull((v) => v.name.normalizedForSearch() == normalized);
  }

  int get sortIndex => switch (this) {
        Bahaullah() => 0,
        TheBab() => 1,
        AbdulBaha() => 2,
        ShoghiEffendi() => 3,
        UHJ() => 4,
        NSA() => 5,
      };

  @override
  int compareTo(Author other) => sortIndex.compareTo(other.sortIndex);
}

sealed class CentralFigure extends Author {
  const CentralFigure();

  static const Set<CentralFigure> all = {Bahaullah(), TheBab(), AbdulBaha()};
}

sealed class Institution extends Author {
  const Institution();
}

final class Bahaullah extends CentralFigure {
  const Bahaullah();

  @override
  String get name => 'Bahá’u’lláh';

  @override
  String get title => 'The Glory of God';
}

final class TheBab extends CentralFigure {
  const TheBab();

  @override
  String get name => 'The Báb';

  @override
  String get title => 'The Gate';
}

final class AbdulBaha extends CentralFigure {
  const AbdulBaha();

  @override
  String get name => '‘Abdu’l-Bahá';

  @override
  String get title => 'The Master';
}

final class ShoghiEffendi extends Institution {
  const ShoghiEffendi();

  @override
  String get name => 'Shoghi Effendi';

  @override
  String get title => 'The Guardian';
}

final class UHJ extends Institution {
  const UHJ();

  @override
  String get name => 'The Universal House of Justice';

  @override
  String get title => name;
}

final class NSA extends Institution {
  const NSA(this.country);

  final String country;

  @override
  String get name => 'The National Spiritual Assembly of the Bahá’ís of ';

  @override
  String get title => name;
}
