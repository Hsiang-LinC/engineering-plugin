# Harness v3 Tracker-Adapter Rewrite — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite `setup-codex-development-harness` so tracker identity lives in one generated file (`docs/harness/tracker.md`), swappable across local/GitHub/Linear/JIRA, with an orchestration-ready interface contract.

**Architecture:** The skill stays documentation-only. A new `tracker-adapters.md` holds per-tracker presets of an eight-section contract; `core-templates.md` becomes tracker-agnostic and gains the v3 bootloader (bright-line rule); `SKILL.md` gains swap mode and v2-migration; `ledger-conventions.md` slims to archive/marker rules. Spec: `docs/superpowers/specs/2026-06-11-harness-v3-tracker-adapter-design.md`.

**Tech Stack:** Markdown skill files only. Verification = grep gates + clean-room subagent fixture tests (no pytest — there is no code).

**Working directory for all tasks:** `/Users/danny/codex-local-marketplace/plugins/engineering` (git repo root). Skill dir: `skills/setup-codex-development-harness/`.

**Repo conventions:** commit subjects use `feat(harness-skill): ...` / `fix(harness-skill): ...` / `docs(harness-skill): ...`. Do not touch `.codex-plugin/plugin.json`, `README.md`, `hooks/`, or other skills — they carry unrelated uncommitted changes.

---

### Task 1: Create `tracker-adapters.md` (new file)

**Files:**
- Create: `skills/setup-codex-development-harness/tracker-adapters.md`

- [ ] **Step 1: Write the file with exactly this content**

````markdown
# Tracker Adapters

Presets for `docs/harness/tracker.md`. Generation picks one preset, fills
`{...}` braces from detection, and writes it as `docs/harness/tracker.md`
with the standard generated header and `Last verified:` line. Generated
repos must not depend on this plugin file at runtime.

## The Contract

Every adapter fills the same eight sections, in this order. A missing or
brace-containing section fails validation. This file is simultaneously the
agent's tracker manual and any orchestrator's integration interface.

1. **Identity** — kind, where truth lives, work-item ID format.
2. **State Machine** — states: name / meaning / which actor may set it.
   Authority boundaries are encoded here.
3. **Labels** — actor / work-type / gate classifications ("none" is valid).
4. **Dispatch Eligibility** — one machine-checkable rule for what an
   orchestrator may dispatch.
5. **Read / Write** — how an agent reads its work item and posts updates
   (MCP tool names, CLI commands, or file edits). Name the access path
   actually detected in the repo; if none, state "none detected — report
   to user".
6. **Completion Evidence** — required content: changed files, verification
   commands and outcomes, remaining risks, follow-up refs.
7. **Archive Policy** — how Done/Canceled items become `completed.md` /
   `abandoned.md` entries (per-item at completion, batch at refresh).
8. **Interactive Rule** — behavior when bright-line work has no matching
   item: create one (with what defaults) or ask the user.

## Preset: local

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: Local Ledger

Last verified: {DATE}

## Identity
- kind: local
- truth: `docs/work-ledger/` files in this repo
- id format: kebab-slug section headings (`## <slug>`)

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| planned | scoped, not started | anyone |
| in-progress | being worked | the agent working it |
| blocked | needs human decision or external change | anyone |
| done | verified complete; entry moves to `completed.md` | the agent, with evidence |
| abandoned | dropped; entry moves to `abandoned.md` with `resume-if:` | human, or agent with human approval |

States live in the `status:` field of `active.md` / `follow-ups.md` entries.

## Labels
{repo-specific labels, else "none"}

## Dispatch Eligibility
An item is dispatchable when its `active.md` entry has `status: planned`,
no `blocked-by:` field, and a concrete action in `next:`.

## Read / Write
- read: open `docs/work-ledger/active.md`, find your entry
- write: edit entry fields directly; move entries between ledger files on
  state change
- entry formats: `docs/harness/index.md` § Conventions

## Completion Evidence
Moving an entry to `completed.md` requires: `done:` date, `summary:`,
`verified:` (command run + outcome), `follow-ups:` ref or none.

## Archive Policy
`completed.md` and `abandoned.md` are written at completion time — they ARE
the archive; no backfill loop needed.

## Interactive Rule
Bright-line work with no matching entry: add one to `active.md`
(`status: planned` or `in-progress`) before the first edit. Entry creation
is cheap and reversible — do not ask permission for it.
```

## Preset: github

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: GitHub Issues

Last verified: {DATE}

## Identity
- kind: github
- truth: GitHub issues in `{owner/repo}`
- id format: `#<number>`

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| open | backlog or active; refine with labels | anyone |
| open + label `in-progress` | claimed | the claiming agent |
| open + label `blocked` | waiting on human or external change | anyone |
| closed (completed) | accepted done | human, after review |
| closed (not planned) | abandoned | human |

