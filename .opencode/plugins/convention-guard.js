import { spawnSync } from 'node:child_process';
import { resolve } from 'node:path';

export default async ({ directory, worktree }) => {
  const root = worktree || directory || process.cwd();

  return {
    'tool.execute.before': async (input, output) => {
      const toolName = input?.tool || output?.tool || input?.toolName || output?.toolName;
      if (toolName === 'bash' || toolName === 'shell' || toolName === 'terminal') {
        const cmd = output?.args?.command || input?.args?.command || '';
        if (typeof cmd === 'string' && cmd.trim()) {
          const stripped = cmd.replace(/-m\s*("[^"]*"|'[^']*')/g, '-m "STRIPPED"');

          if (
            /\bgit\s+(?:[^\n]*\s+)?(?:commit|push|merge)\b(?:\s+[^\n]*)?\s+(?:--no-verify|-n\b)/.test(
              stripped,
            )
          ) {
            throw new Error(
              '[Convention Guard] Bypassing git hooks (--no-verify or -n) is strictly forbidden.',
            );
          }

          if (
            /\bgit\s+config\s+(?:--[a-z-]+\s+)*core\.hooksPath\b/.test(stripped) &&
            !stripped.includes('.hooks')
          ) {
            throw new Error(
              '[Convention Guard] Modifying git core.hooksPath away from .hooks is forbidden.',
            );
          }

          if (/\bgit\s+(?:[^\n]*\s+)?commit\b/.test(stripped)) {
            try {
              const res = spawnSync('git', ['symbolic-ref', '--short', 'HEAD'], {
                cwd: root,
                encoding: 'utf-8',
              });
              const branch = (res.stdout || '').trim();
              if (branch === 'main' || branch === 'master') {
                const rev = spawnSync('git', ['rev-parse', '--verify', 'HEAD'], {
                  cwd: root,
                  encoding: 'utf-8',
                });
                if (rev.status === 0) {
                  throw new Error(
                    '[Convention Guard] Direct commits on main or master are forbidden. Switch to a feature branch: git switch -c feat/<issue-id>-<short-description>',
                  );
                }
              }
            } catch (err) {
              if (err.message && err.message.includes('[Convention Guard]')) {
                throw err;
              }
            }
          }
        }
      }
    },

    'tool.execute.after': async (input, output) => {
      const args = input?.args || output?.args || {};
      const dartFiles = new Set();

      if (args.filePath && typeof args.filePath === 'string' && args.filePath.endsWith('.dart')) {
        dartFiles.add(args.filePath);
      }
      if (args.path && typeof args.path === 'string' && args.path.endsWith('.dart')) {
        dartFiles.add(args.path);
      }

      if (args.patchText && typeof args.patchText === 'string') {
        const patchRegex = /^\*\*\*\s+(?:Add|Update)\s+File:\s*(\S+\.dart)/gm;
        let match;
        while ((match = patchRegex.exec(args.patchText)) !== null) {
          dartFiles.add(match[1]);
        }
      }

      if (dartFiles.size === 0) return;

      const fileList = Array.from(dartFiles).filter((f) => {
        return (
          !f.includes('lib/l10n/app_localizations') &&
          !f.endsWith('.g.dart') &&
          !f.endsWith('.freezed.dart') &&
          !f.includes('.dart_tool/') &&
          !f.includes('build/')
        );
      });

      if (fileList.length === 0) return;

      const runScript = resolve(root, 'tool/run_compiled.sh');
      const res = spawnSync(
        'sh',
        [runScript, 'agent_hook', 'claude', 'check-files', ...fileList],
        {
          cwd: root,
          encoding: 'utf-8',
        },
      );

      if (res.status !== 0) {
        const violations = (res.stdout || res.stderr || '').trim();
        if (violations) {
          if (output && typeof output.output === 'string') {
            output.output += `\n\nCONVENTION VIOLATIONS (fix immediately):\n${violations}`;
          } else if (typeof output === 'string') {
            output += `\n\nCONVENTION VIOLATIONS (fix immediately):\n${violations}`;
          }
        }
      }
    },
  };
};
