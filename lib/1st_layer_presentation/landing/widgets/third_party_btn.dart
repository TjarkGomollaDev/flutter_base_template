import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/auth/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

enum ThirdPartyProvider { google, apple }

class ThirdPartyBtn extends StatelessWidget {
  final ThirdPartyProvider provider;

  const ThirdPartyBtn({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          return switch (provider) {
            ThirdPartyProvider.google => signInWithGoogle(context: context),
            ThirdPartyProvider.apple => signInWithApple(context: context),
          };
        },
        child: Container(
          height: AppConstants.BTN_HEIGHT,
          decoration: BoxDecoration(
            color: themeData.colorPalette.primary,
            borderRadius: BorderRadius.circular(AppConstants.RADIUS_M),
            boxShadow: [themeData.shadowPalette.primaryBtnShadow],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // provider logo
                Padding(
                  padding: provider == ThirdPartyProvider.apple
                      ? const EdgeInsets.only(bottom: 2)
                      : EdgeInsets.zero,
                  child: Image.asset(
                    'assets/icons/${provider.name}-logo.png',
                    height: 20,
                    color: provider == ThirdPartyProvider.apple
                        ? themeData.colorPalette.onPrimary
                        : null,
                  ),
                ),
                AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
                // provider name
                Text(
                  'Sign In',
                  style: themeData.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInWithGoogle({required BuildContext context}) {
    context.read<SignInBloc>().add(SignInEventWithGoogle());
  }

  void signInWithApple({required BuildContext context}) {
    context.read<SignInBloc>().add(SignInEventWithApple());
  }
}
