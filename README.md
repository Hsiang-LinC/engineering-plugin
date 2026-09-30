# Engineering Plugin

I maintain this plugin as a personal collection of development skills I have gathered, adapted, and curated through day-to-day software work. It captures the workflows I want available across repositories: establishing durable project context, challenging designs, diagnosing failures, shaping work, and implementing changes behind explicit quality gates.

The collection is intentionally practical. Each skill handles a recognizable task, while the development harness gives workflow-oriented skills a shared understanding of the repository.

## Workflow

I start by running `setup-codex-development-harness` when adopting a new or existing repository. It establishes a durable repository contract for project direction, tracker rules, documentation and artifact routes, and quality gates. This keeps agents from rediscovering the same context in every session and gives later skills a consistent foundation.

From there, I use focused skills as the work requires:

| Skill | Purpose |
| --- | --- |
| `setup-codex-development-harness` | Bootstrap or refresh the repository context that the workflow relies on. |
| `grill-me`, `grill-with-docs` | Pressure-test a plan, resolve ambiguous decisions, and align terminology with domain documentation. |
| `zoom-out`, `improve-codebase-architecture` | Map unfamiliar code or identify focused opportunities to deepen module boundaries. |
| `diagnose`, `tdd` | Reproduce difficult failures, identify root causes, and leave regression coverage through red-green-refactor. |
| `prototype` | Build a deliberately throwaway implementation when a state model or UI direction needs evidence. |
| `to-prd`, `to-issues`, `triage` | Turn an understood problem into durable product context, vertical-slice work items, and tracker-ready work. |
| `swift-dev-guideline` | Apply modern Swift, SwiftUI, SwiftData, concurrency, and Xcode verification conventions. |
| `handoff` | Preserve enough context for another agent or session to continue cleanly. |

## Usage

Set up the repository contract first:

```text
$setup-codex-development-harness Set up this repository around its existing tracker and documentation. Show me the proposed harness before writing it.
```

Shape a feature into executable work:

```text
$grill-with-docs Stress-test this feature against the current domain model.
$to-prd Turn our decisions into a PRD.
$to-issues Break the PRD into tracer-bullet issues.
```

Diagnose and fix a regression:

```text
$diagnose Reproduce this failure, isolate the root cause, and fix it with $tdd.
```

Apply the Swift conventions:

```text
$swift-dev-guideline Review this SwiftUI change and replace legacy APIs without changing behavior.
```

## Additional skills

The plugin also includes focused utilities for communication, repository setup, course authoring, test-data migration, and skill creation:

- `caveman`
- `migrate-to-shoehorn`
- `scaffold-exercises`
- `setup-pre-commit`
- `write-a-skill`

## Installation

This repository is a marketplace that both Codex and Claude Code read, published
from `main` on GitHub. The plugin is named `engineering`; the marketplace is
`engineering-plugin`, so it installs as `engineering@engineering-plugin`.

Codex:

```bash
codex plugin marketplace add https://github.com/Hsiang-LinC/engineering-plugin.git
codex plugin add engineering@engineering-plugin
```

Claude Code:

```bash
claude plugin marketplace add https://github.com/Hsiang-LinC/engineering-plugin.git
claude plugin install engineering@engineering-plugin
```

Claude Code also ships a bundled Engineering plugin that uses the same
`engineering:` prefix. The two share no skill names today, but a skill added here
with the same name as one of its ten (`architecture`, `code-review`, `debug`,
`deploy-checklist`, `documentation`, `incident-response`, `standup`,
`system-design`, `tech-debt`, `testing-strategy`) would collide silently, and
which one wins is untested.

### Update the Engineering plugin

Run both steps, in order, for each agent. Do not rely on skipping the first:
with Codex, running only the second step keeps the old version (measured twice);
with Claude Code, against the same real remote, the second step alone updated
when the marketplace clone was about five minutes old (refreshing the clone as a
side effect) and did not when it was about sixteen seconds old; the threshold
between them was not measured.

Codex:

```bash
codex plugin marketplace upgrade
codex plugin add engineering@engineering-plugin
```

Claude Code, then restart the session:

```bash
claude plugin marketplace update engineering-plugin
claude plugin update engineering@engineering-plugin
```

### Release

1. Get the change accepted under the repository harness.
2. Set `version` to the same new value in both `.codex-plugin/plugin.json` and
   `.claude-plugin/plugin.json`. Claude Code pins to the version string: in one
   local test, changed content under an unchanged version reached the
   marketplace clone but not the installed copy (not yet checked against the
   real remote). Codex refreshed the installed copy in a test, but do not rely
   on that.
3. Commit, merge to `main` and push.
4. In each agent, run the update steps above, confirm the reported version, and
   exercise a changed skill in a fresh session.

If a release is bad, revert it in a new commit with a still newer version in both
manifests, then follow the same steps.

### Migrating from the local marketplace

An earlier setup installed this plugin from a local directory marketplace as
`engineering@local`. That id is different from `engineering@engineering-plugin`,
so both would stay installed and every skill would appear twice. Remove the old
one after the new one works:

```bash
codex plugin remove engineering@local
codex plugin marketplace remove local
```

Delete the old marketplace directory afterwards if it holds nothing else.
