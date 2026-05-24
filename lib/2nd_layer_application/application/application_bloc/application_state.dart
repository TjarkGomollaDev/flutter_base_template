part of 'application_bloc.dart';

@immutable
class ApplicationState {
  final int index;

  const ApplicationState._({
    required this.index,
  });

  ApplicationState copyWith({
    int? index,
  }) {
    return ApplicationState._(
      index: index ?? this.index,
    );
  }
}
