import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_sheet.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/loading_indicator_center.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/info_notification_center.dart';
import 'package:mark_lxxxv/1st_layer_presentation/sign_in/widgets/sign_in_input_fields.dart';
import 'package:mark_lxxxv/1st_layer_presentation/sign_in/widgets/start_forgot_password_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/sign_up/sign_up_bottom_sheet.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class SignInBottomSheet {
  static void showSignInBottomSheet({required BuildContext context}) {
    CoreBottomSheet.showCommonBottomSheet(
      context: context,
      builder: (context) {
        final themeData = context.theme;
        // handles the submitting, success and error case
        // more precisely, a load indicator and in error/ success case a custom notification is displayed
        return BlocListener<SignInBloc, SignInState>(
          listenWhen: (previous, current) => previous.flag != current.flag,
          listener: (context, state) async {
            if (state.flag == SignInFlag.submitting) {
              LoadingIndicatorCenter.showLoadingIndicator(context);
            } else if (state.flag == SignInFlag.error) {
              LoadingIndicatorCenter.hideLoadingIndicator();
              await InfoNotificationCenter.showInfoNotification(
                context: context,
                message: state.error,
                type: InfoNotificationType.error,
              );
            }
          },
          child: SafeArea(
            minimum: const EdgeInsets.only(
              bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.PAGE_PADDING_HORIZONTAL,
              ).copyWith(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // title
                  Text(
                    'Hey, You’re Back',
                    style: themeData.textTheme.titleLarge,
                  ),
                  AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                  // sign in input fields
                  const SignInInputFields(),
                  AppConstants.SPACE_VERTICAL_S.heightSizedBox,
                  // reset password
                  const StartResetPasswordBtn(),
                  AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                  // sign in button
                  CoreBtn(
                    name: 'Sign In',
                    color: themeData.colorPalette.onPrimary,
                    textColor: themeData.colorPalette.primary,
                    callback: () {
                      FocusScope.of(context).unfocus();
                      context.read<SignInBloc>().add(SignInEventWithEmailAndPassword());
                    },
                  ),
                  AppConstants.SPACE_VERTICAL_L.heightSizedBox,
                  // bottom inforamtion
                  CoreBottomInformation(
                    infoText: 'Don\'t have an account yet?',
                    btnText: 'Sign Up.',
                    callback: () {
                      Navigator.pop(context);
                      context.read<SignUpBloc>().add(SignUpEventResetStateToInitial());
                      SignUpBottomSheet.showSignUpBottomSheet(context: context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
