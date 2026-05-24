import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:mark_lxxxv/2nd_layer_application/application/home_bloc/home_bloc.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';

class MenuChip extends StatelessWidget {
  final String name;
  final int index;

  const MenuChip({super.key, required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorPalette = context.colorPalette;
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
            color: state.menuChipsIndex == index ? colorPalette.onPrimary : null,
            textColor: state.menuChipsIndex == index ? colorPalette.primary : null,
            callback: () {
              context.read<HomeBloc>().add(HomeEventChangeMenuChipsIndex(index: index));
            },
          ),
        );
      },
    );
  }
}
