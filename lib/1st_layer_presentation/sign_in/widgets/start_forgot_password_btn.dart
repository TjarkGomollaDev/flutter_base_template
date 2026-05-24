import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/reset_password/reset_password_bottom_sheet.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/reset_password_bloc/reset_password_bloc.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';

class StartResetPasswordBtn extends StatelessWidget {
  const StartResetPasswordBtn({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        context.read<ResetPasswordBloc>().add(ResetPasswordEventResetStateToInitial());
        ResetPasswordBottomSheet.showResetPasswordBottomSheet(context: context);
      },
      child: Text(
        'Forgot Password?',
        style: textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
