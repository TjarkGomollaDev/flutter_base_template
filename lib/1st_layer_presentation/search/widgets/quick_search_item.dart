import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/search/widgets/quick_search_item_data.dart';
import 'package:flutter_base_template/2nd_layer_application/application/search_bloc/search_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class QuickSearchItem extends StatelessWidget {
  final QuickSearchItemModel item;

  const QuickSearchItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return GestureDetector(
      onTap: () {
        context.read<SearchBloc>().add(SearchEventUpdateSearch(searchTerm: item.text));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(AppConstants.SPACE_VERTICAL_XXS),
            decoration: BoxDecoration(
              color: themeData.colorPalette.onPrimary,
              borderRadius: BorderRadius.circular(AppConstants.RADIUS_XS),
            ),
            child: Icon(
              item.icon,
              color: themeData.colorPalette.primary,
              size: AppConstants.SMALL_ICON_SIZE,
            ),
          ),
          AppConstants.SPACE_HORIZONTAL_M.widthSizedBox,
          Text(
            item.text,
            style: themeData.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
