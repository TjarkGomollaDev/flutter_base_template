// Pure-Dart markdown convention checker.
import 'dart:io';

import 'comment_checker.dart';

// Verifies markdown structure and prevents forbidden formatting constructs.
class MarkdownChecker {
  const MarkdownChecker();

  // Runs all markdown checks on the provided file.
  List<ConventionViolation> checkFile(String filePath, [String? content]) {
    final normalized = filePath.replaceAll(r'\', '/');
    if (_isGenerated(normalized) || !normalized.endsWith('.md')) {
      return const <ConventionViolation>[];
    }

    final source = content ?? File(filePath).readAsStringSync();
    return checkSource(normalized, source);
  }

  // Runs markdown checks on in-memory markdown content.
  List<ConventionViolation> checkSource(String filePath, String source) {
    final lines = source.split('\n');
    final violations = <ConventionViolation>[];

    var inFrontmatter = false;
    var inCodeBlock = false;
    String? fenceMarker;

    for (var i = 0; i < lines.length; i++) {
      final lineNumber = i + 1;
      final rawLine = lines[i];
      final line = rawLine.endsWith('\r')
          ? rawLine.substring(0, rawLine.length - 1)
          : rawLine;
      final trimmed = line.trim();

      // Allow YAML frontmatter at start of file.
      if (i == 0 && trimmed == '---') {
        inFrontmatter = true;
        continue;
      }
      if (inFrontmatter) {
        if (trimmed == '---') {
          inFrontmatter = false;
        }
        continue;
      }

      // Allow fenced code blocks.
      if (!inCodeBlock) {
        final fenceMatch = _codeFenceRegex.firstMatch(trimmed);
        if (fenceMatch != null) {
          inCodeBlock = true;
          fenceMarker = fenceMatch.group(1)!;
          continue;
        }
      } else {
        if (fenceMarker != null &&
            trimmed.startsWith(fenceMarker) &&
            trimmed.length >= fenceMarker.length) {
          inCodeBlock = false;
          fenceMarker = null;
        }
        continue;
      }

      // Exclude table divider lines containing a vertical bar.
      if (line.contains('|')) {
        continue;
      }

      // Disallow standalone horizontal dividers.
      if (_horizontalRuleRegex.hasMatch(trimmed)) {
        violations.add(
          ConventionViolation(
            rule: 'no_horizontal_rules',
            filePath: filePath,
            line: lineNumber,
            message:
                "Horizontal rule divider '$trimmed' is forbidden. Structure content using headings (##, ###) instead.",
            fixHint: 'Remove the horizontal divider line.',
          ),
        );
      }
    }

    return violations;
  }
}

// Regex matching 3 or more identical characters with optional spaces.
final RegExp _horizontalRuleRegex = RegExp(
  r'^\s*(?:-(?:\s*-){2,}|\*(?:\s*\*){2,}|_(?:\s*_){2,})\s*$',
);

// Regex matching fenced code block markers with at least 3 characters.
final RegExp _codeFenceRegex = RegExp(r'^(`{3,}|~{3,})');

bool _isGenerated(String path) {
  return path.contains('/.dart_tool/') ||
      path.startsWith('.dart_tool/') ||
      path.contains('/build/') ||
      path.startsWith('build/');
}
