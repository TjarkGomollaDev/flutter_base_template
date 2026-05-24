import 'package:bloc/bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/user_application_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';
import 'package:flutter_base_template/core/success_messages/succes.dart';
import 'package:flutter_base_template/core/validators/input_auth_validators.dart';
import 'package:meta/meta.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final InterfaceAuthRepository _authRepository;
  final InterfaceUserRepository _userRepository;

  SignUpBloc({
    required InterfaceAuthRepository authRepository,
    required InterfaceUserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(SignUpState.initial()) {
    on<SignUpEventUpdateEmail>(_onUpdateEmail);
    on<SignUpEventUpdatePassword>(_onUpdatePassword);
    on<SignUpEventUpdateConfirmPassword>(_onUpdateConfirmPassword);
    on<SignUpEventUpdatePasswordObscure>(_onUpdatePasswordObscure);
    on<SignUpEventUpdateCheckboxTOS>(_onUpdateCheckboxTOS);
    on<SignUpEventWithEmailAndPassword>(_onWithEmailAndPassword);
    on<SignUpEventResetStateToInitial>(_onResetStateToInitial);
  }

  void _onUpdateEmail(SignUpEventUpdateEmail event, Emitter<SignUpState> emit) {
    // if validator returns null validation was successful
    final String? validationEmail = InputAuthValidators.validateEmailFormat(input: event.email);
    emit(state.copyWith(
      email: event.email,
      validationEmail: validationEmail,
      validationEmailSetNull: validationEmail == null ? true : false,
    ));
  }

  void _onUpdatePassword(SignUpEventUpdatePassword event, Emitter<SignUpState> emit) {
    // if validator returns null validation was successful
    final String? validationPassword =
        InputAuthValidators.validateStrongPassword(input: event.password);
    final String? validationConfirmPassword = InputAuthValidators.validateConfirmPassword(
      input: event.password,
      inputConfirm: state.confirmPassword,
    );
    emit(state.copyWith(
      password: event.password,
      validationPassword: validationPassword,
      validationPasswordSetNull: validationPassword == null ? true : false,
      validationConfirmPassword: validationConfirmPassword,
      validationConfirmPasswordSetNull: validationConfirmPassword == null ? true : false,
    ));
  }

  void _onUpdateConfirmPassword(SignUpEventUpdateConfirmPassword event, Emitter<SignUpState> emit) {
    // if validator returns null validation was successful
    final String? validationConfirmPassword = InputAuthValidators.validateConfirmPassword(
      input: state.password,
      inputConfirm: event.confirmPassword,
    );
    emit(state.copyWith(
      confirmPassword: event.confirmPassword,
      validationConfirmPassword: validationConfirmPassword,
      validationConfirmPasswordSetNull: validationConfirmPassword == null ? true : false,
    ));
  }

  void _onUpdatePasswordObscure(SignUpEventUpdatePasswordObscure event, Emitter<SignUpState> emit) {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  void _onUpdateCheckboxTOS(SignUpEventUpdateCheckboxTOS event, Emitter<SignUpState> emit) {
    emit(state.copyWith(isAcceptedTOS: !state.isAcceptedTOS, showValidationTOS: false));
  }

  Future<void> _onWithEmailAndPassword(
      SignUpEventWithEmailAndPassword event, Emitter<SignUpState> emit) async {
    // activate validation after first Sign Up try
    if (state.flag == SignUpFlag.initial) {
      emit(state.copyWith(flag: SignUpFlag.notInitial));
    }
    // avoid sending multiple requests at the same time
    if (state.flag == SignUpFlag.submitting) return;
    // if input is valid try Sign Up
    if (state.validationEmail == null &&
        state.validationPassword == null &&
        state.validationConfirmPassword == null &&
        state.isAcceptedTOS) {
      emit(state.copyWith(flag: SignUpFlag.submitting));
      try {
        // first, try to Sign Up in Firebase Auth
        final user = await _authRepository.signUpWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        // second, try to init User Doc in Firebase Database
        final applicationUserEntity = UserApplicationEntity.initializeUser(userID: user.id);
        await _userRepository.initUserDocument(applicationUserEntity: applicationUserEntity);
        emit(state.copyWith(flag: SignUpFlag.success, error: SuccessMessages.SIGN_UP_SUCCESS));
      } catch (e) {
        emit(state.copyWith(flag: SignUpFlag.error, error: e.toString()));
      }
    } else if (state.isAcceptedTOS == false) {
      // marks the checkbox (red) once if you forgot to accept the TOS
      emit(state.copyWith(showValidationTOS: true));
    }
  }

  void _onResetStateToInitial(SignUpEventResetStateToInitial event, Emitter<SignUpState> emit) {
    emit(SignUpState.initial());
  }
}
