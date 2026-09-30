<!-- codex-harness: generated 2026-09-28 -->
# Follow-ups

Record real debt or opportunities here; do not duplicate active work.

## codex-local-marketplace-unusable
Found 2026-09-30 while attempting the abandoned `rename-plugin-namespace-eng`.
`/Users/danny/codex-local-marketplace/plugins/engineering` is a dangling
symlink to `/Users/danny/Desktop/GitHub/engineering-plugin` — a path that no
longer exists, since the repo moved to `~/dev/GitHub/`. Verified with
`ls -la` and `readlink`. Consequences, independent of any rename:

- README § Update the local Engineering plugin cannot run: its
  `read_text()` on the plugin manifest raises `FileNotFoundError` before any
  assertion is reached.
- `codex plugin list` reports `engineering@local` at 0.1.1, so the installed
  copy is far behind this repo's 0.2.4 manifest.
- The symlink implies the marketplace was originally wired to the live working
  tree, which contradicts the README's `git archive HEAD` + rsync model. Two
  incompatible install philosophies coexist; that is why the breakage went
  unnoticed.
- Hazard if anyone repairs the symlink instead of replacing it: README's
  `rsync -a --delete` follows a destination symlink and would delete
  everything under the linked checkout absent from `git archive HEAD`,
  including `.git`.

Worth fixing whenever the local plugin next needs updating. The durable fix is
a git dist marketplace, as `smda` already uses
(`git@github.com:Hsiang-LinC/smda-plugin-dist.git`), which removes per-machine
marketplace maintenance entirely.
