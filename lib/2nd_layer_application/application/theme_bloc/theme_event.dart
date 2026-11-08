part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

final class ThemeEventLoadSettings extends ThemeEvent {
  const ThemeEventLoadSettings();
}

final class ThemeEventChangeUseSystemTheme extends ThemeEvent {
  const ThemeEventChangeUseSystemTheme();
}

final class ThemeEventChangeThemeMode extends ThemeEvent {
  const ThemeEventChangeThemeMode();
}
