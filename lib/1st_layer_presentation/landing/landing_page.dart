import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/loading_indicator_center.dart';
import 'package:mark_lxxxv/1st_layer_presentation/sign_in/sign_in_bottom_sheet.dart';
import 'package:mark_lxxxv/1st_layer_presentation/sign_up/sign_up_bottom_sheet.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_router.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:mark_lxxxv/1st_layer_presentation/landing/widgets/third_party_btn.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';
import 'package:rive/rive.dart' as rive;

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    final size = context.sizeOf;
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous.flag != current.flag,
      listener: (context, state) {
        // if user is authenticated (succesful sign in) go to application page
        if (state.flag == AuthFlag.authenticated) {
          LoadingIndicatorCenter.hideLoadingIndicator();
          Navigator.pushNamedAndRemoveUntil(context, RouteNames.APPLICATION, (route) => false);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // background image of landing page
            Positioned(
              width: size.width * 1.7,
              left: 100,
              bottom: 80,
              child: Image.asset(
                'assets/backgrounds/Spline.png',
              ),
            ),
            // background animation
            Transform.translate(
              offset: const Offset(0, -80),
              child: const rive.RiveAnimation.asset(
                'assets/rive/shapes.riv',
              ),
            ),
            // background blur
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 35,
                sigmaY: 35,
              ),
              child: const SizedBox(),
            ),
            // content of landing page
            SafeArea(
              minimum: const EdgeInsets.only(bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    115.heightSizedBox,
                    // title
                    Text(
                      'Ready?\nJoin Us\n& Chat.',
                      style: themeData.textTheme.displayLarge,
                    ),
                    const Spacer(flex: 2),
                    // sign in
                    CoreBtn(
                      name: 'Sign In',
                      color: themeData.colorPalette.onPrimary,
                      textColor: themeData.colorPalette.primary,
                      callback: () {
                        context.read<SignInBloc>().add(SignInEventResetStateToInitial());
                        SignInBottomSheet.showSignInBottomSheet(context: context);
                      },
                    ),
                    AppConstants.SPACE_VERTICAL_S.heightSizedBox,
                    // sign up
                    CoreBtn(
                      name: 'Sign Up',
                      color: themeData.colorPalette.onPrimary,
                      textColor: themeData.colorPalette.primary,
                      callback: () {
                        context.read<SignUpBloc>().add(SignUpEventResetStateToInitial());
                        SignUpBottomSheet.showSignUpBottomSheet(context: context);
                      },
                    ),
                    AppConstants.SPACE_VERTICAL_S.heightSizedBox,
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Or connect using',
                        style: themeData.textTheme.bodyMedium,
                      ),
                    ),
                    AppConstants.SPACE_VERTICAL_S.heightSizedBox,
                    // third party sign in buttons
                    Row(
                      children: [
                        const ThirdPartyBtn(provider: ThirdPartyProvider.google),
                        AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
                        const ThirdPartyBtn(provider: ThirdPartyProvider.apple),
                      ],
                    ),
                    AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
                    // bottom information
                    CoreBottomInformation(
                      infoText: 'More information and help on our website.',
                      btnText: 'Visit here.',
                      callback: () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
