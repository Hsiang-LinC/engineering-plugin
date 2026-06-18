# Setup SMDA Automation Skill Design

Date: 2026-06-14
Status: draft for spec review
Review scope: engineering plugin local spec review

## Purpose

Replace the legacy `setup-symphony-orchestration` skill with a reusable setup
skill for State-Machine-Driven Automation (SMDA).

The prior skill installed one specific Symphony wiring path: derive
`WORKFLOW.md` / `REVIEW.md` from a Codex development harness and run legacy
worker/orchestrator automation. The new skill must install or refresh a broader
automation method:

```text
approved spec
-> reviewed task graph
-> backlog-visible child tasks
-> deterministic phase machine per child
-> parent integration branch
-> parent verification / QA
-> final accept
```

The method must be independent of any one harness, backlog manager, or
orchestrator. The default adapter stack remains:

- Codex development harness for repository context;
- Linear parent/child hierarchy and blocking relations for project visibility;
- Symphony SMDA runtime for deterministic execution.

Setup targets SMDA-only wiring. Legacy worker/orchestrator artifacts are a hard
gate: the skill reports them and stops until a repo-specific hard-replacement
spec exists or the user explicitly removes the legacy artifacts.

## Ownership And Review Scope

This spec belongs to the engineering plugin repo, not to any target project
that later installs the skill. A project tracker issue may reference this skill
as an upstream method or adapter dependency, but it does not approve or close
the skill itself.

Review completion for this spec must be recorded through the engineering
plugin's own review surface. If that repo has no tracker or review automation,
the status remains `draft for spec review` until a local reviewer records an
explicit approval artifact in this repo.

## Goals

- Create a skill future agents can use to set up SMDA in new repos.
- Preserve SMDA as a methodology with adapters, not a trading-advisor-specific
  implementation detail.
- Make the skill spec-reviewable before runtime implementation catches up.
- Replace `setup-symphony-orchestration` in the engineering plugin skill list.
- Keep setup safe: setup may write config/docs, but must not start autonomous
  loops, publish live child issues, or mutate live tracker state without
  explicit user approval.

## Non-Goals

- Do not implement the Symphony SMDA runtime in this skill spec.
- Do not require Linear specifically; Linear is the default adapter, not the
  method.
- Do not require Codex development harness specifically; it is the preferred
  context substrate.
- Do not migrate legacy Symphony repos or provide a compatibility mode.
- Do not publish child issues or start daemons during setup validation.
- Do not create a new tracker protocol inside the skill; name missing adapter
  surfaces and stop.

## Concept Model

SMDA separates method, adapters, and runtime:

```text
SMDA method
  parent spec, task graph, child phases, accept gates, QA loop

Context adapter
  Codex development harness or equivalent repo map

Backlog adapter
  Linear, GitHub, local ledger, or custom issue graph

Runtime adapter
  Symphony SMDA or another deterministic orchestrator
```

The skill installs the operating model and repo wiring for those layers. It
does not make the harness, backlog manager, or orchestrator the source of the
methodology.

## Skill Package Shape

Target directory:

```text
plugins/engineering/skills/setup-smda-automation/
  SKILL.md
  methodology.md
  adapters.md
  fixtures/README.md
```

`SKILL.md` stays under 100 lines and contains only the trigger, hard gates, and
setup process. Heavy details live in reference files.

`methodology.md` defines the reusable SMDA contract:

- Parent issue, child issue, task node, phase, attempt, artifact.
- Parent spec approval paths.
- Graph decomposition and two-stage graph review.
- Child SDD phase machine.
- Static and runtime context packets.
- Dependency typing and parallelism.
- Graph mutation policy.
- Parent integration branch and QA remediation loop.
- Artifact retention and promotion.
- SMDA-only issue-entry policy for unmodeled work.

`adapters.md` defines default integrations:

- Codex development harness.
- Linear/GitHub/local backlog surfaces.
- Symphony runtime and legacy hard-gate detection.
- Bootloader, harness routing, and handoff awareness required for new agent
  sessions.
- Target repo artifacts and validation.

`fixtures/README.md` defines clean-room pressure scenarios used to review the
skill.

## Skill Description Requirement

The skill front matter description must describe triggering conditions only. It
must not summarize the SMDA workflow. This avoids the known failure mode where
future agents read the description as a shortcut and skip the skill body.

