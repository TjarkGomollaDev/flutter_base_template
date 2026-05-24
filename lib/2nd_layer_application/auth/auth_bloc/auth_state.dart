part of 'auth_bloc.dart';

enum AuthFlag { authenticated, unauthenticated }

@immutable
class AuthState {
  final AuthFlag flag;
  final AuthUserModel user;

  const AuthState._({
    required this.flag,
    this.user = AuthUserModel.empty,
  });

  const AuthState.authenticated({required AuthUserModel user})
      : this._(
          flag: AuthFlag.authenticated,
          user: user,
        );

  const AuthState.unauthenticated()
      : this._(
          flag: AuthFlag.unauthenticated,
        );
}
