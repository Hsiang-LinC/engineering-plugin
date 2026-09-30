<!-- codex-harness: generated 2026-09-28 -->
# Active Work

Entry format: `docs/harness/index.md` § Conventions.

## integrate-harness-and-runbook
- status: in-progress
- phase: implement
- owner: interactive
- source: user authorization to merge `codex/harness-delivery-lifecycle` and `codex/local-plugin-update-runbook` into `main`
- scope: integrate both candidate branches, preserve all completed ledger entries, verify the landed tree, push main
- non-goals: release or install the Engineering plugin locally; alter the separate active worktree
- acceptance: main contains both branch contents and earlier harness commits; merged ledger retains both completion records; required checks pass; remote main equals local main
- verify: merge conflict review; `git diff --check`; manifest parse; referenced harness paths; changed skill and delivery scenarios; remote SHA
- base: `1afe938` (`main`)
- branch: `codex/integrate-harness-and-runbook`
- checkout: `/Users/danny/Developer/GitHub/engineering-plugin`
- next: merge both branches and resolve the completed-ledger conflict
- updated: 2026-09-30
