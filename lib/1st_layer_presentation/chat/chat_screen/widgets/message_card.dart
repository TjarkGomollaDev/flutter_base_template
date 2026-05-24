import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_base_template/app_theme.dart';
import 'package:flutter_base_template/core/enums/message_type.dart';
import 'package:flutter_base_template/core/extensions/build_context_extensions.dart';

class MessageCard extends StatelessWidget {
  final String message;
  final MessageType messageType;
  final DateTime timeSent;
  final bool isMyMessage;
  final bool isSeen;
  final bool isSpeechBubble;

  const MessageCard({
    super.key,
    required this.isMyMessage,
    required this.message,
    required this.messageType,
    required this.timeSent,
    required this.isSeen,
    required this.isSpeechBubble,
  });

  @override
  Widget build(BuildContext context) {
    final size = context.sizeOf;
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 90, minWidth: 110),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: isMyMessage
                  ? AppTheme.blueLight
                  // Apple Dark Mode Color: const Color.fromRGBO(59, 59, 61, 1)
                  : const Color.fromARGB(255, 233, 233, 235),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                    padding: messageType == MessageType.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            top: 5,
                            right: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: TextStyle(
                              fontSize: 16, color: isMyMessage ? AppTheme.white : AppTheme.black),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: isMyMessage ? 4 : 2,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          DateFormat('HH:mm').format(timeSent),
                          style: TextStyle(
                            fontSize: 13,
                            color: isMyMessage ? AppTheme.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (isMyMessage)
                          Icon(
                            isSeen ? Icons.done_all : Icons.done,
                            size: 20,
                            color: isSeen ? const Color.fromARGB(255, 6, 71, 135) : Colors.white60,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isSpeechBubble)
            Positioned(
              left: isMyMessage ? null : 11,
              right: isMyMessage ? 11 : null,
              bottom: -2,
              child: Transform.rotate(
                angle: isMyMessage ? 4.2 : 2 * pi - 4.2,
                child: CustomPaint(
                  painter: CurvedTrianglePainter(isMyMessage: isMyMessage),
                  size: const Size.square(15),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class CurvedTrianglePainter extends CustomPainter {
  final bool isMyMessage;

  CurvedTrianglePainter({
    this.isMyMessage = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = isMyMessage ? AppTheme.blueLight : const Color.fromARGB(255, 233, 233, 235);

    final Path path = Path();

    if (isMyMessage) {
      path
        ..moveTo(size.width, size.height)
        ..quadraticBezierTo(size.width * 0.9, size.height * 0.45, 0, size.height)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.25, size.width, 0)
        ..close();
    } else {
      path
        ..moveTo(0, size.height)
        ..quadraticBezierTo(size.width * 0.1, size.height * 0.45, size.width, size.height)
        ..quadraticBezierTo(size.width * 0.5, size.height * 0.25, 0, 0)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
