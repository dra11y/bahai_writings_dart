part of 'writings_base.dart';

enum GuardianWritings
    with WritingsAuthorTitleComparable
    implements WritingsBase {
  // ------------------------------------------------------------
  // Writings of Shoghi Effendi
  // ------------------------------------------------------------

  /// The Advent of Divine Justice (Shoghi Effendi):
  /// A letter written by Shoghi Effendi to the Bahá’ís of North America, dated 25 December 1938.
  adj(
    title: 'The Advent of Divine Justice',
    sortTitle: 'Advent of Divine Justice',
    summary:
        'A letter written by Shoghi Effendi to the Bahá’ís of North America, dated 25 December 1938.',
  ),

  /// Bahá’í Administration (Shoghi Effendi):
  /// A selection of letters and messages addressed to the Bahá’ís of the United States and Canada, written between January 1922 and July 1932.
  ba(
    title: 'Bahá’í Administration',
    summary:
        'A selection of letters and messages addressed to the Bahá’ís of the United States and Canada, written between January 1922 and July 1932.',
  ),

  /// Citadel of Faith (Shoghi Effendi):
  /// A collection of messages from Shoghi Effendi to the Bahá’ís of the United States, written between 1947 and 1957.
  cf(
    title: 'Citadel of Faith',
    summary:
        'A collection of messages from Shoghi Effendi to the Bahá’ís of the United States, written between 1947 and 1957.',
  ),

  /// God Passes By (Shoghi Effendi):
  /// A historical review by Shoghi Effendi of the first century of the Bahá’í Faith, published in 1944 on the occasion of the one-hundredth anniversary of the Declaration of the Báb.
  gpb(
    title: 'God Passes By',
    summary:
        'A historical review by Shoghi Effendi of the first century of the Bahá’í Faith, published in 1944 on the occasion of the one-hundredth anniversary of the Declaration of the Báb.',
  ),

  /// The Promised Day Is Come (Shoghi Effendi):
  /// A letter written by Shoghi Effendi to the Bahá’ís of the West, dated 28 March 1941.
  pdc(
    title: 'The Promised Day Is Come',
    sortTitle: 'Promised Day Is Come',
    summary:
        'A letter written by Shoghi Effendi to the Bahá’ís of the West, dated 28 March 1941.',
  ),

  /// This Decisive Hour (Shoghi Effendi):
  /// A collection of letters and cablegrams written by Shoghi Effendi to the North American Bahá’í community from 1932 to 1946, originally published under the title Messages to America.
  tdh(
    title: 'This Decisive Hour',
    summary:
        'A collection of letters and cablegrams written by Shoghi Effendi to the North American Bahá’í community from 1932 to 1946, originally published under the title Messages to America.',
  ),

  /// The World Order of Bahá’u’lláh (Shoghi Effendi):
  /// Seven letters written by Shoghi Effendi and addressed to the Bahá’ís of the United States and the West, first collected in 1938, comprising “The World Order of Bahá’u’lláh”, “The World Order of Bahá’u’lláh: Further Considerations”, “The Goal of a New World Order”, “The Golden Age of the Cause of Bahá’u’lláh”, “America and the Most Great Peace”, “The Dispensation of Bahá’u’lláh”, and “The Unfoldment of World Civilization”.
  wob(
    title: 'The World Order of Bahá’u’lláh',
    sortTitle: 'World Order of Bahá’u’lláh',
    summary:
        'Seven letters written by Shoghi Effendi and addressed to the Bahá’ís of the United States and the West, first collected in 1938, comprising “The World Order of Bahá’u’lláh”, “The World Order of Bahá’u’lláh: Further Considerations”, “The Goal of a New World Order”, “The Golden Age of the Cause of Bahá’u’lláh”, “America and the Most Great Peace”, “The Dispensation of Bahá’u’lláh”, and “The Unfoldment of World Civilization”.',
  );

  const GuardianWritings({
    required this.title,
    String? sortTitle,
    this.summary,
  })  : sortTitle = sortTitle ?? title,
        subtitle = null,
        isCompilation = false;

  @override
  final Set<Institution> authors = const {ShoghiEffendi()};

  @override
  Institution? get singleAuthor => authors.singleOrNull;

  @override
  final String title;

  @override
  final String sortTitle;

  @override
  final String? subtitle;

  @override
  final String? summary;

  @override
  final bool isCompilation;
}
