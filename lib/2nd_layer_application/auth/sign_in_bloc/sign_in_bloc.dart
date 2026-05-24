import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/3rd_layer_domain/entities/user_application_entity.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';
import 'package:flutter_base_template/core/errors/auth_errors.dart';
import 'package:flutter_base_template/core/validators/input_auth_validators.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final InterfaceAuthRepository _authRepository;
  final InterfaceUserRepository _userRepository;

  SignInBloc({
    required InterfaceAuthRepository authRepository,
    required InterfaceUserRepository userRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        super(SignInState.initial()) {
    on<SignInEventUpdateEmail>(_onUpdateEmail);
    on<SignInEventUpdatePassword>(_onUpdatePassword);
    on<SignInEventUpdatePasswordObscure>(_onUpdatePasswordObscure);
    on<SignInEventWithEmailAndPassword>(_onWithEmailAndPassword);
    on<SignInEventWithGoogle>(_onWithGoogle);
    on<SignInEventWithApple>(_onWithApple);
    on<SignInEventResetStateToInitial>(_onResetStateToInitial);
  }

  DateTime? timestampLastSignInPress;

  void _onUpdateEmail(SignInEventUpdateEmail event, Emitter<SignInState> emit) {
    final bool validationEmail = InputAuthValidators.validateInputIsNotEmpty(input: event.email);
    emit(state.copyWith(
      email: event.email,
      isEmailValid: validationEmail,
    ));
  }

  void _onUpdatePassword(SignInEventUpdatePassword event, Emitter<SignInState> emit) {
    final bool validationPassword =
        InputAuthValidators.validateInputIsNotEmpty(input: event.password);
    emit(state.copyWith(
      password: event.password,
      isPasswordValid: validationPassword,
    ));
  }

  void _onUpdatePasswordObscure(SignInEventUpdatePasswordObscure event, Emitter<SignInState> emit) {
    emit(state.copyWith(isPasswordObscure: !state.isPasswordObscure));
  }

  Future<void> _onWithEmailAndPassword(
      SignInEventWithEmailAndPassword event, Emitter<SignInState> emit) async {
    // button cooldown
    final newTimestamp = DateTime.now();
    if (timestampLastSignInPress != null) {
      if (newTimestamp.difference(timestampLastSignInPress!) < const Duration(seconds: 1)) return;
    }
    timestampLastSignInPress = newTimestamp;
    // activate validation after first Sign In try
    if (state.isValidationActiveUI == false) {
      emit(state.copyWith(isValidationActiveUI: true));
    }
    // avoid sending multiple requests at the same time
    if (state.flag == SignInFlag.submitting) return;
    // if input is valid try Sign In
    if (state.isEmailValid && state.isPasswordValid) {
      emit(state.copyWith(flag: SignInFlag.submitting));
      try {
        await _authRepository.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
      } catch (e) {
        emit(state.copyWith(flag: SignInFlag.error, error: e.toString()));
      }
    }
  }

  Future<void> _onWithGoogle(SignInEventWithGoogle event, Emitter<SignInState> emit) async {
    // the Google Sign In process is divided into 4 steps
    // the division makes us more flexible and allows us to make several adjustments
    emit(state.copyWith(flag: SignInFlag.thirdParty));
    try {
      // 1. forwarding to Google for the actual Sign In process
      final googleUser = await _authRepository.signInWithGooglePart1();
      // 2. use the googleUser to create a thirdPartyToken
      emit(SignInState.initial().copyWith(flag: SignInFlag.submitting));
      final thirdPartyToken = await _authRepository.signInWithGooglePart2(googleUser: googleUser);
      // 3. check whether the user already exists in the Firestore Database or still needs to be created
      // this procedure is necessary each time because third party Sign In does not distinguish between "Sign Up" and "Sign "Sign In"
      final userDocumentExist =
          await _userRepository.isUserDocumentExisting(userID: thirdPartyToken.id);
      if (!userDocumentExist) {
        final applicationUserEntity =
            UserApplicationEntity.initializeUser(userID: thirdPartyToken.id);
        await _userRepository.initUserDocument(applicationUserEntity: applicationUserEntity);
      }
      await _userRepository.loadCurrrentUserContactInfo(userID: thirdPartyToken.id);
      // 4. after a successful check, the user receives access to his account
      // the check must be carried out during the sign-in process and not later in the app
      // the entire application depends on the user being present in our database; this way we can rule out any errors
      await _authRepository.thirdPartySignInWithCredential(
          authCredential: thirdPartyToken.authCredential);
    } on ErrorThirdPartySignInCancled catch (_) {
      // in this case, no error should be displayed in the UI
      emit(state.copyWith(flag: SignInFlag.initial));
    } catch (e) {
      emit(state.copyWith(flag: SignInFlag.error, error: e.toString()));
    }
  }

  Future<void> _onWithApple(SignInEventWithApple event, Emitter<SignInState> emit) async {
    debugPrint("apple sign in");
  }

  void _onResetStateToInitial(SignInEventResetStateToInitial event, Emitter<SignInState> emit) {
    emit(SignInState.initial());
  }
}
