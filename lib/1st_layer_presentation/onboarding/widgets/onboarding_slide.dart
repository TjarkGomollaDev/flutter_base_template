import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_base_template/1st_layer_presentation/onboarding/widgets/onboarding_data.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

enum SlideIndex { firstSlide, secondSlide, thirdSlide }

class OnboardingSlide extends StatelessWidget {
  final SlideIndex slide;

  const OnboardingSlide({
    super.key,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    final size = context.sizeOf;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.PAGE_PADDING_HORIZONTAL * 0.25, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: switch (data[slide.index]['color'] as SlideColor) {
            SlideColor.red => [
                const Color.fromRGBO(228, 53, 73, 1),
                const Color.fromRGBO(228, 53, 73, 1),
                const Color.fromRGBO(248, 44, 51, 1),
                const Color.fromRGBO(248, 44, 51, 1),
              ],
            SlideColor.blue => [
                const Color.fromRGBO(77, 55, 174, 1),
                const Color.fromRGBO(77, 55, 174, 1),
                const Color.fromRGBO(39, 30, 112, 1),
                const Color.fromRGBO(39, 30, 112, 1),
              ],
            SlideColor.green => [
                const Color.fromRGBO(24, 150, 72, 1),
                const Color.fromRGBO(24, 150, 72, 1),
                const Color.fromRGBO(92, 96, 70, 1),
                const Color.fromRGBO(92, 96, 70, 1),
              ],
          },
        ),
        borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
      ),
      child: Stack(
        children: [
          // circles
          Positioned.fromRect(
            rect: Rect.fromLTRB(
                -20,
                -60,
                size.width - AppConstants.PAGE_PADDING_HORIZONTAL * 2 + 20,
                size.width - AppConstants.PAGE_PADDING_HORIZONTAL * 2 + 0),
            child: Center(
              child: ClipOval(
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: switch (data[slide.index]['color'] as SlideColor) {
                          SlideColor.red => [
                              const Color.fromRGBO(231, 67, 81, 1),
                              const Color.fromRGBO(231, 67, 81, 1),
                              const Color.fromRGBO(248, 44, 51, 1),
                            ],
                          SlideColor.blue => [
                              const Color.fromRGBO(86, 64, 187, 1),
                              const Color.fromRGBO(86, 64, 187, 1),
                              Color.fromRGBO(39, 30, 112, 1),
                            ],
                          SlideColor.green => [
                              Color.fromRGBO(38, 176, 91, 1),
                              Color.fromRGBO(38, 176, 91, 1),
                              Color.fromRGBO(92, 96, 70, 1),
                            ],
                        },
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.all(25),
                    width: 400,
                    height: 400,
                    child: ClipOval(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        color: switch (data[slide.index]['color'] as SlideColor) {
                          SlideColor.red => const Color.fromRGBO(234, 77, 90, 1),
                          SlideColor.blue => Color.fromRGBO(104, 95, 221, 1),
                          SlideColor.green => Color.fromRGBO(44, 183, 97, 1),
                        },
                        child: ClipOval(
                          child: Container(
                            color: switch (data[slide.index]['color'] as SlideColor) {
                              SlideColor.red => const Color.fromRGBO(116, 240, 233, 1),
                              SlideColor.blue => const Color.fromRGBO(215, 205, 241, 1),
                              SlideColor.green => Color.fromRGBO(186, 220, 206, 1),
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(35),
                              child: LottieBuilder.asset(
                                data[slide.index]['animation'].toString(),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
            ),
          ),
          // main content
          Positioned(
            bottom: 110,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // leading
                Text(
                  data[slide.index]['leading'].toString(),
                  style: themeData.textTheme.titleSmall!.copyWith(
                    color: AppTheme.white.withAlpha(204),
                  ),
                ),
                AppConstants.SPACE_VERTICAL_XXS.heightSizedBox,
                // title
                Text(
                  data[slide.index]['title'].toString(),
                  style: themeData.textTheme.titleMedium!.copyWith(
                    color: AppTheme.white,
                  ),
                ),
                AppConstants.SPACE_VERTICAL_XXS.heightSizedBox,
                // subtitle
                Text(
                  data[slide.index]['subtitle'].toString(),
                  style: themeData.textTheme.bodyMedium!
                      .copyWith(color: AppTheme.white.withAlpha(204)),
                ),
              ],
            ),
          ),
          // bottom box with icon
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.SPACE_HORIZONTAL_L),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(AppConstants.RADIUS_L)),
                color: switch (data[slide.index]['color'] as SlideColor) {
                  SlideColor.red => const Color.fromRGBO(251, 0, 44, 1),
                  SlideColor.blue => const Color.fromRGBO(30, 23, 86, 1),
                  SlideColor.green => Color.fromARGB(255, 64, 88, 66),
                },
              ),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.RADIUS_M),
                      color: AppTheme.black,
                    ),
                    child: Center(
                      // icon
                      child: Icon(
                        data[slide.index]['icon'] as IconData,
                        color: AppTheme.white,
                        size: 35,
                      ),
                    ),
                  ),
                  AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title-2
                        Text(
                          data[slide.index]['title-2'].toString(),
                          style: themeData.textTheme.titleSmall!.copyWith(color: AppTheme.white),
                        ),
                        // body
                        Text(
                          data[slide.index]['body'].toString(),
                          style: themeData.textTheme.bodyMedium!
                              .copyWith(color: AppTheme.white.withAlpha(204)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
