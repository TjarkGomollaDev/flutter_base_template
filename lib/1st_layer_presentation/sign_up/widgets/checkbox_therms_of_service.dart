import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/2nd_layer_application/auth/sign_up_bloc/sign_up_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class CheckboxThermsOfService extends StatefulWidget {
  const CheckboxThermsOfService({super.key});

  @override
  State<CheckboxThermsOfService> createState() => _CheckboxThermsOfServiceState();
}

class _CheckboxThermsOfServiceState extends State<CheckboxThermsOfService> {
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleOnTap;
    super.initState();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _handleOnTap() {
    debugPrint('Tap');
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.2,
          child: SizedBox(
            height: 24,
            width: 24,
            child: BlocBuilder<SignUpBloc, SignUpState>(
              buildWhen: (previous, current) =>
                  (previous.isAcceptedTOS != current.isAcceptedTOS) ||
                  (previous.showValidationTOS != current.showValidationTOS),
              builder: (context, state) {
                return Checkbox(
                  isError: state.showValidationTOS,
                  checkColor: themeData.colorPalette.primary,
                  activeColor: themeData.colorPalette.onPrimary,
                  value: state.isAcceptedTOS,
                  onChanged: (_) => context.read<SignUpBloc>().add(SignUpEventUpdateCheckboxTOS()),
                );
              },
            ),
          ),
        ),
        AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
        Flexible(
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: 'By Signing Up you accept and agree with our ',
                  style: themeData.textTheme.bodyMedium,
                ),
                TextSpan(
                  text: 'Terms of Service ',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: themeData.colorPalette.blue,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: _tapGestureRecognizer,
                ),
                TextSpan(
                  text: 'and ',
                  style: themeData.textTheme.bodyMedium,
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: themeData.textTheme.bodyMedium!.copyWith(
                    color: themeData.colorPalette.blue,
                    fontWeight: FontWeight.w500,
                  ),
                  recognizer: _tapGestureRecognizer,
                ),
                TextSpan(
                  text: '.',
                  style: themeData.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
