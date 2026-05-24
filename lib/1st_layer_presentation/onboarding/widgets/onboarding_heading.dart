import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:mark_lxxxv/2nd_layer_application/onboarding/onboarding_bloc/onboarding_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/app_router.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';
import 'package:mark_lxxxv/core/extensions/int_double_extensions.dart';
import 'package:mark_lxxxv/core/extensions/theme_extensions.dart';

class OnboardingHeading extends StatelessWidget {
  const OnboardingHeading({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // title
              Text(
                'Ready to Roll?',
                style: themeData.textTheme.titleLarge,
              ),
              const Spacer(),
              // skip button
              CoreLabelBtn(
                name: 'Skip',
                callback: () {
                  context.read<OnboardingBloc>().add(OnboardingEventFinishOnboarding());
                  Navigator.pushNamedAndRemoveUntil(context, RouteNames.SIGN_IN, (route) => false);
                },
              ),
            ],
          ),
          AppConstants.SPACE_VERTICAL_XXS.heightSizedBox,
          // subtitle
          Text(
            'Just a few more steps before start',
            style: themeData.textTheme.titleLarge!.copyWith(
              fontSize: 20,
              color: themeData.colorPalette.gray1,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
