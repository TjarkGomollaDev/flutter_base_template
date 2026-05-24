import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_loading_indicator.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/auth_bloc/auth_bloc.dart';
import 'package:mark_lxxxv/app_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.flag == AuthFlag.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.APPLICATION,
            (route) => false,
          );
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.SIGN_IN,
            (route) => false,
          );
        }
      },
      child: CoreLoadingIndicator(),
    );
  }
}