Acceptable trigger shape:

```yaml
description: Use when a repo needs reusable State-Machine-Driven Automation...
```

Disallowed shape:

```yaml
description: Sets up SMDA by turning approved specs into child graphs...
```

## Setup Flow

### 1. Explore

Read the target repo's:

- bootloader (`AGENTS.md`, `CLAUDE.md`, or equivalent);
- harness/tracker contract if present;
- quality gates;
- roadmap, spec, ADR, architecture, and contract docs;
- current orchestrator config;
- tracker/backlog evidence;
- existing legacy Symphony artifacts.

Classify the run:

- setup: no SMDA exists;
- refresh: SMDA exists and needs drift checks;
- legacy blocked: legacy Symphony orchestration exists;
- runtime drift repair: SMDA exists but config/state is inconsistent.

### 2. Propose

Before writing, present the detected stack:

- context substrate;
- backlog manager;
- orchestrator/runtime;
- roadmap policy for multi-parent restructuring;
- parent spec approval policy;
- graph publication policy;
- branch/merge strategy;
- issue-entry policy for unmodeled work;
- verification and QA gates;
- legacy blockers, if present.

Default recommendation when all adapters exist:

```text
Codex development harness
+ Linear hierarchy/blocking relations
+ Symphony SMDA runtime
```

The user must approve first-time writes. Legacy replacement is out of scope for
this reusable setup skill and belongs in a repo-specific spec.

### 3. Write Or Refresh

The skill may create or update:

- SMDA docs or harness routing entries;
- bootloader pointers that route new agent sessions into the harness/SMDA docs;
- roadmap/spec routing pointers for large changes and parent dependencies;
- runtime config or prompt/template references;
- schema/config files for graph and phase results;
- `.gitignore` entries for runtime state and workspaces;
- legacy blocker report when setup stops.

The skill must preserve user-authored content and show diffs before replacing
existing harness, tracker, or orchestrator files.

### 4. Validate

Run non-live validation:

- skill front matter parse;
- SMDA config/schema validation when runtime tooling exists;
- tracker/harness consistency;
- prompt/template path checks;
- dry-run child publication when the runtime supports it.

Live actions require explicit approval:

- creating tracker states/labels;
- publishing child issues;
- starting daemons;
- accepting or merging branches.

### 5. Report

Report:

- installed/refreshed files;
- active adapters;
- validation command outcomes;
- legacy blockers found, if setup stopped;
- manual live steps remaining;
- follow-up issues required for full automation.

## Legacy Skill Replacement

The engineering plugin should expose `setup-smda-automation` and no longer
expose `setup-symphony-orchestration`.

The old skill directory can be deleted once the new skill and references exist.
The plugin README should explain that `setup-smda-automation` replaces the old
skill, which only generated legacy `WORKFLOW.md` / `REVIEW.md` orchestration.

## Adapter Contracts

### Context Adapter

A context substrate must provide:

- repository bootloader;
- tracker or work-state contract;
- quality gates;
- source-of-truth doc locations;
- architecture/contract/spec routing.

When SMDA is installed, the context adapter must also ensure new agent sessions
can discover the system without prior conversation state. The bootloader should
point to the harness routing doc; the harness routing doc should point to the
SMDA operating model, tracker contract, quality gates, and runtime truth. Handoff
must be expressed as durable pointers to tracker issue context, `.symphony/state`
or equivalent runtime state, and the relevant branch/artifacts.

If absent, the skill should recommend `setup-codex-development-harness` or ask
the user to identify equivalent context files.

### Backlog Adapter

A backlog manager must provide:

- parent/child grouping or equivalent parent references;
- dependency edges or equivalent blocker encoding;
- coarse states;
- comments/evidence;
- metadata/labels for SMDA parent and child execution modes.

Linear default mapping:

- hierarchy/sub-issues for parent aggregation and human navigation;
- blocking relations for child dispatch dependencies;
- `Todo` for scoped child tasks, including dependency-waiting children;
- `Blocked` only for abnormal state;
- `Done` only after SMDA internal close evidence exists;
- `Canceled` counts complete only when superseded by graph mutation evidence.

### Runtime Adapter

The runtime must support:

