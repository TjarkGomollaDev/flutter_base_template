part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}

// input fields
class ResetPasswordEventUpdateEmail extends ResetPasswordEvent {
  final String email;

  ResetPasswordEventUpdateEmail({
    required this.email,
  });
}

// buttons
class ResetPasswordEventSendEmailLink extends ResetPasswordEvent {}

// reset state to initial
class ResetPasswordEventResetStateToInitial extends ResetPasswordEvent {}
