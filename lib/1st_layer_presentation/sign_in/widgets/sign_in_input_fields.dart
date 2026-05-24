import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_theme.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignInInputFields extends StatelessWidget {
  const SignInInputFields({super.key});

  @override
  Widget build(BuildContext context) {
    // the input fields are a bit different on the sign in screen than to the rest of the app
    final themeData = context.theme;
    return Column(
      children: [
        BlocBuilder<SignInBloc, SignInState>(
          buildWhen: (previous, current) =>
              (previous.isEmailValid != current.isEmailValid) |
              (previous.isValidationActiveUI != current.isValidationActiveUI) |
              (previous.flag != current.flag),
          builder: (context, state) {
            return TextField(
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              style: themeData.textTheme.bodyLarge,
              cursorHeight: AppConstants.CURSOR_HEIGHT,
              decoration: InputDecoration(
                // override the textfield borders manually, here we don't use the build in validator
                enabledBorder: state.isValidationActiveUI
                    ? (state.isEmailValid ? AppTheme.disabledBorder : AppTheme.errorBorderLight)
                    : AppTheme.disabledBorder,
                focusedBorder: state.isValidationActiveUI
                    ? (state.isEmailValid ? AppTheme.disabledBorder : AppTheme.errorBorderLight)
                    : AppTheme.disabledBorder,
                hintText: 'Enter your Email',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.SPACE_HORIZONTAL_M,
                    right: AppConstants.SPACE_HORIZONTAL_S,
                  ),
                  child: Icon(
                    Icons.mail_outline,
                    size: AppConstants.INPUT_FIELD_ICON_SIZE,
                  ),
                ),
              ),
              onChanged: (value) => context.read<SignInBloc>().add(SignInEventUpdateEmail(email: value)),
            );
          },
        ),
        AppConstants.SPACE_VERTICAL_S.heightSizedBox,
        // input field for password
        BlocBuilder<SignInBloc, SignInState>(
          buildWhen: (previous, current) =>
              (previous.isPasswordValid != current.isPasswordValid) |
              (previous.isPasswordObscure != current.isPasswordObscure) |
              (previous.isValidationActiveUI != current.isValidationActiveUI),
          builder: (context, state) {
            return TextField(
              autocorrect: false,
              textAlignVertical: TextAlignVertical.center,
              obscureText: state.isPasswordObscure,
              style: themeData.textTheme.bodyLarge,
              cursorHeight: AppConstants.CURSOR_HEIGHT,
              decoration: InputDecoration(
                // override the textfield borders manually, here we don't use the build in validator
                enabledBorder: state.isValidationActiveUI
                    ? (state.isPasswordValid ? AppTheme.disabledBorder : AppTheme.errorBorderLight)
                    : AppTheme.disabledBorder,
                focusedBorder: state.isValidationActiveUI
                    ? (state.isPasswordValid ? AppTheme.disabledBorder : AppTheme.errorBorderLight)
                    : AppTheme.disabledBorder,
                hintText: 'Enter your Password',
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.SPACE_HORIZONTAL_M,
                    right: AppConstants.SPACE_HORIZONTAL_S,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    size: AppConstants.INPUT_FIELD_ICON_SIZE,
                  ),
                ),
                suffixIcon: GestureDetector(
                  onTap: () => context.read<SignInBloc>().add(SignInEventUpdatePasswordObscure()),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppConstants.SPACE_HORIZONTAL_S,
                      right: AppConstants.SPACE_HORIZONTAL_M,
                    ),
                    child: Icon(
                      state.isPasswordObscure ? MdiIcons.eyeOffOutline : MdiIcons.eyeOutline,
                      size: AppConstants.INPUT_FIELD_ICON_SIZE,
                    ),
                  ),
                ),
              ),
              onChanged: (value) => context.read<SignInBloc>().add(SignInEventUpdatePassword(password: value)),
            );
          },
        ),
      ],
    );
  }
}