Agents never close issues as completed — human review closes.

## Labels
- actor: `agent`, `human` {extend per repo}
- work-type: {repo-specific, else omit}
- gate: `needs-plan`, `needs-review` {extend per repo}

## Dispatch Eligibility
open, labeled `agent`, not labeled `blocked` or `in-progress`, body contains
acceptance criteria and verification expectations.

## Read / Write
- read: {detected: `gh issue view <n>` | GitHub MCP tool names | none detected — report to user}
- write: {detected: `gh issue comment <n>` / `gh issue edit <n> --add-label` | MCP equivalents}

## Completion Evidence
Completion comment must include: changed files; verification commands and
outcomes; remaining risks; follow-up issue refs.

## Archive Policy
closed-completed → `completed.md` entry; closed-not-planned →
`abandoned.md` entry (`resume-if:` from the closing comment). Per item at
completion or batch at refresh.

## Interactive Rule
Bright-line work with no matching issue: create one with an actor label, or
ask the user when scope is unclear.
```

## Preset: linear

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: Linear

Last verified: {DATE}

## Identity
- kind: linear
- truth: Linear project `{project}`
- id format: `{TEAM}-<number>`

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| Backlog | captured, not ready | human |
| Todo | scoped, dispatch-eligible when labeled | human |
| In Progress | claimed | orchestrator or agent |
| In Review | work done; human review pending | agent, with evidence |
| Done | human accepted | human only |
| Blocked | waiting on decision/dependency/credential | anyone |
| Canceled | will not be actioned | human |

Agents and orchestrators never set `Done` — human review is the acceptance gate.

## Labels
- actor: `agent`, `human`, `pairing`
- work-type: {repo-specific}
- gate: `needs-plan`, `needs-review` {extend per repo}

## Dispatch Eligibility
state `Todo`, labeled `agent`, no non-terminal blocking dependencies, body
contains acceptance criteria and verification expectations.

## Read / Write
- read: {detected Linear MCP tool names | none detected — report to user}
- write: comment + state update via the same path; final state changes
  agents may make: `In Review` (success), `Blocked` (failure)

## Completion Evidence
Completion comment must include: changed files; verification commands and
outcomes; remaining risks; follow-up issue refs.

## Archive Policy
`Done` → `completed.md` entry; `Canceled` → `abandoned.md` entry with
`resume-if:`. Batch backfill at refresh.

## Interactive Rule
Bright-line work with no matching issue: create one (`Todo`, actor label),
or ask the user when scope is unclear.
```

## Preset: jira

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: JIRA

Last verified: {DATE}

## Identity
- kind: jira
- truth: JIRA project `{KEY}` at `{instance URL}`
- id format: `{KEY}-<number>`

## State Machine

JIRA workflows are instance-specific — fill from the actual board:

| State | Meaning | Who may set |
|---|---|---|
| {To Do} | scoped, dispatch-eligible when labeled | human |
| {In Progress} | claimed | orchestrator or agent |
| {In Review} | work done; human review pending | agent, with evidence |
| {Done} | human accepted | human only |
| {Blocked} | waiting | anyone |

Agents never transition to {Done} — human review is the acceptance gate.

## Labels
- actor: `agent`, `human` {map to labels or components per instance}
- work-type / gate: {repo-specific}

## Dispatch Eligibility
state {To Do}, labeled `agent`, no blocking links, description contains
acceptance criteria and verification expectations.

## Read / Write
- read: {detected: JIRA MCP tools | `jira issue view` CLI | none detected — report to user}
- write: comment + transition via the same path; agent-allowed transitions:
  {In Review}, {Blocked}

## Completion Evidence
Completion comment must include: changed files; verification commands and
outcomes; remaining risks; follow-up issue refs.

## Archive Policy
{Done} → `completed.md` entry; abandoned resolutions → `abandoned.md` with
`resume-if:`. Batch backfill at refresh.