- deterministic state persistence;
- fresh workspace per attempt;
- prompt/template execution;
- structured result validation;
- candidate patch capture;
- verification execution;
- parent integration branch accept;
- tracker comment/state updates;
- reconciliation after partial failures.

Symphony is the default runtime, but not the method.

## Refresh And Legacy Detection

Refresh mode should detect:

- missing SMDA docs/config;
- stale skill references;
- old `setup-symphony-orchestration` references;
- legacy `WORKFLOW.md`, `ORCHESTRATOR.md`, and `REVIEW.md`;
- runtime/tracker drift;
- prompt/template path drift.

When legacy worker/orchestrator paths are detected, setup stops. The report
should name the artifacts and require either a repo-specific hard-replacement
spec or explicit artifact removal before SMDA setup continues.

## Clean-Room Fixtures

The skill should carry fixture scenarios:

- harness + Linear + Symphony SMDA happy path;
- harness present but missing SMDA bootloader/routing/handoff pointers;
- no harness/context substrate hard gate;
- legacy Symphony hard gate;
- unsupported tracker adapter hard gate;
- approved spec direct path;
- draft spec Human Review gate.

Fixture results are prompt-run evidence, not necessarily pytest. A failed
fixture should lead to tighter skill wording.

## Acceptance Criteria

- `setup-smda-automation/SKILL.md` exists and stays under 100 lines.
- Front matter description is trigger-only and <= 1024 characters.
- `methodology.md`, `adapters.md`, and fixture docs exist.
- Engineering plugin README lists `setup-smda-automation`.
- Engineering plugin README no longer lists `setup-symphony-orchestration`.
- No `setup-symphony-orchestration/SKILL.md` remains in the skill registry.
- The skill clearly states that setup does not start live autonomous loops.
- The skill distinguishes method from default adapters.
- The skill makes SMDA-only the target and treats legacy artifacts as hard
  blockers.
- The skill requires an explicit issue-entry policy so unmodeled work cannot
  bypass SMDA through a generic autonomous worker path.
- The skill requires bootloader/harness routing and handoff pointers so fresh
  agent sessions can find SMDA runtime state without conversation memory.

## Implementation Slices

1. Replace the skill entry.
   - Add `setup-smda-automation` directory.
   - Remove old `setup-symphony-orchestration` skill files.
   - Update engineering plugin README.

2. Write methodology reference.
   - Capture SMDA vocabulary and parent/child/phase model.
   - Capture graph review, context packet, dependency, mutation, QA, and
     retention policies.
   - Capture issue-entry policy for unmodeled work.

3. Write adapter reference.
   - Define Codex harness, backlog, and Symphony adapter contracts.
   - Define legacy hard-gate and validation rules.
   - Define bootloader/routing/handoff awareness requirements.

4. Add fixture scenarios.
   - Replace legacy clean-room fixture descriptions.
   - Include legacy hard-gate behavior.
   - Include draft/approved spec gates.

5. Verify skill shape.
   - Parse front matter.
   - Confirm description length and line count.
   - Confirm registry exposes the new skill only.

## Verification Plan

Run from `plugins/engineering`:

```bash
python3 - <<'PY'
from pathlib import Path
p = Path("skills/setup-smda-automation/SKILL.md")
text = p.read_text()
end = text.index("\n---\n", 4)
front = text[4:end]
name = [l for l in front.splitlines() if l.startswith("name:")][0].split(":", 1)[1].strip()
desc = [l for l in front.splitlines() if l.startswith("description:")][0].split(":", 1)[1].strip()
assert name == "setup-smda-automation"
assert len(desc) <= 1024
assert len(text.splitlines()) <= 100
PY
```

And:

```bash
python3 - <<'PY'
from pathlib import Path
names = []
for p in sorted(Path("skills").glob("*/SKILL.md")):
    text = p.read_text()
    end = text.index("\n---\n", 4)
    front = text[4:end]
    names.append([l for l in front.splitlines() if l.startswith("name:")][0].split(":", 1)[1].strip())
assert "setup-smda-automation" in names
assert "setup-symphony-orchestration" not in names
PY
```

## Open Follow-Ups

- Add executable validation scripts only after the runtime config format is
  stable.
- Add real clean-room fixture run logs after the Symphony SMDA runtime exists.
- Decide whether the engineering plugin should keep historical docs for the
  removed legacy skill or archive them under a historical note.
