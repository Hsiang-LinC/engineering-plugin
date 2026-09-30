<!-- codex-harness: generated 2026-09-28 -->
# Active Work

Entry format: `docs/harness/index.md` § Conventions.

## local-plugin-update-runbook
- status: in-progress
- phase: deliver
- owner: interactive
- source: user correction in this conversation; prior `engineering-plugin-0-2-2-local-upgrade` evidence
- scope: document the verified local marketplace staging, versioned Codex install, and source/marketplace/cache checks
- non-goals: install a new version into the user's active Codex configuration or merge unrelated harness branches
- acceptance: another agent can follow the documented update path with an isolated or authorized marketplace; the process does not reuse a version number for changed plugin contents
- verify: isolated `CODEX_HOME` rehearsal of staging and installation, hash parity, README command/path review, `git diff --check`, independent review
- base: `1afe938` (`main`)
- branch: `codex/local-plugin-update-runbook`
- checkout: `/Users/danny/Developer/GitHub/engineering-plugin`
- accepted: independent reviewer PASS on 2026-09-30 for README patch SHA-256 `a912d350c128db9efd88f6ee7dc40217dfe22124c97638cb3c20a89c6ee4b379`; tracker entry excluded
- evidence: isolated `CODEX_HOME` marketplace rehearsal installed test versions 9.9.8 then 9.9.9; complete staged, marketplace, and cache trees matched by `diff -qr`; current active Codex installation was untouched; `git diff --check` passed
- delivery: source accepted; commit and push pending; merge and active plugin installation are separate decisions
- next: commit the reviewed README change, push this branch, verify remote SHA
- updated: 2026-09-30
