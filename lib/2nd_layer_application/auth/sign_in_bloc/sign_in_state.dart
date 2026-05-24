part of 'sign_in_bloc.dart';

// initial: the initial state
// thirdParty: a third Party Sign In prosses is started
// submitting: running database query, you can show a loading indicator in the UI
// error: something went wrong due the process, you can show a error message in the UI
enum SignInFlag { initial, thirdParty, submitting, error }

@immutable
class SignInState {
  final SignInFlag flag;
  final String email;
  final String password;
  // idea: validation should initially be disabled and only start after the first Sign In attempt
  // important: this is only a visual aid for the user, the actual validation is of course always active
  final bool isValidationActiveUI;
  final bool isPasswordObscure;
  final bool isEmailValid;
  final bool isPasswordValid;
  final String error;

  const SignInState._({
    required this.flag,
    required this.email,
    required this.password,
    required this.isValidationActiveUI,
    required this.isPasswordObscure,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.error,
  });

  factory SignInState.initial() {
    return const SignInState._(
      flag: SignInFlag.initial,
      email: '',
      password: '',
      isValidationActiveUI: false,
      isPasswordObscure: true,
      isEmailValid: false,
      isPasswordValid: false,
      error: '',
    );
  }

  SignInState copyWith({
    SignInFlag? flag,
    String? email,
    String? password,
    bool? isValidationActiveUI,
    bool? isPasswordObscure,
    bool? isEmailValid,
    bool? isPasswordValid,
    String? error,
  }) {
    return SignInState._(
      flag: flag ?? this.flag,
      email: email ?? this.email,
      password: password ?? this.password,
      isValidationActiveUI: isValidationActiveUI ?? this.isValidationActiveUI,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      error: error ?? this.error,
    );
  }
}
