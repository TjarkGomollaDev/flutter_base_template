import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:mark_lxxxv/4th_layer_infrastructure/models/auth_user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final InterfaceAuthRepository _authRepository;
  StreamSubscription<AuthUserModel>? _userSubscription;

  AuthBloc({required InterfaceAuthRepository authRepository})
      : _authRepository = authRepository,
        super(authRepository.currentAuthUser.isNotEmpty
            ? AuthState.authenticated(user: authRepository.currentAuthUser)
            : const AuthState.unauthenticated()) {
    on<AuthEventSignOutRequested>(_onSignOutRequested);
    on<_AuthEventUserChanged>(_onUserChanged);

    _userSubscription = _authRepository.authStateChanges.listen(
      (user) {
        add(_AuthEventUserChanged(user: user));
      },
    );
  }

  Future<void> _onUserChanged(_AuthEventUserChanged event, Emitter<AuthState> emit) async {
    emit(event.user.isNotEmpty
        ? AuthState.authenticated(user: event.user)
        : const AuthState.unauthenticated());
  }

  void _onSignOutRequested(AuthEventSignOutRequested event, Emitter<AuthState> emit) {
    unawaited(_authRepository.signOut());
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    return super.close();
  }
}
