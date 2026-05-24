import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mark_lxxxv/1st_layer_presentation/search/search_overlay.dart';

class CoreOverlayWrapper extends StatefulWidget {
  final Widget child;

  const CoreOverlayWrapper({
    super.key,
    required this.child,
  });

  @override
  State<CoreOverlayWrapper> createState() => _CoreOverlayWrapperState();
}

class _CoreOverlayWrapperState extends State<CoreOverlayWrapper> {
  final FocusNode _focusNode = FocusNode();

  double _overlayOpacity = 0.0;
  bool _isOverlayLocked = false;
  bool _canShowOverlay = true;

  void _showSearchOverlay() {
    setState(() {
      _overlayOpacity = 1.0;
      _isOverlayLocked = true;
    });
    _focusNode.requestFocus();
  }

  void _hideSearchOverlay() {
    setState(() {
      _overlayOpacity = 0.0;
      _isOverlayLocked = false;
      _canShowOverlay = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    const double maxOverscroll = 40.0;

    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (_isOverlayLocked) {
              // If overlay is locked and user scrolls up, unlock it
              if (notification is UserScrollNotification &&
                  notification.direction == ScrollDirection.reverse) {
                _hideSearchOverlay();
              }
              return true;
            }

            if (notification is ScrollStartNotification) {
              _canShowOverlay = notification.metrics.pixels == 0.0;
            }

            if (_canShowOverlay && notification is ScrollUpdateNotification) {
              if (notification.metrics.pixels < 0 &&
                  notification.metrics.axisDirection == AxisDirection.down) {
                // Calculate opacity based on the negative scroll offset (bounce effect)
                double overscroll = notification.metrics.pixels.abs().clamp(0.0, maxOverscroll);
                double opacity = (overscroll / maxOverscroll).clamp(0.0, 1.0);

                setState(() {
                  _overlayOpacity = opacity;
                });
              } else if (_overlayOpacity > 0.0) {
                setState(() {
                  _overlayOpacity = 0.0;
                });
              }

              // Lock the overlay if opacity reaches 1.0 and scrolling stops
              if (_overlayOpacity == 1.0 && notification.dragDetails == null) {
                _showSearchOverlay();
              }
            }

            return true;
          },
          child: widget.child,
        ),
        // Overlay with dynamic opacity
        Opacity(
          opacity: _overlayOpacity,
          child: IgnorePointer(
            ignoring: _overlayOpacity < 1.0,
            child: SearchOverlay(
              focusNode: _focusNode,
              onDismiss: _hideSearchOverlay,
            ),
          ),
        ),
      ],
    );
  }
}
