import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets/core_loading_indicator.dart';

// Manages a modal loading overlay centered across the active screen.
class LoadingIndicatorCenter {
  static OverlayEntry? _overlayEntry;

  // Displays the blocking center loading indicator on top of the active overlay.
  static void showLoadingIndicator(BuildContext context) {
    if (_overlayEntry != null) return;
    final entry = OverlayEntry(
      builder: (BuildContext context) {
        return const Stack(
          children: [
            AbsorbPointer(child: SizedBox.expand()),
            CoreLoadingIndicator(),
          ],
        );
      },
    );
    _overlayEntry = entry;
    Overlay.of(context).insert(entry);
  }

  // Removes the active loading indicator from the overlay tree and clears its reference.
  static void hideLoadingIndicator() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
