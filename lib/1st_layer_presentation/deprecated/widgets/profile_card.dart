import 'package:flutter/material.dart';
import 'package:mark_lxxxv/app_constants.dart';
import 'package:mark_lxxxv/core/extensions/build_context_extensions.dart';

class ProfileCard extends StatelessWidget {
  final Widget content;

  const ProfileCard({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.sizeOf;
    final cardWidth = size.width - AppConstants.PAGE_PADDING_HORIZONTAL * 2;
    final cardHeight = 3 / 5 * cardWidth;
    return Container(
      height: cardHeight,
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(AppConstants.RADIUS_L),
        border: Border.all(color: Colors.white.withAlpha(38)),
      ),
      child: content,
    );
  }
}
