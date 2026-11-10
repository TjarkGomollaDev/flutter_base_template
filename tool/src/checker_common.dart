// Shared data models and utilities for Dart convention checkers.

// Represents a convention violation with rule identifier, file location, and actionable fix hint.
class ConventionViolation {
  final String rule;
  final String filePath;
  final int line;
  final String message;
  final String fixHint;

  const ConventionViolation({
    required this.rule,
    required this.filePath,
    required this.line,
    required this.message,
    required this.fixHint,
  });

  @override
  String toString() => '[$rule] $filePath:$line: $message ($fixHint)';
}

// Manages file-level and line-level convention exemptions.
class IgnoredRules {
  final Map<int, Set<String>> _lineIgnores = <int, Set<String>>{};
  final Set<String> _fileIgnores = <String>{};

  // Registers a rule exemption for the entire file.
  void addFileIgnore(String rule) {
    _fileIgnores.add(rule);
  }

  // Registers a rule exemption for a specific line number.
  void addLineIgnore(int line, String rule) {
    _lineIgnores.putIfAbsent(line, () => <String>{}).add(rule);
  }

  // Determines whether a rule violation on the given line should be suppressed.
  bool isIgnored(String rule, int line) {
    if (_fileIgnores.contains(rule)) return true;
    final lineSet = _lineIgnores[line];
    return lineSet != null && lineSet.contains(rule);
  }
}

// Regex matching file-level convention ignore comments with justification.
final RegExp conventionIgnoreFileRegex = RegExp(
  r'//\s*convention-ignore-file:\s*([a-zA-Z0-9_-]+)\s+(\S.*)$',
);

// Regex matching line-level convention ignore comments with justification.
final RegExp conventionIgnoreLineRegex = RegExp(
  r'//\s*convention-ignore:\s*([a-zA-Z0-9_-]+)\s+(\S.*)$',
);

// Collects all file-level and line-level convention exemptions from raw source text.
IgnoredRules collectIgnoresFromSource(String source) {
  final result = IgnoredRules();
  final lines = source.split('\n');

  for (var i = 0; i < lines.length; i++) {
    final lineNum = i + 1;
    final line = lines[i];

    final fileMatch = conventionIgnoreFileRegex.firstMatch(line);
    if (fileMatch != null) {
      result.addFileIgnore(fileMatch.group(1)!);
      continue;
    }

    final lineMatch = conventionIgnoreLineRegex.firstMatch(line);
    if (lineMatch != null) {
      final rule = lineMatch.group(1)!;
      result.addLineIgnore(lineNum, rule);
      result.addLineIgnore(lineNum + 1, rule);
    }
  }

  return result;
}

// Replaces string literals and comments with whitespace to preserve line and column offsets.
String stripCommentsAndStrings(String source) {
  final buffer = StringBuffer();
  final length = source.length;
  var index = 0;

  while (index < length) {
    final char = source[index];

    // Check for raw string prefix.
    final isRaw =
        (char == 'r' || char == 'R') &&
        index + 1 < length &&
        (source[index + 1] == "'" || source[index + 1] == '"');

    final quoteStart = isRaw ? index + 1 : index;
    final quoteChar = quoteStart < length ? source[quoteStart] : '';

    if (quoteChar == "'" || quoteChar == '"') {
      final isTriple =
          quoteStart + 2 < length &&
          source[quoteStart + 1] == quoteChar &&
          source[quoteStart + 2] == quoteChar;

      final start = index;
      index = isTriple ? quoteStart + 3 : quoteStart + 1;

      while (index < length) {
        final c = source[index];
        if (!isRaw && c == r'\' && index + 1 < length) {
          index += 2;
          continue;
        }
        if (isTriple) {
          if (c == quoteChar &&
              index + 2 < length &&
              source[index + 1] == quoteChar &&
              source[index + 2] == quoteChar) {
            index += 3;
            break;
          }
        } else {
          if (c == quoteChar) {
            index++;
            break;
          }
          if (c == '\n') break;
        }
        index++;
      }

      for (var i = start; i < index; i++) {
        final c = source[i];
        buffer.write(c == '\n' ? '\n' : ' ');
      }
      continue;
    }

    // Check for block comments.
    if (char == '/' && index + 1 < length && source[index + 1] == '*') {
      final start = index;
      var depth = 1;
      index += 2;
      while (index < length && depth > 0) {
        if (source[index] == '/' &&
            index + 1 < length &&
            source[index + 1] == '*') {
          depth++;
          index += 2;
          continue;
        }
        if (source[index] == '*' &&
            index + 1 < length &&
            source[index + 1] == '/') {
          depth--;
          index += 2;
          continue;
        }
        index++;
      }
      for (var i = start; i < index; i++) {
        final c = source[i];
        buffer.write(c == '\n' ? '\n' : ' ');
      }
      continue;
    }

    // Check for line comments.
    if (char == '/' && index + 1 < length && source[index + 1] == '/') {
      final start = index;
      while (index < length && source[index] != '\n' && source[index] != '\r') {
        index++;
      }
      for (var i = start; i < index; i++) {
        buffer.write(' ');
      }
      continue;
    }

    buffer.write(char);
    index++;
  }

  return buffer.toString();
}

// Computes 1-based line number for a character offset in source text.
int getLineNumber(String source, int index) {
  var line = 1;
  for (var i = 0; i < index && i < source.length; i++) {
    if (source[i] == '\n') line++;
  }
  return line;
}

// Determines whether a file path points to generated code excluded from checks.
bool isGeneratedPath(String path) {
  final normalized = path.replaceAll(r'\', '/');
  return normalized.contains('lib/l10n/app_localizations') ||
      normalized.endsWith('.g.dart') ||
      normalized.endsWith('.freezed.dart') ||
      normalized.contains('/.dart_tool/') ||
      normalized.startsWith('.dart_tool/') ||
      normalized.contains('/build/') ||
      normalized.startsWith('build/');
}
