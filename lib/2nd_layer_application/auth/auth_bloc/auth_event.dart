part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthEventSignOutRequested extends AuthEvent {}

class _AuthEventUserChanged extends AuthEvent {
  final AuthUserModel user;

  _AuthEventUserChanged({
    required this.user,
  });
}
