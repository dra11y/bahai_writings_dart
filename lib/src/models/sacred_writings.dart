part of 'writings_base.dart';

enum SacredWritings with WritingsAuthorTitleComparable implements WritingsBase {
  // ------------------------------------------------------------
  // Compilations
  // ------------------------------------------------------------

  /// Bahá’í Prayers:
  /// A Selection of Prayers Revealed by Bahá’u’lláh, the Báb, and ‘Abdu’l‑Bahá
  prayers(
    authors: CentralFigure.all,
    title: 'Bahá’í Prayers',
    subtitle:
        'A Selection of Prayers Revealed by Bahá’u’lláh, the Báb, and ‘Abdu’l‑Bahá',
    isCompilation: true,
    summary: 'Compiled by the United States Bahá’í Publishing Trust',
  ),

  // ------------------------------------------------------------
  // Writings of the Báb
  // ------------------------------------------------------------

  /// Selections from the Writings of the Báb
  /// A collection of excerpts from books and Tablets revealed by the Báb, including the Qayyúmu’l-Asmá’ (Commentary on the Súrih of Joseph), the Persian Bayán, Dalá’il-i-Sab‘ih (the Seven Proofs), the Kitáb-i-Asmá’ (the Book of Names), and various other Writings. It was first published in an authorized English translation in 1976.
  swb(
    authors: {TheBab()},
    title: 'Selections from the Writings of the Báb',
    summary:
        'A collection of excerpts from books and Tablets revealed by the Báb, including the Qayyúmu’l-Asmá’ (Commentary on the Súrih of Joseph), the Persian Bayán, Dalá’il-i-Sab‘ih (the Seven Proofs), the Kitáb-i-Asmá’ (the Book of Names), and various other Writings. It was first published in an authorized English translation in 1976.',
  ),

  // ------------------------------------------------------------
  // Writings of Bahá’u’lláh
  // ------------------------------------------------------------

  /// The Call of the Divine Beloved (Bahá’u’lláh):
  /// Seven Tablets revealed by Bahá’u’lláh on mystical themes, including the poem Rashḥ-i-‘Amá and new translations of the Seven Valleys and the Four Valleys.
  cdb(
    authors: {Bahaullah()},
    title: 'The Call of the Divine Beloved',
    sortTitle: 'Call of the Divine Beloved',
    subtitle: 'Selected Mystical Works of Bahá’u’lláh',
    summary:
        'Seven Tablets revealed by Bahá’u’lláh on mystical themes, including the poem Rashḥ-i-‘Amá and new translations of the Seven Valleys and the Four Valleys.',
  ),

  /// Epistle to the Son of the Wolf (Bahá’u’lláh):
  /// A Tablet addressed to Shaykh Muhammad-Taqiy-i-Najafi, a prominent Muslim cleric who had persecuted the Bahá’ís. It was revealed around 1891 at the Mansion of Bahjí and translated by Shoghi Effendi.
  esw(
    authors: {Bahaullah()},
    title: 'Epistle to the Son of the Wolf',
    summary:
        'A Tablet addressed to Shaykh Muhammad-Taqiy-i-Najafi, a prominent Muslim cleric who had persecuted the Bahá’ís. It was revealed around 1891 at the Mansion of Bahjí and translated by Shoghi Effendi.',
  ),

  /// Gems of Divine Mysteries (Bahá’u’lláh):
  /// An epistle revealed by Bahá’u’lláh in Arabic during his exile in Baghdad, in reply to questions from Siyyid Yusuf-i-Sidihi Isfahani.
  gdm(
    authors: {Bahaullah()},
    title: 'Gems of Divine Mysteries',
    subtitle: 'Javáhiru’l-Asrár',
    summary:
        'An epistle revealed by Bahá’u’lláh in Arabic during his exile in Baghdad, in reply to questions from Siyyid Yusuf-i-Sidihi Isfahani.',
  ),

  /// Gleanings from the Writings of Bahá’u’lláh:
  /// A selection of passages from the Writings of Bahá’u’lláh, compiled and translated by Shoghi Effendi, including extracts from Epistle to the Son of the Wolf, the Kitáb-i-Íqán, and the Kitáb-i-Aqdas, as well as other Tablets.
  gwb(
    authors: {Bahaullah()},
    title: 'Gleanings from the Writings of Bahá’u’lláh',
    summary:
        'A selection of passages from the Writings of Bahá’u’lláh, compiled and translated by Shoghi Effendi, including extracts from Epistle to the Son of the Wolf, the Kitáb-i-Íqán, and the Kitáb-i-Aqdas, as well as other Tablets.',
  ),

