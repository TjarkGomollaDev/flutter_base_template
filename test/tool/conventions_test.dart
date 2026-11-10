// Unit tests for comment, test, architecture, and markdown convention checkers.
import 'package:flutter_test/flutter_test.dart';

import '../../tool/src/architecture_checker.dart';
import '../../tool/src/checker_common.dart';
import '../../tool/src/comment_checker.dart';
import '../../tool/src/markdown_checker.dart';
import '../../tool/src/test_checker.dart';

void main() {
  const commentChecker = CommentChecker();
  const testChecker = TestChecker();
  const architectureChecker = ArchitectureChecker();
  const markdownChecker = MarkdownChecker();

  group('CommentChecker', () {
    test('accepts valid 1-line WHY comment', () {
      const code = '''
// Explains why an unusual platform workaround is required.
final int timeout = 42;
''';
      final violations = commentChecker.checkSource('lib/core/util.dart', code);
      expect(violations, <ConventionViolation>[]);
    });

    test('ignores URL in string literal and does not treat it as comment', () {
      const code = '''
final String url = 'https://api.yourdomain.com/v1/resource';
''';
      final violations = commentChecker.checkSource(
        'lib/core/client.dart',
        code,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test('allows CLI flag with double hyphen but rejects spaced em-dash', () {
      const validCode = '''
// Pass --dart-define=ENVIRONMENT=prod during release builds.
final String flag = 'prod';
''';
      final validViolations = commentChecker.checkSource(
        'lib/core/env.dart',
        validCode,
      );
      expect(validViolations, <ConventionViolation>[]);

      const invalidCode = '''
// This is an invalid comment -- using spaced double hyphens.
final String flag = 'prod';
''';
      final invalidViolations = commentChecker.checkSource(
        'lib/core/env.dart',
        invalidCode,
      );
      expect(invalidViolations.length, 1);
      expect(invalidViolations.first.rule, 'em_dash');
    });

    test('rejects decorative banners', () {
      const code = '''
// #### ALL COLORS ####
final int color = 0;
''';
      final violations = commentChecker.checkSource(
        'lib/core/colors.dart',
        code,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'decorative_banner');
    });

    test('allows unified section banners in root app files', () {
      const code = '''
// #### ALL COLORS ####
final int color = 0;
''';
      final violations = commentChecker.checkSource('lib/app_theme.dart', code);
      expect(violations, isEmpty);
    });

    test('rejects malformed section banners in root app files', () {
      const code = '''
// #### ALL COLORS ########
final int color = 0;
''';
      final violations = commentChecker.checkSource('lib/app_theme.dart', code);
      expect(violations, hasLength(1));
      expect(violations.first.rule, 'decorative_banner');
    });

    test('rejects doc comments outside whitelisted paths', () {
      const code = '''
/// Trivial documentation comment.
final int x = 1;
''';
      final violations = commentChecker.checkSource(
        'lib/1st_layer_presentation/home/home_page.dart',
        code,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'doc_comment_whitelist');
    });

    test('accepts doc comments in domain and core paths', () {
      const code = '''
/// Unit of time in milliseconds.
final int ms = 1000;
''';
      final domainViolations = commentChecker.checkSource(
        'lib/3rd_layer_domain/models/item.dart',
        code,
      );
      expect(domainViolations, <ConventionViolation>[]);

      final coreViolations = commentChecker.checkSource(
        'lib/core/constants.dart',
        code,
      );
      expect(coreViolations, <ConventionViolation>[]);
    });

    test(
      'requires non-directive justification comment before linter ignore',
      () {
        const undocumented = '''
// ignore: avoid_print
final int x = 1;
''';
        final violations = commentChecker.checkSource(
          'lib/core/debug.dart',
          undocumented,
        );
        expect(violations.length, 1);
        expect(violations.first.rule, 'undocumented_ignore');

        const documented = '''
// Required for early bootstrap error reporting.
// ignore: avoid_print
final int y = 2;
''';
        final documentedViolations = commentChecker.checkSource(
          'lib/core/debug.dart',
          documented,
        );
        expect(documentedViolations, <ConventionViolation>[]);
      },
    );

    test(
      'accepts stacked linter ignore directives with preceding justification',
      () {
        const stacked = '''
// Explains why both ignores are necessary for this boundary call.
// ignore: avoid_dynamic_calls
// ignore: argument_type_not_assignable
final dynamic result = target.execute();
''';
        final violations = commentChecker.checkSource(
          'lib/core/debug.dart',
          stacked,
        );
        expect(violations, <ConventionViolation>[]);
      },
    );

    test('accepts exclamation mark as valid terminal punctuation', () {
      const code = '''
// Critical safety requirement must not be violated!
final int maxRetries = 3;
''';
      final violations = commentChecker.checkSource(
        'lib/core/safety.dart',
        code,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test('validates convention-ignore and convention-ignore-file format', () {
      const invalid = '''
// convention-ignore:
final int x = 1;
// convention-ignore-file:
final int y = 2;
''';
      final violations = commentChecker.checkSource(
        'lib/core/test.dart',
        invalid,
      );
      expect(violations.length, 2);
      expect(violations[0].rule, 'convention_ignore_format');
      expect(violations[1].rule, 'convention_ignore_format');
    });

    test('convention-ignore-file suppresses rules for entire file', () {
      const source = '''
// convention-ignore-file: comment_capitalization Legacy migration in progress.
// lowercase comment on line 2.
final int a = 1;
// lowercase comment on line 4.
final int b = 2;
''';
      final violations = commentChecker.checkSource(
        'lib/core/test.dart',
        source,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test(
      'line-level convention-ignore does not suppress rules for subsequent lines',
      () {
        const source = '''
// convention-ignore: comment_capitalization Single line exemption.
// lowercase comment on line 2.
final int a = 1;
// lowercase comment on line 4.
final int b = 2;
''';
        final violations = commentChecker.checkSource(
          'lib/core/test.dart',
          source,
        );
        expect(violations.length, 1);
        expect(violations.first.rule, 'comment_capitalization');
        expect(violations.first.line, 4);
      },
    );
  });

  group('TestChecker', () {
    test(
      'accepts valid test with meaningful assertion and short description',
      () {
        const code = '''
void main() {
  test('emits loaded state when fetch completes successfully', () {
    final result = 1;
    expect(result, equals(1));
  });
}
''';
        final violations = testChecker.checkSource(
          'test/feature_test.dart',
          code,
        );
        expect(violations, <ConventionViolation>[]);
      },
    );

    test('rejects tests missing assertions', () {
      const code = '''
void main() {
  test('does some action without verifying output', () {
    final x = 1 + 1;
  });
}
''';
      final violations = testChecker.checkSource(
        'test/missing_test.dart',
        code,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'missing_assertion');
    });

    test('rejects tests with only trivial isNotNull assertions', () {
      const code = '''
void main() {
  test('returns an instance', () {
    final x = Object();
    expect(x, isNotNull);
  });
}
''';
      final violations = testChecker.checkSource(
        'test/trivial_test.dart',
        code,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'trivial_assertion');
    });

    test('rejects layout finders like find.byType(Padding)', () {
      const code = '''
void main() {
  testWidgets('renders view', (tester) async {
    expect(find.byType(Padding), findsOneWidget);
  });
}
''';
      final violations = testChecker.checkSource('test/layout_test.dart', code);
      expect(violations.length, 1);
      expect(violations.first.rule, 'no_layout_finders');
    });

    test('rejects unmanaged real waits unless inside runAsync', () {
      const code = '''
void main() {
  test('performs delay', () async {
    await Future<void>.delayed(const Duration(seconds: 1));
    expect(1, equals(1));
  });
}
''';
      final violations = testChecker.checkSource('test/wait_test.dart', code);
      expect(violations.length, 1);
      expect(violations.first.rule, 'no_real_waits');
    });

    test('allows convention-ignore for real wait when justified', () {
      const code = '''
void main() {
  test('performs hardware sync', () async {
    // convention-ignore: no_real_waits Required for external hardware integration test
    await Future<void>.delayed(const Duration(seconds: 1));
    expect(1, equals(1));
  });
}
''';
      final violations = testChecker.checkSource('test/wait_test.dart', code);
      expect(violations, <ConventionViolation>[]);
    });

    test('rejects control flow statements in test bodies', () {
      const code = '''
void main() {
  test('processes list items', () {
    for (var i = 0; i < 3; i++) {
      expect(i, equals(0));
    }
  });
}
''';
      final violations = testChecker.checkSource('test/flow_test.dart', code);
      expect(violations.length, 1);
      expect(violations.first.rule, 'no_control_flow_in_tests');
    });

    test('validates assertions in arrow syntax tests', () {
      const codeWithoutAssertion = '''
void main() {
  test('invokes service', () => service.execute());
}
''';
      final violations = testChecker.checkSource(
        'test/arrow_test.dart',
        codeWithoutAssertion,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'missing_assertion');

      const codeWithAssertion = '''
void main() {
  test('verifies response', () => expect(service.value, equals(42)));
}
''';
      final validViolations = testChecker.checkSource(
        'test/arrow_test.dart',
        codeWithAssertion,
      );
      expect(validViolations, <ConventionViolation>[]);
    });
  });

  group('ArchitectureChecker', () {
    test('rejects domain layer importing flutter or other layers', () {
      const code = '''
import 'package:flutter/material.dart';

class Entity {}
''';
      final violations = architectureChecker.checkSource(
        'lib/3rd_layer_domain/models/entity.dart',
        code,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'domain_pure_dart');
    });

    test(
      'rejects application layer importing presentation or flutter widgets',
      () {
        const code = '''
import 'package:flutter/material.dart';

class AppBloc {}
''';
        final violations = architectureChecker.checkSource(
          'lib/2nd_layer_application/app_bloc.dart',
          code,
        );
        expect(violations.length, 1);
        expect(violations.first.rule, 'application_layer_isolation');
      },
    );

    test(
      'rejects raw colors in presentation layer but allows Color type annotations',
      () {
        const invalidCode = '''
import 'package:flutter/widgets.dart';

class MyView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(color: Colors.red);
  }
}
''';
        final invalidViolations = architectureChecker.checkSource(
          'lib/1st_layer_presentation/home/home_page.dart',
          invalidCode,
        );
        expect(invalidViolations.length, 1);
        expect(invalidViolations.first.rule, 'presentation_raw_color_shadow');

        const validCode = '''
import 'package:flutter/widgets.dart';

class CoreBtn extends StatelessWidget {
  const CoreBtn({this.color, this.shadow});
  final Color? color;
  final BoxShadow? shadow;
}
''';
        final validViolations = architectureChecker.checkSource(
          'lib/1st_layer_presentation/core_widgets/core_btn.dart',
          validCode,
        );
        expect(validViolations, <ConventionViolation>[]);
      },
    );

    test('rejects direct Dio instantiation outside core network', () {
      const code = '''
class Repo {
  final client = Dio();
}
''';
      final violations = architectureChecker.checkSource(
        'lib/4th_layer_infrastructure/repo.dart',
        code,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'dio_encapsulation');
    });
  });

  group('MarkdownChecker', () {
    test('accepts clean markdown file without horizontal rules', () {
      const markdown = '''
# Documentation

## Overview

Clean markdown document content without horizontal rules.

| Feature | Status |
| --- | --- |
| Convention | Active |
''';
      final violations = markdownChecker.checkSource(
        'docs/overview.md',
        markdown,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test('accepts YAML frontmatter with --- at start and end', () {
      const markdown = '''
---
title: Overview
category: Documentation
---

# Overview

Document body content.
''';
      final violations = markdownChecker.checkSource(
        'docs/overview.md',
        markdown,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test('accepts --- inside code blocks (``` and ~~~)', () {
      const markdown = '''
# Code Examples

```yaml
---
name: example
---
```

~~~markdown
---
~~~
''';
      final violations = markdownChecker.checkSource(
        'docs/overview.md',
        markdown,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test('accepts nested code fences without premature closure', () {
      const markdown = '''
# Documentation Guide

````markdown
Here is an example:

```yaml
---
title: Nested Example
---
```
````
''';
      final violations = markdownChecker.checkSource(
        'docs/overview.md',
        markdown,
      );
      expect(violations, <ConventionViolation>[]);
    });

    test('rejects standalone --- horizontal rules in body', () {
      const markdown = '''
# Section 1

Some text.

---

# Section 2
''';
      final violations = markdownChecker.checkSource(
        'docs/overview.md',
        markdown,
      );
      expect(violations.length, 1);
      expect(violations.first.rule, 'no_horizontal_rules');
      expect(violations.first.line, 5);
      expect(
        violations.first.message,
        "Horizontal rule divider '---' is forbidden. Structure content using headings (##, ###) instead.",
      );
      expect(violations.first.fixHint, 'Remove the horizontal divider line.');
    });

    test('rejects standalone *** or ___ dividers', () {
      const markdown = '''
# Section 1

***

Middle paragraph.

___

End paragraph.
''';
      final violations = markdownChecker.checkSource(
        'docs/overview.md',
        markdown,
      );
      expect(violations.length, 2);
      expect(violations[0].rule, 'no_horizontal_rules');
      expect(violations[0].line, 3);
      expect(
        violations[0].message,
        "Horizontal rule divider '***' is forbidden. Structure content using headings (##, ###) instead.",
      );
      expect(violations[1].rule, 'no_horizontal_rules');
      expect(violations[1].line, 7);
      expect(
        violations[1].message,
        "Horizontal rule divider '___' is forbidden. Structure content using headings (##, ###) instead.",
      );
    });
  });
}