## Interactive Rule
Bright-line work with no matching issue: create one ({To Do}, actor label),
or ask the user when scope is unclear.
```

## Custom skeleton

For trackers without a preset. Same eight sections; every line is a brace to
fill with the user. The validation gate (all sections filled, no braces left)
applies unchanged.

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: {name}

Last verified: {DATE}

## Identity
- kind: custom
- truth: {where}
- id format: {format}

## State Machine
{states table: name / meaning / who may set. Encode the human acceptance gate.}

## Labels
{classifications, or "none"}

## Dispatch Eligibility
{one machine-checkable rule}

## Read / Write
{detected access path; "none detected — report to user" is valid}

## Completion Evidence
{required content — default: changed files; verification commands and
outcomes; remaining risks; follow-up refs}

## Archive Policy
{terminal states → completed.md / abandoned.md mapping}

## Interactive Rule
{create-or-ask behavior for bright-line work without a matching item}
```
````

- [ ] **Step 2: Verify contract-section consistency**

Run:
```bash
cd /Users/danny/codex-local-marketplace/plugins/engineering/skills/setup-codex-development-harness
grep -c '^## Identity' tracker-adapters.md
grep -c '^## Interactive Rule' tracker-adapters.md
```
Expected: both print `5` (four presets + custom skeleton).

- [ ] **Step 3: Commit**

```bash
cd /Users/danny/codex-local-marketplace/plugins/engineering
git add skills/setup-codex-development-harness/tracker-adapters.md
git commit -m "feat(harness-skill): add tracker adapter presets (v3)"
```

---

### Task 2: Slim `ledger-conventions.md`

**Files:**
- Modify: `skills/setup-codex-development-harness/ledger-conventions.md` (full replace)

- [ ] **Step 1: Replace the whole file with this content**

The tracker/no-tracker variant section dies (replaced by the adapter model);
live-entry format survives for local mode; archive formats, markers,
staleness, roll-off survive for all modes.

````markdown
# Ledger Conventions

Rules referenced by generated harness docs. When generating, copy the
*applicable* rules into `docs/harness/index.md` `## Conventions` — generated
repos must not depend on this plugin file at runtime.

## Entry Format

Section entries, never tables. Rationale: append-only, merge-friendly, and a
missing field is visibly absent (table columns get silently dropped).

### `active.md` / `follow-ups.md` — local mode only

Remote-tracker modes do not generate these files; live state lives in the
tracker per `docs/harness/tracker.md`.

```markdown
## <kebab-slug>
- status: planned | in-progress | blocked
- source: <spec / plan / conversation ref>
- next: <single concrete next action>
- updated: YYYY-MM-DD
```

### `completed.md` — archive, all modes

```markdown
## <kebab-slug>
- done: YYYY-MM-DD
- summary: <what changed>
- verified: <test command run / evidence; "backfilled from git history" or
  "backfilled from <tracker> <id>" for backfill entries>
- follow-ups: <ref into follow-ups.md or the tracker, or none>
```

### `abandoned.md` — archive, all modes

```markdown
## <kebab-slug>
- abandoned: YYYY-MM-DD
- why: <reason>
- resume-if: <condition that would make it viable again>
```

Remote-tracker modes: archive entries may carry the tracker work-item ID in
`verified:`/`why:` — IDs inside entries are data, not tracker identity, and
do not violate the tracker-leak gate.

## Markers

- Every generated file starts with: `<!-- codex-harness: generated YYYY-MM-DD -->`
- The bootloader block is wrapped in `<!-- codex-harness:begin -->` /
  `<!-- codex-harness:end -->`
- Refresh mode patches **only inside markers**. Content outside markers is
  user-authored and untouchable without asking.

## Staleness

- Every generated doc carries `Last verified: YYYY-MM-DD` directly under its
  title. Refresh updates it after re-verifying the file's claims.
- Refresh flags any file overdue by more than 90 days.

## Archive Policy

When `completed.md` exceeds ~200 entries or spans more than 1 year, refresh
rolls the oldest entries into `docs/work-ledger/archive/completed-YYYY.md`
(same entry format, one file per year).
````

- [ ] **Step 2: Verify the variant section is gone**

Run:
```bash
grep -c 'tracker variant\|no-tracker' skills/setup-codex-development-harness/ledger-conventions.md
```
Expected: `0` (grep exits 1).

- [ ] **Step 3: Commit**

```bash
git add skills/setup-codex-development-harness/ledger-conventions.md
git commit -m "feat(harness-skill): slim ledger-conventions to archive/marker rules (v3)"
```

---

### Task 3: Rewrite `core-templates.md`

**Files:**
- Modify: `skills/setup-codex-development-harness/core-templates.md` (full replace)

- [ ] **Step 1: Replace the whole file with this content**

````markdown
# Core Templates

