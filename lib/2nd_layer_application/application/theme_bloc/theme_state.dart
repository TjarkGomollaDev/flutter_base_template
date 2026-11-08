part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final bool useSystemTheme;
  final bool themeMode;

  const factory ThemeState({
    required bool useSystemTheme,
    required bool themeMode,
  }) = ThemeState._;

  const ThemeState._({required this.useSystemTheme, required this.themeMode});

  ThemeState copyWith({bool? useSystemTheme, bool? themeMode}) {
    return ThemeState._(
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [useSystemTheme, themeMode];
}
