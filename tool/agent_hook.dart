// Multi-harness agent hook for Claude Code, Antigravity, Gemini, and OpenCode.
import 'dart:convert';
import 'dart:io';

import 'src/architecture_checker.dart';
import 'src/comment_checker.dart';
import 'src/test_checker.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('Usage: agent_hook <harness> <event> [args...]');
    exit(1);
  }

  // Handle direct check-files mode.
  if (args[0] == 'check-files') {
    _handleCheckFiles(args.sublist(1));
    return;
  }

  final harness = args[0].toLowerCase();
  final event = args.length > 1 ? args[1].toLowerCase() : '';

  if (event == 'check-files') {
    _handleCheckFiles(args.sublist(2));
    return;
  }

  Map<String, dynamic> inputData = <String, dynamic>{};
  final inputString = _readStdin();
  if (inputString.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(inputString);
      if (decoded is Map<String, dynamic>) {
        inputData = decoded;
      }
    } catch (_) {
      // Non-JSON stdin is treated as empty.
    }
  }

  switch (event) {
    case 'pre-tool':
      _handlePreTool(harness, inputData);
      break;
    case 'post-tool':
      _handlePostTool(harness, inputData);
      break;
    case 'stop':
      _handleStop(harness, inputData);
      break;
    default:
      stderr.writeln('Unknown event: $event');
      exit(1);
  }
}

String _readStdin() {
  try {
    final buffer = StringBuffer();
    while (true) {
      final line = stdin.readLineSync();
      if (line == null) break;
      buffer.writeln(line);
    }
    return buffer.toString();
  } catch (_) {
    return '';
  }
}

String _findDartCmd() {
  try {
    final flutterWhich = Process.runSync('which', <String>['flutter']);
    if (flutterWhich.exitCode == 0) {
      final flutterPath = (flutterWhich.stdout as String).trim();
      if (flutterPath.isNotEmpty) {
        var file = File(flutterPath);
        while (file.statSync().type == FileSystemEntityType.link) {
          final target = file.resolveSymbolicLinksSync();
          file = File(target);
        }
        final binDir = file.parent.path;
        final candidate =
            '$binDir${Platform.pathSeparator}cache${Platform.pathSeparator}dart-sdk${Platform.pathSeparator}bin${Platform.pathSeparator}dart';
        if (File(candidate).existsSync()) {
          return candidate;
        }
      }
    }
  } catch (_) {
    // Fall back to dart command in PATH.
  }
  return 'dart';
}

void _handlePreTool(String harness, Map<String, dynamic> input) {
  final command = _extractCommand(input);
  if (command == null || command.trim().isEmpty) {
    _allowPreTool(harness);
    return;
  }

  // Strip commit message strings to avoid false positives.
  final strippedCmd = command.replaceAll(
    RegExp(r'''-m\s*("[^"]*"|'[^']*')'''),
    '-m "STRIPPED"',
  );

  // Check 1: Forbidden --no-verify or -n flag in git commit, push, or merge.
  final noVerifyRegex = RegExp(
    r'\bgit\s+(?:[^\n]*\s+)?(?:commit|push|merge)\b(?:\s+[^\n]*)?\s+(?:--no-verify|-n\b)',
  );
  if (noVerifyRegex.hasMatch(strippedCmd)) {
    _blockPreTool(
      harness,
      'Bypassing git hooks (--no-verify or -n) is strictly forbidden.',
    );
    return;
  }

  // Check 2: Modifying core.hooksPath away from .hooks.
  final hooksPathRegex = RegExp(
    r'\bgit\s+config\s+(?:--[a-z-]+\s+)*core\.hooksPath\b',
  );
  if (hooksPathRegex.hasMatch(strippedCmd) && !strippedCmd.contains('.hooks')) {
    _blockPreTool(
      harness,
      'Modifying git core.hooksPath away from .hooks is forbidden.',
    );
    return;
  }

  // Check 3: Commits on main or master branches.
  final commitRegex = RegExp(r'\bgit\s+(?:[^\n]*\s+)?commit\b');
  if (commitRegex.hasMatch(strippedCmd)) {
    if (_isMainOrMasterBranch()) {
      _blockPreTool(
        harness,
        'Direct commits on main or master are forbidden. Switch to a feature branch: git switch -c feat/<short-description>',
      );
      return;
    }
  }

  _allowPreTool(harness);
}