Everything the **core** topology generates: bootloader block, pointer line,
`docs/harness/index.md`, `docs/harness/tracker.md` (from a
[tracker-adapters.md](tracker-adapters.md) preset), and the work-ledger
files. `{...}` braces = fill at generation time. Entry formats come from
[ledger-conventions.md](ledger-conventions.md).

Ledger files by mode: **local** generates all four; **remote trackers**
generate only the two archives (`completed.md`, `abandoned.md`).

## Bootloader block (single residence, ~15 lines max)

```markdown
<!-- codex-harness:begin -->
## Development Harness

Before any development task, read `docs/harness/index.md` and follow its routing.

Hard rules:
1. Work state lives in the tracker — read `docs/harness/tracker.md` before
   starting work.
2. Bright line: any work that changes code, contracts, or docs is
   tracker-worthy — before the first edit, confirm a work item covers it or
   create one per `tracker.md` (interactive sessions included). Pure
   reading, discussion, or Q&A is not tracker-worthy.
3. Definition of done includes the tracker update defined in `tracker.md`
   and updating durable repo docs when facts changed.
4. Routing tables live only in `docs/harness/index.md`. Do not duplicate them here.
<!-- codex-harness:end -->
```

## Pointer line (every other detected bootloader)

```markdown
<!-- codex-harness:begin -->
Development harness: see `AGENTS.md` § Development Harness. Tracker contract
in `docs/harness/tracker.md`.
<!-- codex-harness:end -->
```

(Replace `AGENTS.md` with the actual residence file if the user chose another.)

## `docs/harness/tracker.md`

Generated from the chosen preset in [tracker-adapters.md](tracker-adapters.md)
— the **only** file in the generated repo that names the concrete tracker.
All eight contract sections filled; no braces left.

## `docs/harness/index.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Development Harness Index

Last verified: {DATE}

Single residence of routing facts for this repo. Bootloaders point here;
never copy these tables elsewhere. Tracker identity lives only in
`docs/harness/tracker.md`.

## Start Sequence

1. Read `docs/harness/tracker.md`; read your work item per its Read/Write
   section.
2. Identify your task type in the routing table.
3. Read the listed context; use the listed workflow.
4. Before closing: post completion evidence and the state update per
   `tracker.md`; update durable repo docs when facts changed.

## Task Routing

| Task type | Read first | Workflow | Completion update |
|---|---|---|---|
| New feature | {repo-specific docs/dirs} | {detected design+planning skills, else "design before code"} | tracker update per `tracker.md`; durable docs if facts changed |
| Bug / regression | {repo-specific docs/tests} | {detected debugging skill, else "reproduce before fixing"} | regression test; tracker update per `tracker.md` |
| Unfamiliar area | {architecture docs if extended, else key source dirs} | {detected exploration skill, else targeted reading} | index/map update if stable knowledge gained |
| Architecture decision | {CONTEXT.md / docs/adr/ if present} | {detected decision skill, else "write an ADR"} | the decision doc; tracker update per `tracker.md` |
| Completion check | Conventions § quality gates | {detected verification skill, else "run full test suite"} | completion evidence per `tracker.md` |

Rows are a starting set — keep only the ones meaningful for this repo, add
repo-specific ones found during exploration.

## Coexisting Systems

| System | Class | Truth |
|---|---|---|
| {detected system} | orthogonal-composed \| overlap-resolved \| conflict-user-decided | {where its truth lives} |
| {detected orchestrator, if any} | orthogonal-composed | its own config; state/label names must match `tracker.md` |

## Conventions

- Tracker: `docs/harness/tracker.md` — the only file that names the tracker.
- Archives: `completed.md` / `abandoned.md` exist in every mode; entries
  written per `tracker.md` § Archive Policy.
- Entry formats: {paste the applicable formats from ledger-conventions:
  archives always; live entries in local mode only}
- Markers: `codex-harness` comments delimit generated regions. Edit outside
  them freely; refresh never touches user-authored content.
- Quality gates: {repo test/lint commands} must pass before completion
  evidence is posted.
```

## `docs/work-ledger/active.md` (local mode only)

```markdown
<!-- codex-harness: generated {DATE} -->
# Active Work

Entry format: see `docs/harness/index.md` § Conventions.

{entries discovered during exploration, or nothing — an empty section list is valid}
```

## `docs/work-ledger/follow-ups.md` (local mode only)

```markdown
<!-- codex-harness: generated {DATE} -->
# Follow-ups

Known debt and opportunities. Entry format: see `docs/harness/index.md` § Conventions.

{entries found during exploration, or nothing}
```

## `docs/work-ledger/completed.md` (all modes)

```markdown
<!-- codex-harness: generated {DATE} -->
# Completed Work

