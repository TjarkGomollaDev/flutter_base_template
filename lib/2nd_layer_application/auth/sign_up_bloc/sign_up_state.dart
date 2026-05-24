part of 'sign_up_bloc.dart';

// initial: at the initial state the validation is deactivated in the UI
// notInitial: here the validation is now activated
// submitting: running database query, you can show a loading indicator in the UI
// error: something went wrong due the process, you can show a error message in the UI
// success: Sign Up was successful, you can show a success message in the UI
enum SignUpFlag { initial, notInitial, submitting, error, success }

@immutable
class SignUpState {
  final SignUpFlag flag;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isPasswordObscure;
  final bool isAcceptedTOS;
  final bool showValidationTOS;
  final String? validationEmail;
  final String? validationPassword;
  final String? validationConfirmPassword;
  final String error;

  const SignUpState._({
    required this.flag,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.isPasswordObscure,
    required this.isAcceptedTOS,
    required this.showValidationTOS,
    this.validationEmail,
    this.validationPassword,
    this.validationConfirmPassword,
    required this.error,
  });

  factory SignUpState.initial() {
    return const SignUpState._(
      flag: SignUpFlag.initial,
      email: '',
      password: '',
      confirmPassword: '',
      isPasswordObscure: true,
      isAcceptedTOS: false,
      showValidationTOS: false,
      validationEmail: InputAuthValidators.EMPTY_FIELD_MSG,
      validationPassword: InputAuthValidators.EMPTY_FIELD_MSG,
      validationConfirmPassword: InputAuthValidators.EMPTY_FIELD_MSG,
      error: '',
    );
  }

  SignUpState copyWith({
    SignUpFlag? flag,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isPasswordObscure,
    bool? isAcceptedTOS,
    bool? showValidationTOS,
    String? validationEmail,
    String? validationPassword,
    String? validationConfirmPassword,
    String? error,
    // important: the following types are nullable in the constructor!
    // additional parameter to check whether, if null, the this value should be accepted or the actual parameter should be set to null
    bool validationEmailSetNull = false,
    bool validationPasswordSetNull = false,
    bool validationConfirmPasswordSetNull = false,
  }) {
    return SignUpState._(
      flag: flag ?? this.flag,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isPasswordObscure: isPasswordObscure ?? this.isPasswordObscure,
      isAcceptedTOS: isAcceptedTOS ?? this.isAcceptedTOS,
      showValidationTOS: showValidationTOS ?? this.showValidationTOS,
      validationEmail: validationEmailSetNull ? null : validationEmail ?? this.validationEmail,
      validationPassword:
          validationPasswordSetNull ? null : validationPassword ?? this.validationPassword,
      validationConfirmPassword: validationConfirmPasswordSetNull
          ? null
          : validationConfirmPassword ?? this.validationConfirmPassword,
      error: error ?? this.error,
    );
  }
}
