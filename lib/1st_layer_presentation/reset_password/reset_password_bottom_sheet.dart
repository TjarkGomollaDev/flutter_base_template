import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_sheet.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/loading_indicator_center.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/info_notification_center.dart';
import 'package:mark_lxxxv/1st_layer_presentation/reset_password/widgets/reset_password_input_fields.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class ResetPasswordBottomSheet {
  static void showResetPasswordBottomSheet({required BuildContext context}) {
    CoreBottomSheet.showCommonBottomSheet(
      context: context,
      builder: (context) {
        final themeData = context.theme;
        // handles the submitting, success and error case
        // more precisely, a load indicator and in error/ success case a custom notification is displayed
        return BlocListener<ResetPasswordBloc, ResetPasswordState>(
          listenWhen: (previous, current) => previous.flag != current.flag,
          listener: (context, state) {
            if (state.flag == ResetPasswordFlag.submitting) {
              LoadingIndicatorCenter.showLoadingIndicator(context);
            } else if (state.flag == ResetPasswordFlag.succes) {
              LoadingIndicatorCenter.hideLoadingIndicator();
              Navigator.pop(context);
              InfoNotificationCenter.showInfoNotification(
                context: context,
                message: state.error,
                type: InfoNotificationType.succes,
              );
            } else if (state.flag == ResetPasswordFlag.error) {
              LoadingIndicatorCenter.hideLoadingIndicator();
              InfoNotificationCenter.showInfoNotification(
                context: context,
                message: state.error,
                type: InfoNotificationType.error,
              );
            }
          },
          child: SafeArea(
            minimum: const EdgeInsets.only(bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM),
            child: Padding(
              padding: const EdgeInsets.symmetric(
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
                    'Forgot Password',
                    style: themeData.textTheme.titleLarge,
                  ),
                  AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                  // reset password input fields
                  const ResetPasswordInputFields(),
                  AppConstants.SPACE_VERTICAL_M.heightSizedBox,
                  // reset password button
                  CoreBtn(
                    name: 'Send Email',
                    color: themeData.colorPalette.onPrimary,
                    textColor: themeData.colorPalette.primary,
                    callback: () {
                      FocusScope.of(context).unfocus();
                      context.read<ResetPasswordBloc>().add(ResetPasswordEventSendEmailLink());
                    },
                  ),
                  AppConstants.SPACE_VERTICAL_L.heightSizedBox,
                  // bottom inforamtion
                  CoreBottomInformation(
                    infoText: 'You are still having problems?',
                    btnText: 'Contact Us.',
                    callback: () {},
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
