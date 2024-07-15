import 'package:diacritic/diacritic.dart';

final _nonAlphaNumeric = RegExp(r'[^\w_]');

extension StringExtension on String {
  String normalizedForSearch() =>
      removeDiacritics(this).replaceAll(_nonAlphaNumeric, '');
  String escapeSingle() => replaceAll(r"'", r"\'");
}
