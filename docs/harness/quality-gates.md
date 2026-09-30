<!-- codex-harness: generated 2026-09-28 -->
# Quality Gates

Run the checks relevant to the changed artifact before completion.

| Change | Required check |
|---|---|
| Any tracked change | `git diff --check` |
| Skill trigger or instructions | Read the whole changed skill; exercise at least one matching and one nonmatching request, and record observed routing/behavior |
| Harness templates or routing | Compare generated paths and roles with this repo plus one concrete consuming repo; exercise affected scenarios in `skills/setup-codex-development-harness/behavioral-checks.md` |
| Executable script | Run the changed script's smallest meaningful test or self-check; record command and output |
| Manifest or release metadata | Parse `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`; verify referenced paths exist; `claude plugin validate .` passes |
| Plugin manifest pair | `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json` carry the same `name` and `version`, and any change to plugin content bumps both — Claude Code pins to the version string and will not deliver changed content under an unchanged one |
| README or other prose | Check changed links/paths and claims against the repository |
| Git delivery in scope | Verify the pushed ref; after actual integration, verify the landed target SHA and run applicable landed checks before cleanup |
| Plugin installation in scope | For each agent in scope, compare the source, the marketplace snapshot and the installed version/hash; exercise a matching skill scenario from the installed copy in a fresh session |

No repository-wide build, linter, or test suite was detected at setup. Do not
claim a check ran merely because it is listed here. For every item, report
applicable checks, outcomes, skipped checks with reasons, criterion-level
evidence, and residual risk. A failed required check blocks completion; use
`docs/harness/tracker.md` § Failure Handling. Review and acceptance are
separate from passing checks. A source acceptance does not establish delivery;
record post-delivery checks when Git integration or installation is in scope.
