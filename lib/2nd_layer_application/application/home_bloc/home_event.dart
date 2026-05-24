part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {
  const HomeEvent();
}

class HomeEventStart extends HomeEvent {}

class _HomeEventUpdateDisplayUsername extends HomeEvent {}

class HomeEventChangeMenuChipsIndex extends HomeEvent {
  final int index;

  const HomeEventChangeMenuChipsIndex({
    required this.index,
  });
}

class HomeEventChangeCardStatus extends HomeEvent {}
