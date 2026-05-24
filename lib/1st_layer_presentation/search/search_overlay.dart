import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/1st_layer_presentation/search/widgets/quick_search_item.dart';
import 'package:flutter_base_template/1st_layer_presentation/search/widgets/quick_search_item_data.dart';
import 'package:flutter_base_template/1st_layer_presentation/search/widgets/search_overlay_bar.dart';
import 'package:flutter_base_template/2nd_layer_application/application/search_bloc/search_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';
import 'package:flutter_base_template/core/extensions/int_double_extensions.dart';
import 'package:flutter_base_template/core/extensions/theme_extensions.dart';

class SearchOverlay extends StatelessWidget {
  final FocusNode focusNode;
  final GestureTapCallback onDismiss;

  const SearchOverlay({
    super.key,
    required this.focusNode,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = context.theme;
    return Container(
      color: themeData.colorPalette.primary,
      child: SafeArea(
        minimum: EdgeInsets.only(bottom: AppConstants.SAFE_AREA_MIN_PADDING_BTM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.SPACE_VERTICAL_L.heightSizedBox,
            // title discover
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
              child: Text("Discover", style: themeData.textTheme.titleMedium),
            ),
            AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
            // list quick search items
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1.12,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppConstants.PAGE_PADDING_HORIZONTAL),
                  child: Wrap(
                    spacing: AppConstants.SPACE_HORIZONTAL_XL,
                    runSpacing: AppConstants.SPACE_VERTICAL_XL,
                    children: List.generate(quickSearchItems.length, (index) {
                      final item = quickSearchItems[index];
                      return QuickSearchItem(item: item);
                    }),
                  ),
                ),
              ),
            ),
            AppConstants.SPACE_VERTICAL_XXL.heightSizedBox,
            // title recent searches
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
              child: Text(
                "Recent searches",
                style: themeData.textTheme.titleMedium,
              ),
            ),
            AppConstants.SPACE_VERTICAL_XL.heightSizedBox,
            // list recent searches
            BlocBuilder<SearchBloc, SearchState>(
              buildWhen: (previous, current) => previous.recentSearches != current.recentSearches,
              builder: (context, state) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      state.recentSearches.length,
                      (index) {
                        final i = state.recentSearches.length - 1 - index;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppConstants.SPACE_VERTICAL_M),
                          child: Text(
                            state.recentSearches[i],
                            style: themeData.textTheme.titleSmall,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            // blanck space
            Flexible(
              child: GestureDetector(
                onTap: onDismiss,
                child: Container(
                  color: AppTheme.transparent,
                  width: double.infinity,
                ),
              ),
            ),
            // search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
              child: SearchOverlayBar(
                focusNode: focusNode,
                onDismiss: onDismiss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
