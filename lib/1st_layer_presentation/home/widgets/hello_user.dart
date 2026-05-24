import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class HelloUser extends StatelessWidget {
  const HelloUser({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) => previous.usernameAnimation != current.usernameAnimation,
        builder: (context, state) {
          return Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                'Hello',
                style: themeData.textTheme.titleLarge,
              ),
              AppConstants.SPACE_HORIZONTAL_S.widthSizedBox,
              Text(
                state.usernameAnimation,
                style:
                    themeData.textTheme.titleMedium!.copyWith(color: themeData.colorPalette.gray2),
              )
            ],
          );
        },
      ),
    );
  }
}
