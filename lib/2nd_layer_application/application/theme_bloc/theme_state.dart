part of 'theme_bloc.dart';

@immutable
class ThemeState extends Equatable {
  final bool useSystemTheme;
  final bool isLightMode;

  const factory ThemeState({
    required bool useSystemTheme,
    required bool isLightMode,
  }) = ThemeState._;

  const ThemeState._({required this.useSystemTheme, required this.isLightMode});

  ThemeState copyWith({bool? useSystemTheme, bool? isLightMode}) {
    return ThemeState._(
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      isLightMode: isLightMode ?? this.isLightMode,
    );
  }

  @override
  List<Object?> get props => [useSystemTheme, isLightMode];
}
