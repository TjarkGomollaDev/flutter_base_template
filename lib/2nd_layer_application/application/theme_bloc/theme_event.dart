part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class ThemeEventChangeUseSystemTheme extends ThemeEvent {}

class ThemeEventChangeThemeMode extends ThemeEvent {}
