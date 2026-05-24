import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/home/widgets/chat_tile.dart';
import 'package:flutter_base_template/app_constants.dart';

class FavoritesChatsList extends StatelessWidget {
  const FavoritesChatsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.PAGE_PADDING_HORIZONTAL),
      child: Column(
        children: List.generate(4, (index) {
          return const ChatTile();
        }),
      ),
    );
  }
}
