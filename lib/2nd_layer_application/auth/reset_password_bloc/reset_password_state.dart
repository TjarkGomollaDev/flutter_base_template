part of 'reset_password_bloc.dart';

enum ResetPasswordFlag { initial, notInitial, submitting, error, succes }

@immutable
class ResetPasswordState {
  final ResetPasswordFlag flag;
  final String email;
  final String? validationEmail;
  final String error;

  const ResetPasswordState._({
    required this.flag,
    required this.email,
    this.validationEmail,
    required this.error,
  });

  factory ResetPasswordState.initial() {
    return const ResetPasswordState._(
      flag: ResetPasswordFlag.initial,
      email: '',
      validationEmail: InputAuthValidators.EMPTY_FIELD_MSG,
      error: '',
    );
  }

  ResetPasswordState copyWith({
    ResetPasswordFlag? flag,
    String? email,
    String? validationEmail,
    bool validationEmailSetNull = false,
    String? error,
  }) {
    return ResetPasswordState._(
      flag: flag ?? this.flag,
      email: email ?? this.email,
      validationEmail: validationEmailSetNull ? null : validationEmail ?? this.validationEmail,
      error: error ?? this.error,
    );
  }
}
