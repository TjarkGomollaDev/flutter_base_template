import 'package:flutter/material.dart';
import 'package:mark_lxxxv/1st_layer_presentation/core_widgets.dart/core_loading_indicator.dart';

class LoadingIndicatorCenter {
  static final _overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Stack(
        children: [
          // disables the UI in the background
          const AbsorbPointer(child: SizedBox.expand()),
          // loading indicator
          CoreLoadingIndicator(),
        ],
      );
    },
  );

  static void showLoadingIndicator(BuildContext context) {
    Overlay.of(context).insert(_overlayEntry);
  }

  // always make sure that the loading indicator is deactivated after each activation
  static void hideLoadingIndicator() {
    if (_overlayEntry.mounted) {
      _overlayEntry.remove();
    }
  }
}
