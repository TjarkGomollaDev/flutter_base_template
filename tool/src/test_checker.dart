// Pure-Dart test convention checker.
import 'dart:io';

import 'comment_checker.dart';

// Verifies test structure, assertions, finders, and wait conventions.
class TestChecker {
  const TestChecker();

  // Runs all test checks on the provided file.
  List<ConventionViolation> checkFile(String filePath, [String? content]) {
    final normalized = filePath.replaceAll(r'\', '/');
    if (_isGenerated(normalized) || !normalized.endsWith('_test.dart')) {
      return const <ConventionViolation>[];
    }

    final source = content ?? File(filePath).readAsStringSync();
    return checkSource(normalized, source);
  }

  // Runs test checks on in-memory test source content.
  List<ConventionViolation> checkSource(String filePath, String source) {
    final violations = <ConventionViolation>[];
    final ignores = _collectIgnores(source);

    bool isIgnored(String rule, int line) {
      final fileRules = ignores[-1];
      if (fileRules != null && fileRules.contains(rule)) {
        return true;
      }
      final lineRules = ignores[line];
      return lineRules != null && lineRules.contains(rule);
    }

    final stripped = _stripCommentsAndStrings(source);
    _checkTestBlocks(filePath, source, stripped, violations, isIgnored);
    _checkFileWideRules(filePath, stripped, violations, isIgnored);

    return violations;
  }

  bool _isGenerated(String path) {
    return path.contains('lib/l10n/app_localizations') ||
        path.endsWith('.g.dart') ||
        path.endsWith('.freezed.dart') ||
        path.contains('/.dart_tool/') ||
        path.startsWith('.dart_tool/') ||
        path.contains('/build/') ||
        path.startsWith('build/');
  }

  Map<int, Set<String>> _collectIgnores(String source) {
    final result = <int, Set<String>>{};
    final lines = source.split('\n');
    final regex = RegExp(
      r'//\s*convention-ignore:\s*([a-zA-Z0-9_-]+)\s+(\S.*)$',
    );

    for (var i = 0; i < lines.length; i++) {
      final lineNum = i + 1;
      final match = regex.firstMatch(lines[i]);
      if (match != null) {
        final rule = match.group(1)!;
        if (lineNum < 30) {
          result.putIfAbsent(-1, () => <String>{}).add(rule);
        }
        result.putIfAbsent(lineNum, () => <String>{}).add(rule);
        result.putIfAbsent(lineNum + 1, () => <String>{}).add(rule);
      }
    }
    return result;
  }

  void _checkTestBlocks(
    String filePath,
    String source,
    String stripped,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final testRegex = RegExp(r'\b(test|testWidgets)\s*\(');
    final matches = testRegex.allMatches(stripped);

    for (final match in matches) {
      final openParen = match.end - 1;
      final startLine = _getLineNumber(source, match.start);

      final descInfo = _extractStringLiteral(source, openParen + 1);
      if (descInfo == null) continue;

      if (!isIgnored('test_name', startLine)) {
        if (descInfo.value.contains('\n')) {
          violations.add(
            ConventionViolation(
              rule: 'test_name',
              filePath: filePath,
              line: descInfo.line,
              message: 'Test description must not contain embedded newlines',
              fixHint: 'Keep test description on a single line',
            ),
          );
        }

        if (descInfo.value.length > 100) {
          violations.add(
            ConventionViolation(
              rule: 'test_name',
              filePath: filePath,
              line: descInfo.line,
              message:
                  'Test description must not exceed 100 characters (found ${descInfo.value.length})',
              fixHint: 'Shorten test description to <= 100 characters',
            ),
          );
        }
      }

      final body = _extractTestBody(source, descInfo.endIndex);
      if (body == null) continue;

      if (!isIgnored('missing_assertion', startLine)) {
        final hasAssertion = _hasAssertion(body.code);
        if (!hasAssertion) {
          violations.add(
            ConventionViolation(
              rule: 'missing_assertion',
              filePath: filePath,
              line: startLine,
              message: 'Test body does not contain any assertion calls',
              fixHint:
                  'Add expect(...), expectLater(...), or verify(...) to test real behavior',
            ),
          );
        }
      }

      if (!isIgnored('trivial_assertion', startLine)) {
        if (_hasOnlyTrivialAssertions(body.code)) {
          violations.add(
            ConventionViolation(
              rule: 'trivial_assertion',
              filePath: filePath,
              line: startLine,
              message:
                  'Test contains only trivial assertions (isNotNull, returnsNormally, or untyped isA)',
              fixHint:
                  'Assert specific states, values, or widget finders instead of trivial existence',
            ),
          );
        }
      }
    }
  }

  void _checkFileWideRules(
    String filePath,
    String stripped,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final layoutRegex = RegExp(
      r'find\.byType\(\s*(Padding|Container|SizedBox|Column|Row|Center|Expanded|Flexible|Align|Stack|Wrap)\b',
    );
    for (final match in layoutRegex.allMatches(stripped)) {
      final line = _getLineNumber(stripped, match.start);
      if (isIgnored('no_layout_finders', line)) continue;

      final widget = match.group(1)!;
      violations.add(
        ConventionViolation(
          rule: 'no_layout_finders',
          filePath: filePath,
          line: line,
          message: 'Using find.byType($widget) targets generic layout widgets',
          fixHint:
              "Use Key('<screen>_<element>'), unique icons, or Semantics instead",
        ),
      );
    }

    final realWaitRegex = RegExp(r'\b(Future(?:<void>)?\.delayed|sleep)\s*\(');
    for (final match in realWaitRegex.allMatches(stripped)) {
      final line = _getLineNumber(stripped, match.start);
      if (isIgnored('no_real_waits', line)) continue;

      if (_isInsideAsyncHelper(stripped, match.start)) continue;

      violations.add(
        ConventionViolation(
          rule: 'no_real_waits',
          filePath: filePath,
          line: line,
          message: 'Real time waits (${match.group(1)}) are forbidden in tests',
          fixHint:
              'Use tester.pump, tester.pumpAndSettle, fakeAsync, or mock dependencies',
        ),
      );
    }
  }

  bool _isInsideAsyncHelper(String source, int index) {
    final prefix = source.substring(0, index);
    final lastRunAsync = prefix.lastIndexOf('runAsync');
    final lastFakeAsync = prefix.lastIndexOf('fakeAsync');
    final helperIdx = lastRunAsync > lastFakeAsync
        ? lastRunAsync
        : lastFakeAsync;
    if (helperIdx == -1) return false;

    final openBrace = source.indexOf('{', helperIdx);
    if (openBrace == -1 || openBrace > index) return false;

    var depth = 1;
    for (var i = openBrace + 1; i < source.length; i++) {
      if (i == index) return depth > 0;
      if (source[i] == '{') depth++;
      if (source[i] == '}') {
        depth--;
        if (depth == 0) return false;
      }
    }
    return false;
  }

  bool _hasAssertion(String body) {
    final assertionRegex = RegExp(
      r'\b(expect|expectLater|verify|verifyNever|fail|expect\w+)\s*\(',
    );
    return assertionRegex.hasMatch(body);
  }

  bool _hasOnlyTrivialAssertions(String body) {
    final expectRegex = RegExp(r'\b(?:expect|expectLater)\s*\(');
    final matches = expectRegex.allMatches(body).toList();
    if (matches.isEmpty) return false;

    for (final match in matches) {
      final openParen = match.end - 1;
      final args = _extractArguments(body, openParen);
      if (args == null || args.length < 2) {
        return false;
      }

      final matcherArg = args[1].trim();
      final isTrivial =
          matcherArg == 'isNotNull' ||
          matcherArg == 'returnsNormally' ||
          matcherArg == 'isA()' ||
          matcherArg == 'isA<dynamic>()' ||
          matcherArg == 'isA<Object>()' ||
          matcherArg == 'isA<Object?>()';

      if (!isTrivial) {
        return false;
      }
    }

    return true;
  }

  List<String>? _extractArguments(String code, int openParenIndex) {
    if (openParenIndex >= code.length || code[openParenIndex] != '(') {
      return null;
    }

    var depth = 1;
    var current = StringBuffer();
    final args = <String>[];
    var inSingle = false;
    var inDouble = false;

    for (var i = openParenIndex + 1; i < code.length; i++) {
      final c = code[i];

      if (!inDouble && c == "'") {
        if (i == 0 || code[i - 1] != r'\') {
          inSingle = !inSingle;
        }
      } else if (!inSingle && c == '"') {
        if (i == 0 || code[i - 1] != r'\') {
          inDouble = !inDouble;
        }
      }

      if (!inSingle && !inDouble) {
        if (c == '(' || c == '{' || c == '[') {
          depth++;
        } else if (c == ')' || c == '}' || c == ']') {
          depth--;
          if (depth == 0) {
            args.add(current.toString().trim());
            return args;
          }
        } else if (c == ',' && depth == 1) {
          args.add(current.toString().trim());
          current = StringBuffer();
          continue;
        }
      }

      current.write(c);
    }

    return null;
  }

  _StringLiteral? _extractStringLiteral(String source, int startIndex) {
    var index = startIndex;
    while (index < source.length &&
        (source[index] == ' ' ||
            source[index] == '\t' ||
            source[index] == '\n' ||
            source[index] == '\r')) {
      index++;
    }

    if (index >= source.length) return null;

    final isRaw =
        (source[index] == 'r' || source[index] == 'R') &&
        index + 1 < source.length &&
        (source[index + 1] == "'" || source[index + 1] == '"');

    final quoteStart = isRaw ? index + 1 : index;
    if (quoteStart >= source.length) return null;

    final quote = source[quoteStart];
    if (quote != "'" && quote != '"') return null;

    final isTriple =
        quoteStart + 2 < source.length &&
        source[quoteStart + 1] == quote &&
        source[quoteStart + 2] == quote;

    final contentStart = isTriple ? quoteStart + 3 : quoteStart + 1;
    var i = contentStart;
    final buffer = StringBuffer();
    final line = _getLineNumber(source, index);

    while (i < source.length) {
      final c = source[i];
      if (!isRaw && c == r'\' && i + 1 < source.length) {
        buffer.write(c);
        buffer.write(source[i + 1]);
        i += 2;
        continue;
      }

      if (isTriple) {
        if (c == quote &&
            i + 2 < source.length &&
            source[i + 1] == quote &&
            source[i + 2] == quote) {
          return _StringLiteral(
            value: buffer.toString(),
            line: line,
            endIndex: i + 3,
          );
        }
      } else {
        if (c == quote) {
          return _StringLiteral(
            value: buffer.toString(),
            line: line,
            endIndex: i + 1,
          );
        }
        if (c == '\n') {
          return _StringLiteral(
            value: buffer.toString(),
            line: line,
            endIndex: i,
          );
        }
      }

      buffer.write(c);
      i++;
    }

    return null;
  }

  _TestBody? _extractTestBody(String source, int startIndex) {
    final openBrace = source.indexOf('{', startIndex);
    if (openBrace == -1) return null;

    final nextSemi = source.indexOf(';', startIndex);
    if (nextSemi != -1 && openBrace > nextSemi) return null;

    var depth = 1;
    var inSingle = false;
    var inDouble = false;
    final buffer = StringBuffer();

    for (var i = openBrace + 1; i < source.length; i++) {
      final c = source[i];

      if (!inDouble && c == "'") {
        if (i == 0 || source[i - 1] != r'\') {
          inSingle = !inSingle;
        }
      } else if (!inSingle && c == '"') {
        if (i == 0 || source[i - 1] != r'\') {
          inDouble = !inDouble;
        }
      }

      if (!inSingle && !inDouble) {
        if (c == '{') depth++;
        if (c == '}') {
          depth--;
          if (depth == 0) {
            return _TestBody(code: buffer.toString());
          }
        }
      }

      buffer.write(c);
    }

    return null;
  }

  String _stripCommentsAndStrings(String source) {
    final buffer = StringBuffer();
    final length = source.length;
    var index = 0;

    while (index < length) {
      final char = source[index];

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

      if (char == '/' && index + 1 < length && source[index + 1] == '/') {
        final start = index;
        while (index < length &&
            source[index] != '\n' &&
            source[index] != '\r') {
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

  int _getLineNumber(String source, int index) {
    var line = 1;
    for (var i = 0; i < index && i < source.length; i++) {
      if (source[i] == '\n') line++;
    }
    return line;
  }
}

class _StringLiteral {
  const _StringLiteral({
    required this.value,
    required this.line,
    required this.endIndex,
  });

  final String value;
  final int line;
  final int endIndex;
}

class _TestBody {
  const _TestBody({required this.code});

  final String code;
}
