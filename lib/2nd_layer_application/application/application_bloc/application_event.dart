part of 'application_bloc.dart';

@immutable
sealed class ApplicationEvent {
  const ApplicationEvent();
}

class ApplicationEventChangePageIndex extends ApplicationEvent {
  final int index;

  const ApplicationEventChangePageIndex({
    required this.index,
  });
}

// reset state to initial
class ApplicationEventResetPageIndex extends ApplicationEvent {}
