import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_label_btn.dart';
import 'package:flutter_base_template/2nd_layer_application/application/search_bloc/search_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';

class SearchOverlayBar extends StatelessWidget {
  final FocusNode focusNode;
  final GestureTapCallback onDismiss;

  const SearchOverlayBar({
    super.key,
    required this.focusNode,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Row(
      children: [
        Expanded(
          child: TextField(
            focusNode: focusNode,
            autocorrect: false,
            textAlignVertical: TextAlignVertical.center,
            style: themeData.textTheme.bodyLarge,
            cursorHeight: AppConstants.CURSOR_HEIGHT,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: AppConstants.SPACE_HORIZONTAL_M,
                  right: AppConstants.SPACE_HORIZONTAL_S,
                ),
                child: Icon(
                  Icons.search,
                  size: AppConstants.INPUT_FIELD_ICON_SIZE,
                ),
              ),
            ),
            onChanged: (value) =>
                context.read<SearchBloc>().add(SearchEventUpdateSearch(searchTerm: value)),
            onSubmitted: (value) => context.read<SearchBloc>().add(SearchEventSubmitSearch()),
          ),
        ),
        AppConstants.SPACE_HORIZONTAL_XS.widthSizedBox,
        CoreLabelBtn(
          name: 'Cancel',
          callback: onDismiss,
        )
      ],
    );
  }
}