  /// The Hidden Words (Bahá’u’lláh):
  /// A work consisting of short passages revealed by Bahá’u’lláh in Persian and Arabic in 1857/58 during His exile in Baghdad, translated by Shoghi Effendi.
  hw(
    authors: {Bahaullah()},
    title: 'The Hidden Words',
    sortTitle: 'Hidden Words',
    summary:
        'A work consisting of short passages revealed by Bahá’u’lláh in Persian and Arabic in 1857/58 during His exile in Baghdad, translated by Shoghi Effendi.',
  ),

  /// The Kitáb-i-Aqdas (Bahá’u’lláh):
  /// Bahá’u’lláh’s book of laws, written in Arabic around 1873 while He was still imprisoned within the city of ‘Akká. It was supplemented by later Writings and by Bahá’u’lláh’s replies to a series of questions posed by one of His secretaries. The first authorized English translation was published in 1992, annotated and accompanied by the supplementary Writings and the questions and answers.
  ka(
    authors: {Bahaullah()},
    title: 'The Kitáb-i-Aqdas',
    sortTitle: 'Kitáb-i-Aqdas',
    subtitle: 'The Most Holy Book',
    summary:
        'Bahá’u’lláh’s book of laws, written in Arabic around 1873 while He was still imprisoned within the city of ‘Akká. It was supplemented by later Writings and by Bahá’u’lláh’s replies to a series of questions posed by one of His secretaries. The first authorized English translation was published in 1992, annotated and accompanied by the supplementary Writings and the questions and answers.',
  ),

  /// The Kitáb-i-Íqán (Bahá’u’lláh):
  /// A treatise revealed by Bahá’u’lláh in Baghdad in 1861/62 in response to questions posed by one of the maternal uncles of the Báb, translated by Shoghi Effendi and first published in English in 1931.
  ki(
    authors: {Bahaullah()},
    title: 'The Kitáb-i-Íqán',
    sortTitle: 'Kitáb-i-Íqán',
    subtitle: 'The Book of Certitude',
    summary:
        'A treatise revealed by Bahá’u’lláh in Baghdad in 1861/62 in response to questions posed by one of the maternal uncles of the Báb, translated by Shoghi Effendi and first published in English in 1931.',
  ),

  /// Prayers and Meditations by Bahá’u’lláh:
  /// A selection of prayers and meditations revealed by Bahá’u’lláh, compiled and translated by Shoghi Effendi and first published in 1938.
  pm(
    authors: {Bahaullah()},
    title: 'Prayers and Meditations by Bahá’u’lláh',
    sortTitle: 'Prayers and Meditations',
    summary:
        'A selection of prayers and meditations revealed by Bahá’u’lláh, compiled and translated by Shoghi Effendi and first published in 1938.',
  ),

  /// The Summons of the Lord of Hosts (Bahá’u’lláh):
  /// Six works comprising letters written by Bahá’u’lláh during His exile in Adrianople and the early years of His banishment to ‘Akká, addressed to the monarchs and leaders of His time, including Napoleon III of France, Czar Alexander II of Russia, Queen Victoria of England, Nasiri’d-Din Shah of Persia, and Pope Pius IX.
  slh(
    authors: {Bahaullah()},
    title: 'The Summons of the Lord of Hosts',
    sortTitle: 'Summons of the Lord of Hosts',
    summary:
        'Six works comprising letters written by Bahá’u’lláh during His exile in Adrianople and the early years of His banishment to ‘Akká, addressed to the monarchs and leaders of His time, including Napoleon III of France, Czar Alexander II of Russia, Queen Victoria of England, Nasiri’d-Din Shah of Persia, and Pope Pius IX.',
  ),

  /// The Tabernacle of Unity (Bahá’u’lláh):
  /// Five Tablets addressed to individuals of Zoroastrian background, including two letters responding to questions posed by the Parsi Zoroastrian scholar and philanthropist Manikchi Sahib, as well as the Tablet of the Seven Questions and two other Tablets.
  tu(
    authors: {Bahaullah()},
    title: 'The Tabernacle of Unity',
    sortTitle: 'Tabernacle of Unity',
    summary:
        'Five Tablets addressed to individuals of Zoroastrian background, including two letters responding to questions posed by the Parsi Zoroastrian scholar and philanthropist Manikchi Sahib, as well as the Tablet of the Seven Questions and two other Tablets.',
  ),

  /// Tablets of Bahá’u’lláh revealed after the Kitáb-i-Aqdas:
  /// Sixteen Tablets revealed by Bahá’u’lláh during the later years of His life, including the Tablet of Carmel, the Book of the Covenant, and the Tablet of Wisdom, as well as excerpts from other Writings.
  tb(
    authors: {Bahaullah()},
    title: 'Tablets of Bahá’u’lláh revealed after the Kitáb-i-Aqdas',
    sortTitle: 'Tablets of Bahá’u’lláh',
    summary:
        'Sixteen Tablets revealed by Bahá’u’lláh during the later years of His life, including the Tablet of Carmel, the Book of the Covenant, and the Tablet of Wisdom, as well as excerpts from other Writings.',
  ),

