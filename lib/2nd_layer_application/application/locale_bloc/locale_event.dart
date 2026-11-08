part of 'locale_bloc.dart';

@immutable
sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

final class LocaleEventLoadSettings extends LocaleEvent {
  const LocaleEventLoadSettings();
}

final class LocaleEventChangeLocale extends LocaleEvent {
  final String? languageCode;

  const LocaleEventChangeLocale({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}
