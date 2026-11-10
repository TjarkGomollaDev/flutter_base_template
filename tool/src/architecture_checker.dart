// Pure-Dart Clean Architecture convention checker.
import 'dart:io';

import 'checker_common.dart';

// Verifies layer isolation, pure-Dart domain, and theme token usage.
class ArchitectureChecker {
  const ArchitectureChecker();

  // Runs architecture checks on the provided file.
  List<ConventionViolation> checkFile(String filePath, [String? content]) {
    final normalized = filePath.replaceAll(r'\', '/');
    if (isGeneratedPath(normalized) || !normalized.startsWith('lib/')) {
      return const <ConventionViolation>[];
    }

    final source = content ?? File(filePath).readAsStringSync();
    return checkSource(normalized, source);
  }

  // Runs architecture checks on in-memory source content.
  List<ConventionViolation> checkSource(String filePath, String source) {
    final violations = <ConventionViolation>[];
    final ignores = collectIgnoresFromSource(source);

    bool isIgnored(String rule, int line) => ignores.isIgnored(rule, line);

    _checkImports(filePath, source, violations, isIgnored);
    _checkCodeTokens(filePath, source, violations, isIgnored);

    return violations;
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
      final line = getLineNumber(source, match.start);

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
    final stripped = stripCommentsAndStrings(source);

    if (filePath.startsWith('lib/1st_layer_presentation/')) {
      for (final match in _rawColorShadowRegex.allMatches(stripped)) {
        final line = getLineNumber(stripped, match.start);
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
      for (final match in _dioRegex.allMatches(stripped)) {
        final line = getLineNumber(stripped, match.start);
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
}

final RegExp _rawColorShadowRegex = RegExp(
  r'\b(?:Color\s*\(|Color\.(?:fromARGB|fromRGBO|alphaBlend|lerp)\s*\(|Colors\.\w+|CupertinoColors\.\w+|BoxShadow\s*\()',
);

final RegExp _dioRegex = RegExp(r'\bDio\s*\(');
