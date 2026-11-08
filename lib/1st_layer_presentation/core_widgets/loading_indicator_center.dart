import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets/core_loading_indicator.dart';

class LoadingIndicatorCenter {
  static final _overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return const Stack(
        children: [
          AbsorbPointer(child: SizedBox.expand()),
          CoreLoadingIndicator(),
        ],
      );
    },
  );

  static void showLoadingIndicator(BuildContext context) {
    if (_overlayEntry.mounted) return;
    Overlay.of(context).insert(_overlayEntry);
  }

  static void hideLoadingIndicator() {
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
  }
}
