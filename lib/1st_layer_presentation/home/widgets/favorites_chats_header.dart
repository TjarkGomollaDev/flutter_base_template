import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_template/2nd_layer_application/application/application_bloc/application_bloc.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class FavoritesChatsHeader extends StatelessWidget {
  const FavoritesChatsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            'Messages',
            style: textTheme.titleLarge,
          ),
          GestureDetector(
            onTap: () => context
                .read<ApplicationBloc>()
                .add(const ApplicationEventChangePageIndex(index: 3)),
            child: Text(
              'See all',
              style: textTheme.labelLarge,
            ),
          ),
        ],
      ),
    );
  }
}
