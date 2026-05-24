part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final bool useSystemTheme;
  final bool themeMode;

  const ThemeState._({
    required this.useSystemTheme,
    required this.themeMode,
  });

  ThemeState copyWith({
    bool? useSystemTheme,
    bool? themeMode,
  }) {
    return ThemeState._(
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
