part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeEventLoadSettings extends ThemeEvent {}

class ThemeEventChangeUseSystemTheme extends ThemeEvent {}

class ThemeEventChangeThemeMode extends ThemeEvent {}
