import 'package:flutter/material.dart';

class CoreFormattedChatText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CoreFormattedChatText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _parseMessageWithBold(),
        style: style,
      ),
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  List<TextSpan> _parseMessageWithBold() {
    final List<TextSpan> spans = [];
    final regex = RegExp(r"\*\*(.*?)\*\*");
    final matches = regex.allMatches(text);
    int start = 0;

    for (final match in matches) {
      // normal text before the match
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      // bold text
      spans.add(
        TextSpan(
          // capture group 1, which is the text inside **
          text: match.group(1),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      start = match.end;
    }

    // remaining text after the last match
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}
