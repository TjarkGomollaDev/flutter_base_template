import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class ResetPasswordInputFields extends StatelessWidget {
  const ResetPasswordInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return TextFormField(
      autocorrect: false,
      textAlignVertical: TextAlignVertical.center,
      style: themeData.textTheme.bodyLarge,
      cursorHeight: AppConstants.CURSOR_HEIGHT,
      decoration: const InputDecoration(
        hintText: 'Enter your Email',
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: AppConstants.SPACE_HORIZONTAL_M,
            right: AppConstants.SPACE_HORIZONTAL_S,
          ),
          child: Icon(
            Icons.mail_outline,
            size: AppConstants.INPUT_FIELD_ICON_SIZE,
          ),
        ),
      ),
      validator: (_) => context.read<ResetPasswordBloc>().state.validationEmail,
      onChanged: (value) =>
          context.read<ResetPasswordBloc>().add(ResetPasswordEventUpdateEmail(email: value)),
      autovalidateMode: context.watch<ResetPasswordBloc>().state.flag != ResetPasswordFlag.initial
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
    );
  }
}
