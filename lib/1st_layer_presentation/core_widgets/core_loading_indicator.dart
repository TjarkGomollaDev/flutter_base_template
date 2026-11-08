import 'package:flutter/material.dart';
import 'package:flutter_base_template/app_constants.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class CoreLoadingIndicator extends StatelessWidget {
  const CoreLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 60,
        height: 60,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.RADIUS_M),
          color: context.colorPalette.onPrimary.withAlpha(90),
        ),
        child: Center(
          child: CircularProgressIndicator(color: context.colorPalette.primary),
        ),
      ),
    );
  }
}
