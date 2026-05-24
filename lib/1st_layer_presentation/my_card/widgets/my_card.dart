import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';

class MyCard extends StatelessWidget {
  final Widget content;

  const MyCard({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.sizeOf;
    final cardWidth = size.width - AppConstants.PAGE_PADDING_HORIZONTAL * 2;
    final cardHeight = 3 / 5 * cardWidth;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.SPACE_VERTICAL_XXL),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/backgrounds/my_card_background2.png'),
                fit: BoxFit.fitWidth),
          ),
          child: Container(
            height: cardHeight,
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              border: Border.all(color: Colors.white.withAlpha(38)),
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