  // ------------------------------------------------------------
  // Writings and Talks of ‘Abdu’l‑Bahá
  // ------------------------------------------------------------

  /// Light of the World (‘Abdu’l‑Bahá):
  /// Tablets of ‘Abdul-Bahá describing aspects of the life of Bahá’u’lláh including the tribulations He suffered, events in His homeland, the purpose and greatness of His Cause, and the nature and significance of His Covenant.
  low(
    authors: {AbdulBaha()},
    title: 'Light of the World',
    subtitle: 'Selected Tablets of ‘Abdu’l‑Bahá',
    summary:
        'Tablets of ‘Abdul-Bahá describing aspects of the life of Bahá’u’lláh including the tribulations He suffered, events in His homeland, the purpose and greatness of His Cause, and the nature and significance of His Covenant.',
  ),

  /// Memorials of the Faithful (‘Abdu’l‑Bahá):
  /// Eulogies of some eighty early Bahá’ís transcribed from a series of talks given by ‘Abdu’l‑Bahá in Haifa around 1914–15. The Persian transcripts were later corrected by ‘Abdu’l‑Bahá and compiled into a single volume, published in 1924. An English translation was published in 1971.
  mf(
    authors: {AbdulBaha()},
    title: 'Memorials of the Faithful',
    summary:
        'Eulogies of some eighty early Bahá’ís transcribed from a series of talks given by ‘Abdu’l‑Bahá in Haifa around 1914–15. The Persian transcripts were later corrected by ‘Abdu’l‑Bahá and compiled into a single volume, published in 1924. An English translation was published in 1971.',
  ),

  /// Paris Talks (‘Abdu’l‑Bahá):
  /// A compilation of talks given by ‘Abdu’l‑Bahá during His first stay in Paris, from October to December 1911. Also included are three talks delivered during visits to England in 1912–13 and a Tablet revealed in 1913.
  pt(
    authors: {AbdulBaha()},
    title: 'Paris Talks',
    summary:
        'A compilation of talks given by ‘Abdu’l‑Bahá during His first stay in Paris, from October to December 1911. Also included are three talks delivered during visits to England in 1912–13 and a Tablet revealed in 1913.',
  ),

  /// The Promulgation of Universal Peace (‘Abdu’l‑Bahá):
  /// A collection of transcriptions of over one hundred talks delivered by ‘Abdu’l‑Bahá during the nine months in 1912 when He travelled across the United States and Canada.
  pup(
    authors: {AbdulBaha()},
    title: 'The Promulgation of Universal Peace',
    sortTitle: 'Promulgation of Universal Peace',
    summary:
        'A collection of transcriptions of over one hundred talks delivered by ‘Abdu’l‑Bahá during the nine months in 1912 when He travelled across the United States and Canada.',
  ),

  /// The Secret of Divine Civilization (‘Abdu’l‑Bahá):
  /// A treatise written by ‘Abdu’l‑Bahá in Persian in 1875, addressed to the rulers and people of Persia. It was printed in Bombay in 1882 and widely circulated in Iran. This English translation was first published in 1957.
  sdc(
    authors: {AbdulBaha()},
    title: 'The Secret of Divine Civilization',
    sortTitle: 'Secret of Divine Civilization',
    summary:
        'A treatise written by ‘Abdu’l‑Bahá in Persian in 1875, addressed to the rulers and people of Persia. It was printed in Bombay in 1882 and widely circulated in Iran. This English translation was first published in 1957.',
  ),

  /// Selections from the Writings of ‘Abdu’l‑Bahá:
  /// A treatise written by ‘Abdu’l‑Bahá in Persian in 1875, addressed to the rulers and people of Persia. It was printed in Bombay in 1882 and widely circulated in Iran. This English translation was first published in 1957.
  swa(
    authors: {AbdulBaha()},
    title: 'Selections from the Writings of ‘Abdu’l‑Bahá',
    summary:
        'A collection of English translations of more than two hundred letters, prayers, and other Writings by ‘Abdu’l‑Bahá, first published in 1978.',
  ),

  /// Some Answered Questions (‘Abdu’l‑Bahá):
  /// A collection of transcriptions of table talks given by ‘Abdu’l‑Bahá in ‘Akká between 1904 and 1906 in response to questions posed by Laura Dreyfus-Barney, an American Bahá’í resident in Paris, and first published in 1908. The new edition, extensively retranslated, was published in 2014.
  saq(
    authors: {AbdulBaha()},
    title: 'Some Answered Questions',
    summary:
        'A collection of transcriptions of table talks given by ‘Abdu’l‑Bahá in ‘Akká between 1904 and 1906 in response to questions posed by Laura Dreyfus-Barney, an American Bahá’í resident in Paris, and first published in 1908. The new edition, extensively retranslated, was published in 2014.',
  ),

