// Pure-Dart convention checking entrypoint for Git hooks and CI.
import 'dart:io';

import 'src/architecture_checker.dart';
import 'src/checker_common.dart';
import 'src/comment_checker.dart';
import 'src/markdown_checker.dart';
import 'src/test_checker.dart';

void main(List<String> args) {
  var rootDir = Directory.current.path;
  final targets = <String>[];

  for (var i = 0; i < args.length; i++) {
    final arg = args[i];
    if (arg == '--root' && i + 1 < args.length) {
      rootDir = args[i + 1];
      i++;
    } else if (!arg.startsWith('--')) {
      targets.add(arg);
    }
  }

  if (targets.isEmpty) {
    targets.addAll(<String>[
      'lib',
      'test',
      'tool',
      'docs',
      'guidelines',
      'design',
      'README.md',
      'AGENTS.md',
      'CLAUDE.md',
      'GEMINI.md',
      '.github/pull_request_template.md',
    ]);
  }

  final files = _collectFiles(rootDir, targets);
  const commentChecker = CommentChecker();
  const testChecker = TestChecker();
  const architectureChecker = ArchitectureChecker();
  const markdownChecker = MarkdownChecker();

  final violations = <ConventionViolation>[];

  for (final file in files) {
    final relativePath = _normalizeRelativePath(rootDir, file.path);
    if (isGeneratedPath(relativePath)) continue;

    final content = file.readAsStringSync();

    if (relativePath.endsWith('.md')) {
      violations.addAll(markdownChecker.checkFile(relativePath, content));
      continue;
    }

    violations.addAll(commentChecker.checkFile(relativePath, content));

    if (relativePath.startsWith('test/') &&
        relativePath.endsWith('_test.dart')) {
      violations.addAll(testChecker.checkFile(relativePath, content));
    }

    if (relativePath.startsWith('lib/')) {
      violations.addAll(architectureChecker.checkFile(relativePath, content));
    }
  }

  if (violations.isNotEmpty) {
    for (final v in violations) {
      stderr.writeln(v.toString());
    }
    exit(1);
  }

  exit(0);
}

List<File> _collectFiles(String rootDir, List<String> targets) {
  final files = <File>[];

  for (final target in targets) {
    final resolvedPath = target.startsWith('/')
        ? target
        : '$rootDir${Platform.pathSeparator}$target';

    final type = FileSystemEntity.typeSync(resolvedPath);
    if (type == FileSystemEntityType.file) {
      if (resolvedPath.endsWith('.dart') || resolvedPath.endsWith('.md')) {
        files.add(File(resolvedPath));
      }
    } else if (type == FileSystemEntityType.directory) {
      final dir = Directory(resolvedPath);
      if (dir.existsSync()) {
        for (final entity in dir.listSync(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is File &&
              (entity.path.endsWith('.dart') || entity.path.endsWith('.md'))) {
            files.add(entity);
          }
        }
      }
    }
  }

  return files;
}

String _normalizeRelativePath(String rootDir, String fullPath) {
  var path = fullPath;
  final rootWithSep = rootDir.endsWith(Platform.pathSeparator)
      ? rootDir
      : '$rootDir${Platform.pathSeparator}';

  if (path.startsWith(rootWithSep)) {
    path = path.substring(rootWithSep.length);
  }
  return path.replaceAll(r'\', '/');
}
