import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_bottom_sheet.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/loading_indicator_center.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/info_notification_center.dart';
import 'package:flutter_base_template/1st_layer_presentation/sign_in/sign_in_bottom_sheet.dart';
import 'package:flutter_base_template/1st_layer_presentation/sign_up/widgets/checkbox_therms_of_service.dart';
import 'package:flutter_base_template/1st_layer_presentation/sign_up/widgets/sign_up_input_fields.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class SignUpBottomSheet {
  static void showSignUpBottomSheet({required BuildContext context}) {
    CoreBottomSheet.showCommonBottomSheet(
      context: context,
      builder: (context) {
        final themeData = context.theme;
        // handles the submitting, success and error case
        // more precisely, a load indicator and in error/ success case a custom notification is displayed
        return BlocListener<SignUpBloc, SignUpState>(
          listenWhen: (previous, current) => previous.flag != current.flag,
          listener: (context, state) {
            if (state.flag == SignUpFlag.submitting) {
              LoadingIndicatorCenter.showLoadingIndicator(context);
            } else if (state.flag == SignUpFlag.success) {
              LoadingIndicatorCenter.hideLoadingIndicator();
              Navigator.pop(context);
              InfoNotificationCenter.showInfoNotification(
                context: context,
                message: state.error,
                type: InfoNotificationType.succes,
              );
            } else if (state.flag == SignUpFlag.error) {
              LoadingIndicatorCenter.hideLoadingIndicator();
              InfoNotificationCenter.showInfoNotification(
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
                    'Start Your Journey',
                    style: themeData.textTheme.titleLarge,
                  ),
                  AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                  // sign up input fields
                  const SignUpInputFields(),
                  AppConstants.SPACE_VERTICAL_L.heightSizedBox,
                  // checkbox
                  const CheckboxThermsOfService(),
                  AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                  // sign up buttons
                  CoreBtn(
                    name: 'Sign Up',
                    color: themeData.colorPalette.onPrimary,
                    textColor: themeData.colorPalette.primary,
                    callback: () {
                      FocusScope.of(context).unfocus();
                      context.read<SignUpBloc>().add(SignUpEventWithEmailAndPassword());
                    },
                  ),
                  AppConstants.SPACE_VERTICAL_L.heightSizedBox,
                  // bottom inforamtion
                  CoreBottomInformation(
                    infoText: 'You already have an account?',
                    btnText: 'Sign In.',
                    callback: () {
                      Navigator.pop(context);
                      context.read<SignInBloc>().add(SignInEventResetStateToInitial());
                      SignInBottomSheet.showSignInBottomSheet(context: context);
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
