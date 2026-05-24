// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_base_template/1st_layer_presentation/core_widgets.dart/core_formatted_chat_text.dart';

class CoreTypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final VoidCallback? onCharacterTyped;
  final VoidCallback? onAnimationEnd;
  final Duration speed;

  const CoreTypewriterText({
    super.key,
    required this.text,
    this.style,
    this.onCharacterTyped,
    this.onAnimationEnd,
    this.speed = const Duration(milliseconds: 30),
  });

  @override
  _CoreTypewriterTextState createState() => _CoreTypewriterTextState();
}

class _CoreTypewriterTextState extends State<CoreTypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.text.length * widget.speed.inMilliseconds),
      vsync: this,
    )
      ..addListener(() {
        widget.onCharacterTyped?.call();
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationEnd?.call();
        }
      });
    _charCount = StepTween(begin: 0, end: widget.text.length).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        final displayText = widget.text.substring(0, _charCount.value);
        return CoreFormattedChatText(
          text: displayText,
          style: widget.style,
        );
      },
    );
  }
}