  /// Tablet to Dr. Auguste Forel (‘Abdu’l‑Bahá):
  /// A letter written by ‘Abdu’l‑Bahá in 1921 in reply to a letter from Professor Auguste Forel, a Swiss psychiatrist.
  taf(
    authors: {AbdulBaha()},
    title: 'Tablet to Dr. Auguste Forel',
    summary:
        'A letter written by ‘Abdu’l‑Bahá in 1921 in reply to a letter from Professor Auguste Forel, a Swiss psychiatrist.',
  ),

  /// Tablets of the Divine Plan (‘Abdu’l‑Bahá):
  /// Fourteen letters addressed by ‘Abdu’l‑Bahá to the North American Bahá’í community as a whole as well as by region—Canada and the Northeastern, Southern, Central, and Western United States. The first eight letters were written between 26 March and 22 April 1916, the remainder between 2 February and 8 March 1917.
  tdp(
    authors: {AbdulBaha()},
    title: 'Tablets of the Divine Plan',
    summary:
        'Fourteen letters addressed by ‘Abdu’l‑Bahá to the North American Bahá’í community as a whole as well as by region—Canada and the Northeastern, Southern, Central, and Western United States. The first eight letters were written between 26 March and 22 April 1916, the remainder between 2 February and 8 March 1917.',
  ),

  /// Tablets to The Hague (‘Abdu’l‑Bahá):
  /// Two letters of ‘Abdu’l‑Bahá written in response to letters addressed to Him by the Executive Committee of the Central Organization for a Durable Peace.
  tth(
    authors: {AbdulBaha()},
    title: 'Tablets to The Hague',
    summary:
        'Two letters of ‘Abdu’l‑Bahá written in response to letters addressed to Him by the Executive Committee of the Central Organization for a Durable Peace.',
  ),

  /// A Traveler’s Narrative (‘Abdu’l‑Bahá):
  /// A historical account written by ‘Abdu’l‑Bahá around 1886 and first published anonymously in Persian in 1890. The English translation was prepared by Professor Edward G. Browne and first published by Cambridge University Press in 1891.
  tn(
    authors: {AbdulBaha()},
    title: 'A Traveler’s Narrative',
    sortTitle: 'Traveler’s Narrative',
    summary:
        'A historical account written by ‘Abdu’l‑Bahá around 1886 and first published anonymously in Persian in 1890. The English translation was prepared by Professor Edward G. Browne and first published by Cambridge University Press in 1891.',
  ),

  /// Twelve Table Talks given by ‘Abdu’l‑Bahá in ‘Akká:
  /// A historical account written by ‘Abdu’l‑Bahá around 1886 and first published anonymously in Persian in 1890. The English translation was prepared by Professor Edward G. Browne and first published by Cambridge University Press in 1891.
  ttt(
    authors: {AbdulBaha()},
    title: 'Twelve Table Talks given by ‘Abdu’l‑Bahá in ‘Akká',
    sortTitle: 'Twelve Table Talks',
    summary:
        'Twelve Table Talks given by ‘Abdu’l‑Bahá in ‘Akká between 1904 and 1907.',
  ),

  /// Will and Testament of ‘Abdu’l‑Bahá:
  /// A document written in three parts between 1901 and 1908. It was read officially in the Holy Land on 3 January 1922.
  wt(
    authors: {AbdulBaha()},
    title: 'Will and Testament of ‘Abdu’l‑Bahá',
    summary:
        'A document written in three parts between 1901 and 1908. It was read officially in the Holy Land on 3 January 1922.',
  ),

  /// Additional Prayers Revealed by ‘Abdu’l‑Bahá:
  apa(
    authors: {AbdulBaha()},
    title: 'Additional Prayers Revealed by ‘Abdu’l‑Bahá',
  ),

  /// Twenty-six Prayers Revealed by ‘Abdu’l‑Bahá:
  tsp(
    authors: {AbdulBaha()},
    title: 'Twenty-six Prayers Revealed by ‘Abdu’l‑Bahá',
  ),

  /// Additional Tablets, Extracts and Talks (‘Abdu’l‑Bahá):
  tet(
    authors: {AbdulBaha()},
    title: 'Additional Tablets, Extracts and Talks',
  );

  const SacredWritings({
    required this.authors,
    required this.title,
    String? sortTitle,
    this.subtitle,
    this.summary,
    this.isCompilation = false,
  }) : sortTitle = sortTitle ?? title;

  @override
  final Set<CentralFigure> authors;

  @override
  CentralFigure? get singleAuthor => authors.singleOrNull;

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
