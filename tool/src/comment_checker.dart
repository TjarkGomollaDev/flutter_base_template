// Pure-Dart comment convention checker with quote-aware scanning.
import 'dart:io';

import 'checker_common.dart';

// Scanned comment token extracted from Dart source code.
class _CommentToken {
  _CommentToken({
    required this.line,
    required this.column,
    required this.isFullLine,
    required this.isDoc,
    required this.raw,
    required this.text,
  });

  final int line;
  final int column;
  final bool isFullLine;
  final bool isDoc;
  final String raw;
  final String text;

  bool get isIgnoreDirective =>
      raw.startsWith('// ignore:') || raw.startsWith('// ignore_for_file:');

  bool get isConventionIgnore =>
      raw.startsWith('// convention-ignore:') ||
      raw.startsWith('// convention-ignore-file:');

  bool get isDartFormatDirective =>
      raw.startsWith('// dart format off') ||
      raw.startsWith('// dart format on');

  bool get isDirective =>
      isIgnoreDirective || isConventionIgnore || isDartFormatDirective;

  static final _bannerStart = RegExp(r'^[#/=\-*~]{3,}');
  static final _bannerContent = RegExp(r'[#=]{4,}');

  bool get isBanner {
    final trimmed = text.trim();
    return _bannerStart.hasMatch(trimmed) || _bannerContent.hasMatch(trimmed);
  }
}

// Scans Dart files and verifies compliance with comment conventions.
class CommentChecker {
  const CommentChecker();