bool _isMainOrMasterBranch() {
  try {
    final branchResult = Process.runSync('git', <String>[
      'symbolic-ref',
      '--short',
      'HEAD',
    ]);
    if (branchResult.exitCode != 0) return false;
    final branch = (branchResult.stdout as String).trim();
    if (branch != 'main' && branch != 'master') return false;

    // Check if unborn HEAD.
    final revResult = Process.runSync('git', <String>[
      'rev-parse',
      '--verify',
      'HEAD',
    ]);
    if (revResult.exitCode != 0) return false;

    return true;
  } catch (_) {
    return false;
  }
}

String? _extractCommand(Map<String, dynamic> input) {
  final toolInput = input['tool_input'];
  if (toolInput is Map<String, dynamic>) {
    final cmd = toolInput['command'];
    if (cmd is String) return cmd;
  }

  final toolCall = input['toolCall'];
  if (toolCall is Map<String, dynamic>) {
    final args = toolCall['args'];
    if (args is Map<String, dynamic>) {
      final cmd = args['CommandLine'] ?? args['command'];
      if (cmd is String) return cmd;
    }
  }

  final cmd = input['command'] ?? input['CommandLine'];
  if (cmd is String) return cmd;

  return null;
}

void _allowPreTool(String harness) {
  if (harness == 'claude') {
    exit(0);
  } else if (harness == 'antigravity' || harness == 'gemini') {
    stdout.write('{}');
    exit(0);
  }
  exit(0);
}

void _blockPreTool(String harness, String reason) {
  if (harness == 'claude') {
    stderr.writeln(reason);
    exit(2);
  } else if (harness == 'antigravity') {
    stdout.write(
      jsonEncode(<String, dynamic>{'decision': 'block', 'reason': reason}),
    );
    exit(0);
  } else if (harness == 'gemini') {
    stdout.write(
      jsonEncode(<String, dynamic>{'decision': 'deny', 'reason': reason}),
    );
    exit(0);
  }
  stderr.writeln(reason);
  exit(1);
}

void _handlePostTool(String harness, Map<String, dynamic> input) {
  final filePath = _extractFilePath(input);
  if (filePath == null ||
      !filePath.endsWith('.dart') ||
      _isGenerated(filePath)) {
    _allowPostTool(harness);
    return;
  }

  final file = File(filePath);
  if (!file.existsSync()) {
    _allowPostTool(harness);
    return;
  }

  // Format the file silently.
  try {
    Process.runSync(_findDartCmd(), <String>['format', filePath]);
  } catch (_) {
    // Ignore format execution errors.
  }

  final violations = _runCheckersOnFile(filePath, file.readAsStringSync());

  if (violations.isEmpty) {
    _allowPostTool(harness);
    return;
  }

  final msg = violations.map((v) => v.toString()).join('\n');

  if (harness == 'claude') {
    stderr.writeln('CONVENTION VIOLATION — fix immediately:\n$msg');
    exit(2);
  } else if (harness == 'gemini') {
    stdout.write(
      jsonEncode(<String, dynamic>{
        'hookSpecificOutput': <String, dynamic>{
          'additionalContext': 'CONVENTION VIOLATION — fix immediately:\n$msg',
        },
      }),
    );
    exit(0);
  } else if (harness == 'antigravity') {
    stdout.write('{}');
    exit(0);
  }

  stderr.writeln(msg);
  exit(1);
}

void _allowPostTool(String harness) {
  if (harness == 'antigravity' || harness == 'gemini') {
    stdout.write('{}');
  }
  exit(0);
}

String? _extractFilePath(Map<String, dynamic> input) {
  final toolInput = input['tool_input'];
  if (toolInput is Map<String, dynamic>) {
    final path = toolInput['file_path'] ?? toolInput['path'];
    if (path is String) return path;
  }

  final toolCall = input['toolCall'];
  if (toolCall is Map<String, dynamic>) {
    final args = toolCall['args'];
    if (args is Map<String, dynamic>) {
      final path = args['Path'] ?? args['path'];
      if (path is String) return path;
    }
  }

  final path = input['path'] ?? input['Path'] ?? input['file_path'];
  if (path is String) return path;

  return null;
}

