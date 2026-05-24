part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingEventChangePageIndex extends OnboardingEvent {
  final int index;

  const OnboardingEventChangePageIndex({
    required this.index,
  });
}

class OnboardingEventFinishOnboarding extends OnboardingEvent {}
