part of 'sign_in_bloc.dart';

@immutable
sealed class SignInEvent {}

// input fields
class SignInEventUpdateEmail extends SignInEvent {
  final String email;

  SignInEventUpdateEmail({
    required this.email,
  });
}

class SignInEventUpdatePassword extends SignInEvent {
  final String password;

  SignInEventUpdatePassword({
    required this.password,
  });
}

// buttons
class SignInEventUpdatePasswordObscure extends SignInEvent {}

class SignInEventWithEmailAndPassword extends SignInEvent {}

class SignInEventWithApple extends SignInEvent {}

class SignInEventWithGoogle extends SignInEvent {}

// reset state to initial
class SignInEventResetStateToInitial extends SignInEvent {}
