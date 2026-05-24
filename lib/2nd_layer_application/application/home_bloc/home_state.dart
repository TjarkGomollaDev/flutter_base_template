part of 'home_bloc.dart';

@immutable
class HomeState {
  final String usernameAnimation;
  final String username;
  final int menuChipsIndex;
  final bool cardStatus;

  const HomeState._({
    required this.usernameAnimation,
    required this.username,
    required this.menuChipsIndex,
    required this.cardStatus,
  });

  factory HomeState.initial() {
    return const HomeState._(
      usernameAnimation: '',
      username: 'Maurice999',
      menuChipsIndex: 0,
      cardStatus: true,
    );
  }

  HomeState copyWith({
    String? usernameAnimation,
    String? username,
    int? menuChipsIndex,
    bool? cardStatus,
  }) {
    return HomeState._(
      usernameAnimation: usernameAnimation ?? this.usernameAnimation,
      username: username ?? this.username,
      menuChipsIndex: menuChipsIndex ?? this.menuChipsIndex,
      cardStatus: cardStatus ?? this.cardStatus,
    );
  }
}
