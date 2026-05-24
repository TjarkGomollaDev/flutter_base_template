import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:flutter_base_template/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class AiChatChip extends StatelessWidget {
  final String name;
  final int index;

  const AiChatChip({super.key, required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.menuChipsIndex != current.menuChipsIndex,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? AppConstants.PAGE_PADDING_HORIZONTAL : 0,
            right: AppConstants.SPACE_HORIZONTAL_S,
          ),
          child: CoreLabelBtn(
            name: name,
            color: state.menuChipsIndex == index ? themeData.colorPalette.mint : null,
            textColor: state.menuChipsIndex == index ? themeData.colorPalette.primary : null,
            callback: () {
              context.read<HomeBloc>().add(HomeEventChangeMenuChipsIndex(index: index));
            },
          ),
        );
      },
    );
  }
}
