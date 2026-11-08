// Pure-Dart Clean Architecture convention checker.
import 'dart:io';

import 'comment_checker.dart';

// Verifies layer isolation, pure-Dart domain, and theme token usage.
class ArchitectureChecker {
  const ArchitectureChecker();

  // Runs architecture checks on the provided file.
  List<ConventionViolation> checkFile(String filePath, [String? content]) {
    final normalized = filePath.replaceAll(r'\', '/');
    if (_isGenerated(normalized) || !normalized.startsWith('lib/')) {
      return const <ConventionViolation>[];
    }

    final source = content ?? File(filePath).readAsStringSync();
    return checkSource(normalized, source);
  }

  // Runs architecture checks on in-memory source content.
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

    _checkImports(filePath, source, violations, isIgnored);
    _checkCodeTokens(filePath, source, violations, isIgnored);

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

  void _checkImports(
    String filePath,
    String source,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final importRegex = RegExp(
      r'''^\s*import\s+['"]([^'"]+)['"]''',
      multiLine: true,
    );
    final matches = importRegex.allMatches(source);

    for (final match in matches) {
      final uri = match.group(1) ?? '';
      final line = _getLineNumber(source, match.start);

      if (filePath.startsWith('lib/3rd_layer_domain/')) {
        if (isIgnored('domain_pure_dart', line)) continue;

        final forbidden =
            uri.contains('1st_layer_presentation') ||
            uri.contains('2nd_layer_application') ||
            uri.contains('4th_layer_infrastructure') ||
            uri.startsWith('package:flutter/') ||
            uri.startsWith('package:dio/') ||
            uri.startsWith('package:go_router/') ||
            uri.startsWith('package:shared_preferences/') ||
            uri.startsWith('package:get_it/') ||
            uri.contains('/app_');

        if (forbidden) {
          violations.add(
            ConventionViolation(
              rule: 'domain_pure_dart',
              filePath: filePath,
              line: line,
              message:
                  "Domain layer must be pure Dart. Forbidden import: '$uri'",
              fixHint:
                  'Remove Flutter, external package, or other layer dependencies from domain',
            ),
          );
        }
      } else if (filePath.startsWith('lib/2nd_layer_application/')) {
        if (isIgnored('application_layer_isolation', line)) continue;

        final forbidden =
            uri.contains('1st_layer_presentation') ||
            uri.contains('4th_layer_infrastructure') ||
            uri.startsWith('package:dio/') ||
            uri == 'package:flutter/material.dart' ||
            uri == 'package:flutter/cupertino.dart' ||
            uri == 'package:flutter/widgets.dart';

        if (forbidden) {
          violations.add(
            ConventionViolation(
              rule: 'application_layer_isolation',
              filePath: filePath,
              line: line,
              message:
                  "Application layer must not import presentation, infrastructure, Dio, or UI widget libraries. Forbidden: '$uri'",
              fixHint:
                  'Use domain contracts, core utilities, or dart:ui instead of UI widget packages',
            ),
          );
        }
      } else if (filePath.startsWith('lib/1st_layer_presentation/')) {
        if (isIgnored('presentation_layer_isolation', line)) continue;

        final forbidden =
            uri.contains('4th_layer_infrastructure') ||
            uri.startsWith('package:dio/');

        if (forbidden) {
          violations.add(
            ConventionViolation(
              rule: 'presentation_layer_isolation',
              filePath: filePath,
              line: line,
              message:
                  "Presentation layer must not import infrastructure or direct Dio. Forbidden: '$uri'",
              fixHint:
                  'Access repositories and business logic through application BLoCs or domain contracts',
            ),
          );
        }
      }
    }
  }

  void _checkCodeTokens(
    String filePath,
    String source,
    List<ConventionViolation> violations,
    bool Function(String rule, int line) isIgnored,
  ) {
    final stripped = _stripCommentsAndStrings(source);

    if (filePath.startsWith('lib/1st_layer_presentation/')) {
      final rawColorShadowRegex = RegExp(
        r'\b(?:Color\s*\(|Color\.(?:fromARGB|fromRGBO|alphaBlend|lerp)\s*\(|Colors\.\w+|CupertinoColors\.\w+|BoxShadow\s*\()',
      );

      for (final match in rawColorShadowRegex.allMatches(stripped)) {
        final line = _getLineNumber(stripped, match.start);
        if (isIgnored('presentation_raw_color_shadow', line)) continue;

        violations.add(
          ConventionViolation(
            rule: 'presentation_raw_color_shadow',
            filePath: filePath,
            line: line,
            message:
                'Raw Color/BoxShadow constructors and constants are forbidden in presentation: ${match.group(0)}',
            fixHint:
                'Use context.colorPalette, context.shadowPalette, or AppTheme tokens instead of hardcoded colors',
          ),
        );
      }
    }

    if (!filePath.startsWith('lib/core/network/')) {
      final dioRegex = RegExp(r'\bDio\s*\(');
      for (final match in dioRegex.allMatches(stripped)) {
        final line = _getLineNumber(stripped, match.start);
        if (isIgnored('dio_encapsulation', line)) continue;

        violations.add(
          ConventionViolation(
            rule: 'dio_encapsulation',
            filePath: filePath,
            line: line,
            message:
                'Direct Dio() instantiation is forbidden outside lib/core/network/',
            fixHint: 'Inject and use ApiClient from dependency injection',
          ),
        );
      }
    }
  }

  // Replaces string literals and comments with whitespace to preserve line numbers.
  String _stripCommentsAndStrings(String source) {
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
