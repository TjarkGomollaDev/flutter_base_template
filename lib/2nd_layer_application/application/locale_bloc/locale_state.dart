part of 'locale_bloc.dart';

@immutable
class LocaleState extends Equatable {
  final Locale? locale;

  const factory LocaleState({Locale? locale}) = LocaleState._;

  const LocaleState._({this.locale});

  LocaleState copyWith({Locale? Function()? locale}) {
    return LocaleState._(locale: locale != null ? locale() : this.locale);
  }

  @override
  List<Object?> get props => [locale];
}
