// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get page2 => 'Page 2';

  @override
  String get page3 => 'Page 3';

  @override
  String get page4 => 'Page 4';

  @override
  String get placeholderHome => 'Placeholder Home Page';

  @override
  String get placeholderPage2 => 'Placeholder Page 2';

  @override
  String get placeholderPage3 => 'Placeholder Page 3';

  @override
  String get placeholderPage4 => 'Placeholder Page 4';

  @override
  String get errorScreen =>
      'We are sorry, this page doesn\'t exist or an error happened.\nPlease restart the app.';

  @override
  String get errorUnknow =>
      'Unknown issue. Please retry or reach out to our support.';
}
