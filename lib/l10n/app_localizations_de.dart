// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get home => 'Startseite';

  @override
  String get page2 => 'Seite 2';

  @override
  String get page3 => 'Seite 3';

  @override
  String get page4 => 'Seite 4';

  @override
  String get placeholderHome => 'Startseite Platzhalter';

  @override
  String get placeholderPage2 => 'Seite 2 Platzhalter';

  @override
  String get placeholderPage3 => 'Seite 3 Platzhalter';

  @override
  String get placeholderPage4 => 'Seite 4 Platzhalter';

  @override
  String get errorScreen =>
      'Es tut uns leid, diese Seite existiert nicht oder ein Fehler ist aufgetreten.\nBitte starte die App neu.';

  @override
  String get errorUnknown =>
      'Unbekanntes Problem. Bitte versuche es erneut oder wende dich an unseren Support.';
}