void _handleStop(String harness, Map<String, dynamic> input) {
  if (harness == 'claude') {
    if (input['stop_hook_active'] == true) {
      exit(0);
    }
  } else if (harness == 'gemini') {
    if (input['stop_hook_active'] == true) {
      stdout.write('{}');
      exit(0);
    }
  } else if (harness == 'antigravity') {
    final reason = input['terminationReason'];
    final executionNum = (input['executionNum'] as int?) ?? 0;
    if (reason != 'NO_TOOL_CALL' || executionNum >= 3) {
      stdout.write(jsonEncode(<String, dynamic>{'decision': 'stop'}));
      exit(0);
    }
  }

  final modifiedFiles = _getModifiedDartFiles();
  final violations = <ConventionViolation>[];

  for (final filePath in modifiedFiles) {
    if (_isGenerated(filePath)) continue;
    final file = File(filePath);
    if (!file.existsSync()) continue;
    violations.addAll(_runCheckersOnFile(filePath, file.readAsStringSync()));
  }

  if (violations.isEmpty) {
    if (harness == 'claude') {
      exit(0);
    } else if (harness == 'antigravity') {
      stdout.write(jsonEncode(<String, dynamic>{'decision': 'stop'}));
      exit(0);
    } else if (harness == 'gemini') {
      stdout.write('{}');
      exit(0);
    }
    exit(0);
  }

  final msg = violations.map((v) => v.toString()).join('\n');

  if (harness == 'claude') {
    stderr.writeln('Fix convention violations before finishing:\n$msg');
    exit(2);
  } else if (harness == 'antigravity') {
    stdout.write(
      jsonEncode(<String, dynamic>{
        'decision': 'continue',
        'reason': 'Fix convention violations before finishing:\n$msg',
      }),
    );
    exit(0);
  } else if (harness == 'gemini') {
    stdout.write(
      jsonEncode(<String, dynamic>{
        'decision': 'deny',
        'reason': 'Fix convention violations before finishing:\n$msg',
      }),
    );
    exit(0);
  }

  stderr.writeln(msg);
  exit(1);
}

List<String> _getModifiedDartFiles() {
  final files = <String>{};
  try {
    final statusResult = Process.runSync('git', <String>[
      'status',
      '--porcelain',
    ]);
    if (statusResult.exitCode == 0) {
      final lines = (statusResult.stdout as String).split('\n');
      for (final line in lines) {
        if (line.length > 3) {
          final file = line.substring(3).trim();
          if (file.endsWith('.dart')) {
            files.add(file);
          }
        }
      }
    }
  } catch (_) {
    // Ignore git status errors.
  }
  return files.toList();
}

void _handleCheckFiles(List<String> filePaths) {
  final dartCmd = _findDartCmd();
  final violations = <ConventionViolation>[];

  for (final filePath in filePaths) {
    final normalized = filePath.replaceAll(r'\', '/');
    if (!normalized.endsWith('.dart') || _isGenerated(normalized)) continue;

    final file = File(filePath);
    if (!file.existsSync()) continue;

    try {
      Process.runSync(dartCmd, <String>['format', filePath]);
    } catch (_) {
      // Ignore format execution errors.
    }

    violations.addAll(_runCheckersOnFile(normalized, file.readAsStringSync()));
  }

  if (violations.isNotEmpty) {
    for (final v in violations) {
      stdout.writeln(v.toString());
    }
    exit(1);
  }

  exit(0);
}

List<ConventionViolation> _runCheckersOnFile(String filePath, String source) {
  final normalized = filePath.replaceAll(r'\', '/');
  const commentChecker = CommentChecker();
  const testChecker = TestChecker();
  const architectureChecker = ArchitectureChecker();

  final violations = <ConventionViolation>[];
  violations.addAll(commentChecker.checkSource(normalized, source));

  if (normalized.startsWith('test/') && normalized.endsWith('_test.dart')) {
    violations.addAll(testChecker.checkSource(normalized, source));
  }

  if (normalized.startsWith('lib/')) {
    violations.addAll(architectureChecker.checkSource(normalized, source));
  }

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