Archive — newest first. Entry format: see `docs/harness/index.md` § Conventions.

{backfilled milestone entries from git history — and from the tracker's Done
 items in remote modes — newest first}

## project-started
- done: {date of first commit, or today for greenfield}
- summary: project started
- verified: {backfilled from git history | greenfield init}
- follow-ups: none
```

## `docs/work-ledger/abandoned.md` (all modes)

```markdown
<!-- codex-harness: generated {DATE} -->
# Abandoned Work

Archive — paths tried and dropped, each with a resume condition. Entry
format: see `docs/harness/index.md` § Conventions.

{entries found during exploration — and from the tracker's Canceled items in
 remote modes — or nothing}
```
````

- [ ] **Step 2: Verify tracker-agnosticism of the templates**

Run:
```bash
grep -in 'linear\|jira\|github' skills/setup-codex-development-harness/core-templates.md
```
Expected: no matches (exit 1). Concrete tracker names live only in
`tracker-adapters.md`.

- [ ] **Step 3: Verify the bright line is present**

Run:
```bash
grep -c 'Bright line' skills/setup-codex-development-harness/core-templates.md
```
Expected: `1`.

- [ ] **Step 4: Commit**

```bash
git add skills/setup-codex-development-harness/core-templates.md
git commit -m "feat(harness-skill): tracker-agnostic core templates with bright-line bootloader (v3)"
```

---

### Task 4: Rewrite `SKILL.md`

**Files:**
- Modify: `skills/setup-codex-development-harness/SKILL.md` (full replace)

- [ ] **Step 1: Replace the whole file with this content**

````markdown
---
name: setup-codex-development-harness
description: Use when adopting an agent in a new or existing repo, when agents re-explore the codebase every session, when project state (done/doing/abandoned) is scattered or stale, when switching issue trackers (local ledger, GitHub, Linear, JIRA), or when an existing harness needs refresh or a drift check.
---

# Setup Codex Development Harness

Create or refresh a repo-local harness so agents start from a durable map
instead of re-exploring. Four layers: **tracker contract**
(`docs/harness/tracker.md`), **archives** (`docs/work-ledger/`), **index +
routing** (`docs/harness/index.md`), **bootloader block**. Workflow stays
with the environment's process system; orchestrators integrate by reading
`tracker.md` + `index.md` — the skill never generates orchestrator config.

## Doctrine

- Write-cost first: judge every addition by whether agents will keep it updated.
- One fact, one residence. A fact in two generated places is a bug.
- Detection over mandate: absorb existing systems; require none.
- Uncommitted memory is not memory. Remote trackers hold live state; the
  git-resident archives (`completed.md`, `abandoned.md`) hold history in
  every mode.
- Tracker identity lives in exactly one file. Switching trackers must not
  touch routing.

## Mode Selection

- User asks to switch trackers → **swap mode**.
- `codex-harness` markers + `docs/harness/tracker.md` → **refresh mode**.
- `codex-harness` markers without `tracker.md` → **v2 migration**.
- Harness-shaped files (`docs/harness/`, `docs/work-ledger/`) without
  markers → **v1 migration**.
- Otherwise → **setup mode**.

## Setup Mode

### 1. Explore

Six detections (large repos: read-only subagents per area):

- **Structure** — source tree, build/test commands, module and runtime boundaries.
- **Docs** — classify each doc (spec, PRD, ADR, CONTEXT, dev logs,
  memory-bank-like) as source-of-truth/stale/historical. Staleness test:
  sample concrete claims (modules, APIs, flows) against code.
- **Environment** — workflow skills *with actual namespaces*; bootloaders
  (AGENTS.md/CLAUDE.md/GEMINI.md): which exist, mirrored, drifted.
- **History** — `git log` for milestone-level events.
- **Tracker** — candidates in order: existing `tracker.md`; live GitHub
  issues; Linear/JIRA traces (configs, issue-ref formats, `docs/agents/`
  descriptions); existing `docs/work-ledger/`. Also detect the access path
  (MCP tools, `gh` CLI, none).
- **Orchestrator** — dispatch systems (e.g. a Symphony `WORKFLOW.md`, CI
  dispatch jobs). Register in Coexisting Systems; never edit their config.

### 2. Absorb

Classify coexisting systems; never rewrite a foreign system's content:

| Class | Example | Disposition |
|---|---|---|
| Orthogonal | workflow/process skills, orchestrator config | compose into index.md; consistency-check against tracker.md |
| Overlapping | old state notes in CLAUDE.md, memory-bank files | truth moves to harness; foreign file gets a one-line pointer — ask before editing any foreign file |
| Conflicting | rival state system in active use | list differences; user decides which survives |

### 3. Propose

Present: detection summary, topology verdict (core unless extended
thresholds met), absorption dispositions, and **tracker adjudication**:

- exactly one candidate → propose adopting it;
- none → ask the user (local / GitHub / Linear / JIRA / custom), with a
  recommendation;
- multiple → list differences; user decides.

**Wait for approval before writing.**

### 4. Write

Generate from [core-templates.md](core-templates.md) and the chosen preset
in [tracker-adapters.md](tracker-adapters.md) (plus
[extended-templates.md](extended-templates.md) if approved). Every file gets
the generated header. Local mode writes all four ledger files; remote modes
write the two archives only. Backfill `completed.md` from git milestones —
and from the tracker's Done/Canceled items in remote modes.

### 5. Bootloaders

The harness block lives in exactly **one** file — default `AGENTS.md`; if only
others exist, ask which hosts it; if none, ask which to create. Every other
bootloader gets the one-line pointer. Mirror drift: warn in the report, do
not fix.

### 6. Validate

All hard gates must pass before reporting done:

- [ ] every path referenced in block and index exists
- [ ] exactly one harness block in the repo
- [ ] routing skill names resolve in this environment, or are generic fallbacks
- [ ] harness docs committed (harness paths only — never sweep unrelated dirty files)
- [ ] tracker-leak: in instruction files (bootloader, `index.md`, split
      routing files), the concrete tracker is named only as the
      `tracker.md` pointer; work-item IDs inside archive entries are data — exempt
- [ ] `tracker.md` has all eight contract sections filled, no `{...}` braces left
- [ ] dispatch eligibility reads as one machine-checkable rule
- [ ] `completed.md` and `abandoned.md` exist regardless of mode

Report: created, refreshed, left for later, warnings.

## Swap Mode

Triggered when the user asks to switch trackers. Steps:

1. Run tracker detection for the target; present the migration plan
   (entries to move, ledger files to promote/demote). **Wait for approval.**
2. Generate the new `tracker.md` from its preset.
3. Migrate live entries old-truth → new-truth (e.g., `active.md` entries →
   issues, each annotated with its new ID; reverse direction symmetric).
   Never invent placeholder IDs; an unmigratable entry keeps the local
   format with the blocker noted in `next:`.
4. Promote/demote ledger files on mode change: remote→local regenerates
   `active.md`/`follow-ups.md` from open tracker items; local→remote
   converts them to one-line pointers once migration completes.
5. Validate (all setup gates). **Success criterion: no file outside
   `tracker.md` and the migrating ledger files changed.** Swap is not done
   while the unmigrated list is non-empty — report it.

## Refresh Mode

1. **Drift scan** — module-map vs tree; active items vs git log (finished
   but still listed?); `Last verified` overdue (>90 days); bootloader pointer
   liveness; **archive backfill gap** (tracker Done/Canceled items missing
   from `completed.md`/`abandoned.md`); **orchestrator consistency**
   (state/label names in detected orchestrator config match `tracker.md` —
   mismatch: warn only); **tracker-leak scan**.
2. **Present drift summary. Wait for approval.**
3. **Execute** — patch only inside markers; batch-backfill archives;
   archive roll-off per conventions; topology upgrade check.

If the tracker is unreachable (API down, no credentials): skip
tracker-dependent checks, note the gap in the report — never block on
remote availability.

**v2 migration**: markers exist but no `tracker.md`. Extract tracker facts
from `index.md` § Conventions into a generated `tracker.md` (matching
preset, else custom); replace the bootloader block with the v3 template;
regenerate `index.md` inside markers (tracker-agnostic wording); demote live
ledger files if the mode is remote; ensure `abandoned.md` exists. Anything
not clearly generated is user-authored — ask before touching.

**v1 migration**: same flow as v2 migration, preceded by v1→v2 steps: move
routing to its single residence per the approved topology, empty files
become one-line pointers or are deleted, slim the bootloader to the core
template, add markers, re-detect skill names, backfill history.

## Topology

Two legal forms. Day-to-day agents append inside existing files; only this
skill changes topology.

- **Core** (every repo starts here): bootloader block + `docs/harness/index.md`
  + `docs/harness/tracker.md` + ledger files per mode.
- **Extended** — upgrade only when: `index.md` >~150 lines, or modules >10,
  or ≥2 runtime boundaries, or real material exists for an optional track.
  A split **moves** the section, leaving a one-line pointer — never copy.

## Edge Rules

| Case | Rule |
|---|---|
| Greenfield repo | core; ledger structurally complete but empty; `project-started` entry; no backfill |
| No git/shallow clone | skip backfill; mine existing docs for history; note gap in report |
| User content in generated files without markers | user-authored; ask before touching |
| Monorepo | one root harness; module-map sectioned by package; per-package harnesses out of scope |
| Dirty git state | commit harness paths only |
| Tracker unreachable | skip tracker-dependent checks; note gap; never block |
| No preset for chosen tracker | generate from the custom skeleton with the user; gates apply unchanged |
| Orchestrator config conflicts with `tracker.md` | warn only; never edit foreign config |
| Swap with unmigrated entries | keep old format, list in report; swap incomplete until the list is empty |
````

- [ ] **Step 2: Verify mode and gate coverage**

Run:
```bash
cd skills/setup-codex-development-harness
grep -c '^## Swap Mode\|^## Setup Mode\|^## Refresh Mode' SKILL.md   # expect 3
grep -c 'tracker-leak' SKILL.md                                       # expect >=2
grep -c 'tracker-adapters.md' SKILL.md                                # expect >=1
grep -c 'Tracker identity lives in exactly one file' SKILL.md         # expect 1
```

- [ ] **Step 3: Commit**

```bash
git add skills/setup-codex-development-harness/SKILL.md
git commit -m "feat(harness-skill): rewrite SKILL.md to v3 tracker-adapter process"
```

---

### Task 5: Cross-file consistency check

**Files:** none modified (verification only; fix inline if a check fails, amend the relevant commit message style `fix(harness-skill): ...`).

- [ ] **Step 1: Referenced plugin files exist**

```bash
cd skills/setup-codex-development-harness
for f in core-templates.md extended-templates.md ledger-conventions.md tracker-adapters.md; do test -f $f && echo "ok $f"; done
```
Expected: four `ok` lines.

- [ ] **Step 2: Section-name agreement between SKILL.md gates and the adapter contract**

The gate says "eight contract sections". Verify the contract list in
`tracker-adapters.md` § The Contract has exactly eight numbered items and the
names match the preset headings:

```bash
grep -A 20 '^## The Contract' tracker-adapters.md | grep -c '^[0-9]\.'
```
Expected: `8`.

- [ ] **Step 3: v2 vocabulary purge**

```bash
grep -in '{variant}\|no-tracker variant\|tracker variant' SKILL.md core-templates.md ledger-conventions.md
```
Expected: no matches (the variant mechanism is fully replaced).

- [ ] **Step 4: Commit any fixes**

Only if Steps 1–3 forced edits:
```bash
git add skills/setup-codex-development-harness
git commit -m "fix(harness-skill): cross-file consistency fixes (v3)"
```

---

### Task 6: Subagent fixture tests

**Files:** fixtures under `/tmp/harness-v3-fixtures/` (throwaway; never committed).

Method per spec §Testing (cf. commit 846f9a7): clean-room subagents run the
skill text against fixture repos; we check the gates afterward. Dispatch each
scenario as a fresh subagent whose prompt is: *"You are testing a skill. Read
`/Users/danny/codex-local-marketplace/plugins/engineering/skills/setup-codex-development-harness/SKILL.md`
and execute it in <fixture path> for scenario <X>. Auto-approve your own
proposals (test mode). Report what you generated and any ambiguity or
loophole you had to guess through."* Treat every guess the subagent reports
as a loophole to fix in Task 7.

- [ ] **Step 1: Build fixtures**

```bash
mkdir -p /tmp/harness-v3-fixtures && cd /tmp/harness-v3-fixtures
# (a) greenfield
mkdir greenfield && cd greenfield && git init -q && echo "# app" > README.md && git add -A && git commit -qm init && cd ..
# (b) repo with GitHub-issue traces (offline stand-in: issue refs + gh config)
mkdir gh-repo && cd gh-repo && git init -q && mkdir -p src .github
echo "fix per #12" > src/notes.txt && echo "# app" > README.md
git add -A && git commit -qm "feat: initial (#12)" && cd ..
# (c) v2 harness repo (migration path) — copy v2 templates' generated shape
mkdir v2-repo && cd v2-repo && git init -q && mkdir -p docs/harness docs/work-ledger
printf '<!-- codex-harness: generated 2026-01-01 -->\n# Development Harness Index\n\nLast verified: 2026-01-01\n\n## Conventions\n\n- Tracker: none — the ledger is full truth\n' > docs/harness/index.md
printf '<!-- codex-harness: generated 2026-01-01 -->\n# Active Work\n\n## sample-task\n- status: planned\n- source: README\n- next: do it\n- updated: 2026-01-01\n' > docs/work-ledger/active.md
printf '<!-- codex-harness: generated 2026-01-01 -->\n# Completed Work\n' > docs/work-ledger/completed.md
printf '<!-- codex-harness: generated 2026-01-01 -->\n# Follow-ups\n' > docs/work-ledger/follow-ups.md
printf '<!-- codex-harness: generated 2026-01-01 -->\n# Abandoned Work\n' > docs/work-ledger/abandoned.md
printf '<!-- codex-harness:begin -->\n## Development Harness\n\nBefore any development task, read `docs/harness/index.md`.\n<!-- codex-harness:end -->\n' > AGENTS.md
git add -A && git commit -qm "v2 harness" && cd ..
```

- [ ] **Step 2: Scenario (a) greenfield — dispatch subagent, then check**

After the subagent reports, verify in `/tmp/harness-v3-fixtures/greenfield`:
```bash
cd /tmp/harness-v3-fixtures/greenfield
test -f docs/harness/tracker.md && echo ok-tracker
grep -c '^## ' docs/harness/tracker.md          # expect 8
grep -c '{' docs/harness/tracker.md             # expect 0
test -f docs/work-ledger/completed.md && test -f docs/work-ledger/abandoned.md && echo ok-archives
grep -i 'linear\|jira' docs/harness/index.md AGENTS.md && echo LEAK || echo ok-no-leak
```
Greenfield has no tracker traces → the subagent must have *asked* (or in
test mode, defaulted to local and said so). If it silently picked a remote
tracker: loophole.

- [ ] **Step 3: Scenario (b) gh-repo — dispatch subagent, then check**

Expect: tracker detection proposes `github` (issue refs present). Verify
`tracker.md` Identity says `kind: github` and Read/Write names a real
detected path or "none detected". Same gate checks as Step 2.

- [ ] **Step 4: Scenario (c) v2-repo — dispatch subagent, then check**

Expect v2 migration: `tracker.md` created (`kind: local`), bootloader
replaced with v3 block (bright line present), `sample-task` entry preserved
untouched in `active.md`.
```bash
cd /tmp/harness-v3-fixtures/v2-repo
grep -c 'Bright line' AGENTS.md                 # expect 1
grep -c 'sample-task' docs/work-ledger/active.md # expect 1
test -f docs/harness/tracker.md && echo ok
```

- [ ] **Step 5: Scenario (d) swap round-trip — dispatch subagent on greenfield result**

Seed a live entry first so the swap has something to migrate:
```bash
cd /tmp/harness-v3-fixtures/greenfield
cat >> docs/work-ledger/active.md <<'EOF'

