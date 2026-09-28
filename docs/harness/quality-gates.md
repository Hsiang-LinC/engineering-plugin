<!-- codex-harness: generated 2026-09-28 -->
# Quality Gates

Run the checks relevant to the changed artifact before completion.

| Change | Required check |
|---|---|
| Any tracked change | `git diff --check` |
| Skill trigger or instructions | Read the whole changed skill; exercise at least one matching and one nonmatching request, and record observed routing/behavior |
| Harness templates or routing | Compare generated paths and roles with this repo plus one concrete consuming repo; exercise affected scenarios in `skills/setup-codex-development-harness/behavioral-checks.md` |
| Executable script | Run the changed script's smallest meaningful test or self-check; record command and output |
| Manifest or release metadata | Parse `.codex-plugin/plugin.json` and verify referenced paths exist |
| README or other prose | Check changed links/paths and claims against the repository |

No repository-wide build, linter, or test suite was detected at setup. Do not
claim a check ran merely because it is listed here. For every item, report
applicable checks, outcomes, skipped checks with reasons, criterion-level
evidence, and residual risk. A failed required check blocks completion; use
`docs/harness/tracker.md` § Failure Handling. Review and acceptance are
separate from passing checks.
