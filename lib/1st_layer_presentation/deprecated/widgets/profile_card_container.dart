import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_template/1st_layer_presentation/deprecated/widgets/content_back.dart';
import 'package:flutter_base_template/1st_layer_presentation/deprecated/widgets/content_front.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_base_template/1st_layer_presentation/deprecated/widgets/profile_card.dart';

class ProfileCardContainer extends StatefulWidget {
  const ProfileCardContainer({super.key});

  @override
  State<ProfileCardContainer> createState() => _ProfileCardContainerState();
}

class _ProfileCardContainerState extends State<ProfileCardContainer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double? tiltDirectionX;
  double? tiltDirectionY;
  double horizontalDrag = 0;
  double verticalDrag = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    userAccelerometerEventStream().listen((UserAccelerometerEvent event) {
      tiltDirectionX = event.x;
      tiltDirectionY = event.y;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  // flips the card
  void _flip() {
    setState(() {
      if (_animationController.isCompleted || _animationController.velocity > 0) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  // calculate the amount of horizontal and vertical drag
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      if (horizontalDrag < -0.5) {
        horizontalDrag = -0.5;
      } else if (horizontalDrag > 0.5) {
        horizontalDrag = 0.5;
      } else {
        horizontalDrag += details.delta.dx * 0.003;
      }
      if (verticalDrag < -0.3) {
        verticalDrag = -0.3;
      } else if (verticalDrag > 0.3) {
        verticalDrag = 0.3;
      } else {
        verticalDrag += details.delta.dy * 0.003;
      }
    });
  }

  // reset drag values to 0 when the drag ends
  void _onPanEnd(DragEndDetails details) {
    setState(() {
      horizontalDrag = 0;
      verticalDrag = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ensures that the BackdropFilter does not cover the entire screen
    return ClipRect(
      child: Stack(
        children: [
          // background image
          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/MARK_LXXXV_Artwork_5.png',
              fit: BoxFit.cover,
            ),
          ),
          // background blur
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 35,
              sigmaY: 35,
            ),
            child: const SizedBox(),
          ),
          // enables the turning of the card, by dragging
          GestureDetector(
            onTap: _flip,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            // is used to enable the tilting, by using the animationController
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final isFront = _animationController.value < 0.5;
                return Transform(
                  alignment: FractionalOffset.center,
                  // transformation when dragging the card
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(3.14 * _animationController.value + horizontalDrag)
                    ..rotateX(verticalDrag),
                  child: Center(
                    // show the front or back of the profile card
                    child: isFront ? const ProfileCard(content: ContentFront()) : const ProfileCard(content: ContentBack()),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