## seeded-task
- status: planned
- source: test fixture
- next: implement the thing
- updated: 2026-06-11
EOF
git add -A && git commit -qm "seed active entry"
```

Ask a fresh subagent to run swap mode local→github, then github→local, in
the greenfield fixture. Verify after each leg:
```bash
cd /tmp/harness-v3-fixtures/greenfield
git status --porcelain   # after each swap: only tracker.md + ledger files listed
grep -c 'seeded-task' docs/work-ledger/active.md
# expect: leg 1 (→github) 0 or pointer-annotated; leg 2 (→local) 1 — the entry survives the round-trip
```
Any diff in `index.md` or `AGENTS.md` during a swap: loophole (violates the
swap success criterion).

- [ ] **Step 6: Record loopholes**

Write every guess/ambiguity the subagents reported into a scratch list for
Task 7. No commit (fixtures are throwaway).

---

### Task 7: Close loopholes and finalize

**Files:**
- Modify: whichever skill files the Task 6 loopholes point at.

- [ ] **Step 1: Patch each loophole** — tighten the exact wording the
  subagent guessed through (same method as commit 846f9a7). No new
  mechanisms; wording fixes only. If a loophole requires a design change,
  stop and surface it to the user instead.

- [ ] **Step 2: Re-run the failing scenario** from Task 6 to confirm the
  patch closes it.

- [ ] **Step 3: Re-run all Task 5 consistency checks** (they must still pass
  after patches).

- [ ] **Step 4: Commit**

```bash
git add skills/setup-codex-development-harness
git commit -m "fix(harness-skill): close loopholes found in v3 subagent testing"
```

- [ ] **Step 5: Cleanup**

```bash
rm -rf /tmp/harness-v3-fixtures
```
