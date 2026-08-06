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

Add the local marketplace that contains this plugin:

```bash
codex plugin marketplace add /path/to/codex-local-marketplace
```
