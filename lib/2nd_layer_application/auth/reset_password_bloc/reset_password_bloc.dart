import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_base_template/core/success_messages/succes.dart';
import 'package:flutter_base_template/core/validators/input_auth_validators.dart';
import 'package:meta/meta.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final InterfaceAuthRepository _authRepository;

  ResetPasswordBloc({required InterfaceAuthRepository authRepository})
      : _authRepository = authRepository,
        super(ResetPasswordState.initial()) {
    on<ResetPasswordEventUpdateEmail>(_onUpdateEmail);
    on<ResetPasswordEventSendEmailLink>(_onSendEmailLink);
    on<ResetPasswordEventResetStateToInitial>(_onResetStateToInitial);
  }

  void _onUpdateEmail(ResetPasswordEventUpdateEmail event, Emitter<ResetPasswordState> emit) {
    final String? validationEmail = InputAuthValidators.validateEmailFormat(input: event.email);
    emit(state.copyWith(
      email: event.email,
      validationEmail: validationEmail,
      validationEmailSetNull: validationEmail == null ? true : false,
    ));
  }

  Future<void> _onSendEmailLink(
      ResetPasswordEventSendEmailLink event, Emitter<ResetPasswordState> emit) async {
    // activate validation after first Sign In try
    if (state.flag == ResetPasswordFlag.initial) {
      emit(state.copyWith(flag: ResetPasswordFlag.notInitial));
    }
    // avoid sending multiple requests at the same time
    if (state.flag == ResetPasswordFlag.submitting) return;
    // if input is valid try Sign In
    if (state.validationEmail == null) {
      emit(state.copyWith(flag: ResetPasswordFlag.submitting));
      try {
        await _authRepository.sendEmailToResetPassword(email: state.email);
        emit(state.copyWith(
            flag: ResetPasswordFlag.succes, error: SuccessMessages.RESET_PASSWORD_SUCCESS));
      } catch (e) {
        emit(state.copyWith(flag: ResetPasswordFlag.error, error: e.toString()));
      }
    }
  }

  void _onResetStateToInitial(
      ResetPasswordEventResetStateToInitial event, Emitter<ResetPasswordState> emit) {
    emit(ResetPasswordState.initial());
  }
}
