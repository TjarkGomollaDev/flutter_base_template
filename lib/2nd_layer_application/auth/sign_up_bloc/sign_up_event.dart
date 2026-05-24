part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

// input fields
class SignUpEventUpdateEmail extends SignUpEvent {
  final String email;

  SignUpEventUpdateEmail({
    required this.email,
  });
}

class SignUpEventUpdatePassword extends SignUpEvent {
  final String password;

  SignUpEventUpdatePassword({
    required this.password,
  });
}

class SignUpEventUpdateConfirmPassword extends SignUpEvent {
  final String confirmPassword;

  SignUpEventUpdateConfirmPassword({
    required this.confirmPassword,
  });
}

// buttons
class SignUpEventUpdatePasswordObscure extends SignUpEvent {}

class SignUpEventUpdateCheckboxTOS extends SignUpEvent {}

class SignUpEventWithEmailAndPassword extends SignUpEvent {}

// reset state to initial
class SignUpEventResetStateToInitial extends SignUpEvent {}
