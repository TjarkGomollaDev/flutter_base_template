import 'package:flutter/material.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';
import 'package:flutter_base_template/l10n/app_localizations.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorPalette get colorPalette => Theme.of(this).colorPalette;
  ShadowPalette get shadowPalette => Theme.of(this).shadowPalette;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get sizeOf => MediaQuery.sizeOf(this);
  EdgeInsets get paddingOf => MediaQuery.paddingOf(this);
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
