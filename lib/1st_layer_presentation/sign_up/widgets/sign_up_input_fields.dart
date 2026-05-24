import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpInputFields extends StatelessWidget {
  const SignUpInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Column(
      children: [
        // input field for email
        TextFormField(
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
                Icons.mail_outline_rounded,
                size: AppConstants.INPUT_FIELD_ICON_SIZE,
              ),
            ),
          ),
          validator: (_) => context.read<SignUpBloc>().state.validationEmail,
          onChanged: (value) => context.read<SignUpBloc>().add(SignUpEventUpdateEmail(email: value)),
          autovalidateMode: context.watch<SignUpBloc>().state.flag != SignUpFlag.initial
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
        ),
        AppConstants.SPACE_VERTICAL_S.heightSizedBox,
        // input field for password
        TextFormField(
          autocorrect: false,
          obscureText: context.read<SignUpBloc>().state.isPasswordObscure,
          textAlignVertical: TextAlignVertical.center,
          style: themeData.textTheme.bodyLarge,
          cursorHeight: AppConstants.CURSOR_HEIGHT,
          decoration: InputDecoration(
            hintText: 'Enter your Password',
            prefixIcon: const Padding(
              padding: EdgeInsets.only(
                left: AppConstants.SPACE_HORIZONTAL_M,
                right: AppConstants.SPACE_HORIZONTAL_S,
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                size: AppConstants.INPUT_FIELD_ICON_SIZE,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () => context.read<SignUpBloc>().add(SignUpEventUpdatePasswordObscure()),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.SPACE_HORIZONTAL_S,
                  right: AppConstants.SPACE_HORIZONTAL_M,
                ),
                child: Icon(
                  context.read<SignUpBloc>().state.isPasswordObscure ? MdiIcons.eyeOffOutline : MdiIcons.eyeOutline,
                  size: AppConstants.INPUT_FIELD_ICON_SIZE,
                ),
              ),
            ),
          ),
          validator: (_) => context.read<SignUpBloc>().state.validationPassword,
          onChanged: (value) => context.read<SignUpBloc>().add(SignUpEventUpdatePassword(password: value)),
          autovalidateMode: context.watch<SignUpBloc>().state.flag != SignUpFlag.initial
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
        ),
        AppConstants.SPACE_VERTICAL_S.heightSizedBox,
        // input field for confirm password
        TextFormField(
          autocorrect: false,
          obscureText: context.read<SignUpBloc>().state.isPasswordObscure,
          textAlignVertical: TextAlignVertical.center,
          style: themeData.textTheme.bodyLarge,
          cursorHeight: AppConstants.CURSOR_HEIGHT,
          decoration: InputDecoration(
            hintText: 'Confirm your Password',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: AppConstants.SPACE_HORIZONTAL_M,
                right: AppConstants.SPACE_HORIZONTAL_S,
              ),
              child: Icon(
                MdiIcons.lockCheckOutline,
                size: AppConstants.INPUT_FIELD_ICON_SIZE,
              ),
            ),
            suffixIcon: GestureDetector(
              onTap: () => context.read<SignUpBloc>().add(SignUpEventUpdatePasswordObscure()),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.SPACE_HORIZONTAL_S,
                  right: AppConstants.SPACE_HORIZONTAL_M,
                ),
                child: Icon(
                  context.read<SignUpBloc>().state.isPasswordObscure ? MdiIcons.eyeOffOutline : MdiIcons.eyeOutline,
                  size: AppConstants.INPUT_FIELD_ICON_SIZE,
                ),
              ),
            ),
          ),
          validator: (_) => context.read<SignUpBloc>().state.validationConfirmPassword,
          onChanged: (value) =>
              context.read<SignUpBloc>().add(SignUpEventUpdateConfirmPassword(confirmPassword: value)),
          autovalidateMode: context.watch<SignUpBloc>().state.flag != SignUpFlag.initial
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
        ),
      ],
    );
  }
}
