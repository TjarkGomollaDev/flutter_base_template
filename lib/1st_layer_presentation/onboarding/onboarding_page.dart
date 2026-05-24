import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_bottom_information.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_btn.dart';
import 'package:flutter_base_template/1st_layer_presentation/onboarding/widgets/onboarding_heading.dart';
import 'package:flutter_base_template/1st_layer_presentation/onboarding/widgets/onboarding_slide.dart';
import 'package:flutter_base_template/2nd_layer_application/onboarding/onboarding_bloc/onboarding_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_router.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPalette = context.colorPalette;
    final size = context.sizeOf;
    final controller = PageController(
        viewportFraction: (size.width - 1.5 * AppConstants.PAGE_PADDING_HORIZONTAL) / size.width);
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.only(bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM),
        child: Column(
          children: [
            AppConstants.SPACE_VERTICAL_S.heightSizedBox,
            // heading
            const OnboardingHeading(),
            AppConstants.SPACE_VERTICAL_S.heightSizedBox,
            // onboarding slides
            SizedBox(
              height: 580,
              child: PageView(
                controller: controller,
                onPageChanged: (value) {
                  context.read<OnboardingBloc>().add(OnboardingEventChangePageIndex(index: value));
                },
                children: const [
                  OnboardingSlide(slide: SlideIndex.firstSlide),
                  OnboardingSlide(slide: SlideIndex.secondSlide),
                  OnboardingSlide(slide: SlideIndex.thirdSlide),
                ],
              ),
            ),
            AppConstants.SPACE_VERTICAL_XS.heightSizedBox,
            // dots indicator
            BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (previous, current) => current.index != previous.index,
              builder: (context, state) {
                return DotsIndicator(
                  dotsCount: 3,
                  position: state.index.toDouble(),
                  decorator: DotsDecorator(
                    color: colorPalette.gray5,
                    activeColor: colorPalette.onPrimary,
                    size: const Size.square(8),
                    activeSize: const Size(16, 8),
                    activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.RADIUS_S),
                    ),
                  ),
                );
              },
            ),
            const Spacer(),
            // next and get started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                buildWhen: (previous, current) => current.index != previous.index,
                builder: (context, state) {
                  return state.index == 2
                      ? CoreBtn(
                          name: 'Get Started',
                          color: colorPalette.onPrimary,
                          textColor: colorPalette.primary,
                          callback: () {
                            context.read<OnboardingBloc>().add(OnboardingEventFinishOnboarding());
                            Navigator.pushNamedAndRemoveUntil(
                                context, RouteNames.SIGN_IN, (route) => false);
                          },
                        )
                      : CoreBtn(
                          name: 'Next Step',
                          callback: () {
                            context.read<OnboardingBloc>().add(
                                  OnboardingEventChangePageIndex(index: state.index + 1),
                                );
                            controller.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                            );
                          },
                        );
                },
              ),
            ),
            AppConstants.SPACE_VERTICAL_L.heightSizedBox,
            // bottom inforamtion
            CoreBottomInformation(
              infoText: 'More information on our website.',
              btnText: 'Visit here.',
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}