  // Runs all comment checks on the provided file.
  List<ConventionViolation> checkFile(String filePath, [String? content]) {
    final normalized = filePath.replaceAll(r'\', '/');
    if (isGeneratedPath(normalized)) {
      return const <ConventionViolation>[];
    }

    final source = content ?? File(filePath).readAsStringSync();
    return checkSource(normalized, source);
  }

  // Runs all comment checks on in-memory source content.
  List<ConventionViolation> checkSource(String filePath, String source) {
    final tokens = _scanComments(source);
    final violations = <ConventionViolation>[];

    final ignores = _collectIgnores(tokens);
    bool isIgnored(String rule, int line) => ignores.isIgnored(rule, line);

    _checkConventionIgnoreFormat(tokens, filePath, violations);
    _checkDocumentedIgnores(tokens, filePath, violations, isIgnored);
    _checkDocWhitelist(tokens, filePath, violations, isIgnored);
    _checkBanners(tokens, filePath, violations, isIgnored);
    _checkEmDashes(tokens, filePath, violations, isIgnored);
    _checkBlockLengths(tokens, filePath, violations, isIgnored);
    _checkParagraphs(tokens, filePath, violations, isIgnored);

    return violations;
  }

  // Parses source into comment tokens using quote-aware character scanning.
  List<_CommentToken> _scanComments(String source) {
    final tokens = <_CommentToken>[];
    final length = source.length;
    var index = 0;
    var line = 1;
    var lineStart = 0;

    while (index < length) {
      final char = source[index];

      if (char == '\n') {
        line++;
        lineStart = index + 1;
        index++;
        continue;
      }

      if (char == '\r') {
        index++;
        continue;
      }

      // Check for raw string prefixes.
      final isRaw =
          (char == 'r' || char == 'R') &&
          index + 1 < length &&
          (source[index + 1] == "'" || source[index + 1] == '"');

      final quoteStart = isRaw ? index + 1 : index;
      final quoteChar = source[quoteStart];

      if (quoteChar == "'" || quoteChar == '"') {
        final isTriple =
            quoteStart + 2 < length &&
            source[quoteStart + 1] == quoteChar &&
            source[quoteStart + 2] == quoteChar;

        index = isTriple ? quoteStart + 3 : quoteStart + 1;

        while (index < length) {
          final c = source[index];

          if (c == '\n') {
            line++;
            lineStart = index + 1;
          }

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
            if (c == '\n') {
              break;
            }
          }
          index++;
        }
        continue;
      }

      // Check for block comments.
      if (char == '/' && index + 1 < length && source[index + 1] == '*') {
        var depth = 1;
        index += 2;
        while (index < length && depth > 0) {
          if (source[index] == '\n') {
            line++;
            lineStart = index + 1;
          }
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
        continue;
      }

      // Check for line comments.
      if (char == '/' && index + 1 < length && source[index + 1] == '/') {
        final commentStart = index;
        final col = commentStart - lineStart + 1;
        final isFullLine = source
            .substring(lineStart, commentStart)
            .trim()
            .isEmpty;

        var commentEnd = index + 2;
        while (commentEnd < length &&
            source[commentEnd] != '\n' &&
            source[commentEnd] != '\r') {
          commentEnd++;
        }

        final raw = source.substring(commentStart, commentEnd);
        final isDoc =
            raw.startsWith('///') && (raw.length == 3 || raw[3] != '/');

        String text;
        if (isDoc) {
          text = raw.substring(3);
        } else {
          text = raw.substring(2);
        }
        if (text.startsWith(' ')) {
          text = text.substring(1);
        }

        tokens.add(
          _CommentToken(
            line: line,
            column: col,
            isFullLine: isFullLine,
            isDoc: isDoc,
            raw: raw,
            text: text,
          ),
        );

        index = commentEnd;
        continue;
      }

      index++;
    }

    return tokens;
  }

  IgnoredRules _collectIgnores(List<_CommentToken> tokens) {
    final result = IgnoredRules();

    for (final token in tokens) {
      final fileMatch = conventionIgnoreFileRegex.firstMatch(token.raw);
      if (fileMatch != null) {
        result.addFileIgnore(fileMatch.group(1)!);
        continue;
      }
      final lineMatch = conventionIgnoreLineRegex.firstMatch(token.raw);
      if (lineMatch != null) {
        final rule = lineMatch.group(1)!;
        result.addLineIgnore(token.line, rule);
        result.addLineIgnore(token.line + 1, rule);
      }
    }
    return result;
  }

  void _checkConventionIgnoreFormat(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
  ) {
    for (final token in tokens) {
      if (token.raw.startsWith('// convention-ignore:') &&
          !conventionIgnoreLineRegex.hasMatch(token.raw)) {
        violations.add(
          ConventionViolation(
            rule: 'convention_ignore_format',
            filePath: filePath,
            line: token.line,
            message:
                'convention-ignore must specify both a rule and a justification reason',
            fixHint: 'Use: // convention-ignore: <rule> <reason>',
          ),
        );
      } else if (token.raw.startsWith('// convention-ignore-file:') &&
          !conventionIgnoreFileRegex.hasMatch(token.raw)) {
        violations.add(
          ConventionViolation(
            rule: 'convention_ignore_format',
            filePath: filePath,
            line: token.line,
            message:
                'convention-ignore-file must specify both a rule and a justification reason',
            fixHint: 'Use: // convention-ignore-file: <rule> <reason>',
          ),
        );
      }
    }
  }

  void _checkDocumentedIgnores(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final tokenByLine = <int, _CommentToken>{};
    for (final token in tokens) {
      tokenByLine[token.line] = token;
    }

    for (final token in tokens) {
      if (!token.isIgnoreDirective) continue;
      if (isIgnored('undocumented_ignore', token.line)) continue;

      var targetLine = token.line - 1;
      while (tokenByLine[targetLine]?.isDirective == true) {
        targetLine--;
      }
      final prev = tokenByLine[targetLine];
      final isDocumented =
          prev != null &&
          !prev.isDirective &&
          !prev.isBanner &&
          prev.text.trim().isNotEmpty;

      if (!isDocumented) {
        violations.add(
          ConventionViolation(
            rule: 'undocumented_ignore',
            filePath: filePath,
            line: token.line,
            message:
                'Linter ignore directives must be justified by a preceding non-directive comment line',
            fixHint: 'Add a 1-line WHY comment immediately above this ignore',
          ),
        );
      }
    }
  }

  void _checkDocWhitelist(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final allowed =
        filePath.startsWith('lib/3rd_layer_domain/') ||
        filePath.startsWith('lib/core/') ||
        filePath.startsWith('lib/1st_layer_presentation/core_widgets/');

    for (final token in tokens) {
      if (!token.isDoc) continue;
      if (allowed) continue;
      if (isIgnored('doc_comment_whitelist', token.line)) continue;

      violations.add(
        ConventionViolation(
          rule: 'doc_comment_whitelist',
          filePath: filePath,
          line: token.line,
          message:
              'Doc comments (///) are only permitted in lib/3rd_layer_domain/, lib/core/, and lib/1st_layer_presentation/core_widgets/',
          fixHint:
              'Convert to // for internal comment or move contract to allowed folders',
        ),
      );
    }
  }

  void _checkBanners(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final isAppRootFile = RegExp(
      r'(?:^|/)lib/app_[a-z0-9_]+\.dart$',
    ).hasMatch(filePath);
    final validAppSectionBanner = RegExp(
      r'^// #### [A-Z0-9][A-Z0-9 &/_-]* ####$',
    );

    for (final token in tokens) {
      if (token.isDirective) continue;
      if (isIgnored('decorative_banner', token.line)) continue;

      if (isAppRootFile &&
          token.isFullLine &&
          validAppSectionBanner.hasMatch(token.raw.trimRight())) {
        continue;
      }

      if (token.isBanner) {
        violations.add(
          ConventionViolation(
            rule: 'decorative_banner',
            filePath: filePath,
            line: token.line,
            message: 'Decorative comment banners and dividers are forbidden',
            fixHint: isAppRootFile
                ? 'Section headers in lib/app_*.dart must use the exact format: // #### SECTION NAME ####'
                : 'Remove decorative separator banners and keep code self-explanatory',
          ),
        );
      }
    }
  }

  void _checkEmDashes(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final spacedDoubleHyphen = RegExp(r'\s--(?:\s|$)');

    for (final token in tokens) {
      if (token.isDirective) continue;
      if (isIgnored('em_dash', token.line)) continue;

      if (token.raw.contains('\u2014') ||
          spacedDoubleHyphen.hasMatch(token.raw)) {
        violations.add(
          ConventionViolation(
            rule: 'em_dash',
            filePath: filePath,
            line: token.line,
            message:
                'Prose em-dashes and spaced double-hyphens are forbidden in comments',
            fixHint: 'Use parentheses, colons, or simple commas instead',
          ),
        );
      }
    }
  }

  void _checkBlockLengths(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    var lineRun = 0;
    var lineRunStart = 0;

    var docRun = 0;
    var docRunStart = 0;

    void flushLineRun() {
      if (lineRun > 2 && !isIgnored('comment_block_length', lineRunStart)) {
        violations.add(
          ConventionViolation(
            rule: 'comment_block_length',
            filePath: filePath,
            line: lineRunStart,
            message:
                'Prose comment blocks must not exceed 2 lines (found $lineRun)',
            fixHint: 'Condense explanation to 1-2 lines focusing only on WHY',
          ),
        );
      }
      lineRun = 0;
      lineRunStart = 0;
    }

    void flushDocRun() {
      if (docRun > 4 && !isIgnored('comment_block_length', docRunStart)) {
        violations.add(
          ConventionViolation(
            rule: 'comment_block_length',
            filePath: filePath,
            line: docRunStart,
            message:
                'Doc comment (///) blocks must not exceed 4 lines (found $docRun)',
            fixHint:
                'Condense doc comment to 1 summary line, blank line, and max 2 contract lines',
          ),
        );
      }
      docRun = 0;
      docRunStart = 0;
    }

    var prevLine = -1;
    for (final token in tokens) {
      if (token.isDirective || token.isBanner) {
        flushLineRun();
        flushDocRun();
        prevLine = token.line;
        continue;
      }

      if (token.isDoc) {
        flushLineRun();
        if (token.line == prevLine + 1 && docRun > 0) {
          docRun++;
        } else {
          flushDocRun();
          docRun = 1;
          docRunStart = token.line;
        }
      } else if (token.isFullLine) {
        flushDocRun();
        if (token.line == prevLine + 1 && lineRun > 0) {
          lineRun++;
        } else {
          flushLineRun();
          lineRun = 1;
          lineRunStart = token.line;
        }
      } else {
        flushLineRun();
        flushDocRun();
      }

      prevLine = token.line;
    }

    flushLineRun();
    flushDocRun();
  }

  void _checkParagraphs(
    List<_CommentToken> tokens,
    String filePath,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final paragraphs = _groupParagraphs(tokens);

    final allowedPrefix = RegExp(r'^([A-Za-z][A-Za-z0-9_-]*):(?:\s|$)');
    final validTags = <String>{'TODO', 'WORKAROUND', 'SECURITY', 'PERF'};
    final urlRegex = RegExp(r'^https?://\S+$');

    for (final para in paragraphs) {
      if (para.lines.isEmpty) continue;
      final startLine = para.startLine;
      final endLine = para.endLine;

      if (isIgnored('comment_capitalization', startLine) &&
          isIgnored('comment_punctuation', endLine) &&
          isIgnored('forbidden_prefix_tag', startLine)) {
        continue;
      }

      var firstLineText = para.lines.first.trim();
      final tagMatch = allowedPrefix.firstMatch(firstLineText);

      if (tagMatch != null) {
        final tag = tagMatch.group(1)!;
        if (tag != 'http' && tag != 'https' && tag != 'file') {
          if (!validTags.contains(tag)) {
            if (!isIgnored('forbidden_prefix_tag', startLine)) {
              violations.add(
                ConventionViolation(
                  rule: 'forbidden_prefix_tag',
                  filePath: filePath,
                  line: startLine,
                  message:
                      "Prefix tag '$tag:' is not allowed. Only TODO:, WORKAROUND:, SECURITY:, and PERF: are permitted",
                  fixHint: 'Use an allowed tag or remove the prefix',
                ),
              );
            }
          } else {
            firstLineText = firstLineText.substring(tagMatch.end).trim();
          }
        }
      }

      if (firstLineText.isNotEmpty &&
          !isIgnored('comment_capitalization', startLine)) {
        final firstChar = firstLineText[0];
        final code = firstChar.codeUnitAt(0);
        final isDigit = code >= 48 && code <= 57;
        final isUpper = code >= 65 && code <= 90;
        final exempt =
            firstChar == '`' ||
            firstChar == '[' ||
            firstChar == '@' ||
            firstChar == '{' ||
            isDigit ||
            firstLineText.startsWith('http://') ||
            firstLineText.startsWith('https://');

        if (!exempt && !isUpper) {
          violations.add(
            ConventionViolation(
              rule: 'comment_capitalization',
              filePath: filePath,
              line: startLine,
              message:
                  'Comment paragraph must start with a capital letter (A-Z)',
              fixHint: 'Capitalize the first letter of the sentence',
            ),
          );
        }
      }

      final lastLineText = para.lines.last.trim();
      if (lastLineText.isNotEmpty &&
          !isIgnored('comment_punctuation', endLine)) {
        final lastChar = lastLineText[lastLineText.length - 1];
        final validPunctuation =
            lastChar == '.' ||
            lastChar == '?' ||
            lastChar == '!' ||
            lastChar == ':' ||
            lastChar == '`' ||
            lastChar == ')' ||
            lastChar == ']' ||
            urlRegex.hasMatch(lastLineText);

        if (!validPunctuation) {
          violations.add(
            ConventionViolation(
              rule: 'comment_punctuation',
              filePath: filePath,
              line: endLine,
              message:
                  'Comment paragraph must end with proper punctuation (., ?, :, `, ), ], or a URL)',
              fixHint:
                  'Add a period or terminal punctuation at the end of the paragraph',
            ),
          );
        }
      }
    }
  }

  List<_CommentParagraph> _groupParagraphs(List<_CommentToken> tokens) {
    final paragraphs = <_CommentParagraph>[];
    var current = <String>[];
    var startLine = 0;
    var endLine = 0;
    var inDoc = false;
    var inCodeFence = false;
    var prevLine = -1;

    void flush() {
      if (current.isNotEmpty) {
        paragraphs.add(
          _CommentParagraph(
            startLine: startLine,
            endLine: endLine,
            lines: List<String>.unmodifiable(current),
          ),
        );
        current = <String>[];
        startLine = 0;
        endLine = 0;
      }
    }

    for (final token in tokens) {
      if (token.isDirective || token.isBanner) {
        flush();
        prevLine = -1;
        continue;
      }

      if (token.isDoc) {
        final text = token.text;
        if (text.trim().startsWith('```')) {
          inCodeFence = !inCodeFence;
          prevLine = token.line;
          continue;
        }

        if (inCodeFence ||
            text.trim().startsWith('{@') ||
            text.trim().startsWith('@docImport')) {
          prevLine = token.line;
          continue;
        }

        if (text.trim().isEmpty) {
          flush();
          inDoc = true;
          prevLine = -1;
          continue;
        }

        if (current.isEmpty || !inDoc || token.line != prevLine + 1) {
          flush();
          startLine = token.line;
          inDoc = true;
        }

        current.add(text);
        endLine = token.line;
        prevLine = token.line;
        continue;
      }

      inDoc = false;
      inCodeFence = false;

      if (!token.isFullLine) {
        flush();
        paragraphs.add(
          _CommentParagraph(
            startLine: token.line,
            endLine: token.line,
            lines: <String>[token.text],
          ),
        );
        prevLine = -1;
        continue;
      }

      if (current.isEmpty || token.line != prevLine + 1) {
        flush();
        startLine = token.line;
      }

      current.add(token.text);
      endLine = token.line;
      prevLine = token.line;
    }

    flush();
    return paragraphs;
  }
}

class _CommentParagraph {
  const _CommentParagraph({
    required this.startLine,
    required this.endLine,
    required this.lines,
  });

  final int startLine;
  final int endLine;
  final List<String> lines;
}
