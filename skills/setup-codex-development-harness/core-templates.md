# Core Templates

Everything the **core** topology generates: bootloader block, pointer line,
`docs/harness/index.md`, `docs/harness/tracker.md` (from a
[tracker-adapters.md](tracker-adapters.md) preset), `docs/harness/roadmap.md`,
`docs/harness/quality-gates.md`, and the work-ledger files. `{...}` braces
= fill at generation time. Entry formats come from
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
   and updating durable repo docs when facts changed. A change without its
   tracker update is incomplete work.
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
All ten contract sections filled; no braces left.

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
2. Read `docs/harness/roadmap.md` § Current Node — know where this work
   sits in the long-horizon sequence.
3. Read `docs/harness/quality-gates.md`.
4. Identify your task type in the routing table.
5. Read the listed context; use the listed workflow.
6. Before closing: post completion evidence and the state update per
   `tracker.md`; update durable repo docs when facts changed.

## Task Routing

| Task type | Read first | Workflow | Completion update |
|---|---|---|---|
| New feature | Domain Docs; `roadmap.md` § Current Node; {repo-specific docs/dirs} | {detected design+planning skills, else "design before code"} | tracker update per `tracker.md`; durable docs if facts changed |
| Plan intake (approved spec/plan → work items) | Work Production; Artifact Adapters; the approved spec/plan | {detected issueization skill, else split per `tracker.md` § Work Item Format} | work items created, dependencies encoded, each linking the source plan |
| Bug / regression | `quality-gates.md`; {repo-specific docs/tests} | {detected debugging skill, else "reproduce before fixing"} | regression test; tracker update per `tracker.md` |
| Unfamiliar area | {architecture docs if extended, else key source dirs} | {detected exploration skill, else targeted reading} | index/map update if stable knowledge gained |
| Architecture decision | Domain Docs | {detected decision skill, else "write an ADR"} | the decision doc; tracker update per `tracker.md` |
| Completion check | `docs/harness/quality-gates.md` | {detected verification skill, else "run required checks"} | completion evidence per `tracker.md` |

Rows are a starting set — keep only the ones meaningful for this repo, add
repo-specific ones found during exploration.

## Work Production

How new work enters the tracker. User-in-the-loop by design — orchestrated
agents consume the output of this pipeline; they never run it. Workflow
skills provide methodology; this harness decides what artifact is written
and where it goes.

1. Position: read `roadmap.md` — which node is current, is it specced?
2. Design: {detected grilling/design skill, else "stress-test the plan with
   the user"} — resolved terms land in the glossary, hard decisions in ADRs.
3. PRD: {detected PRD skill, else "write a PRD; user approves"}.
4. Issueize: {detected issueization skill, else split per `tracker.md`
   § Work Item Format} — current-node items carry the roadmap node `parent:`,
   dependencies encoded; items become
   dispatch-eligible per `tracker.md` § Dispatch Eligibility.
5. Triage: {detected triage skill, else classify readiness manually} —
   apply the category/state roles mapped in `tracker.md` § Labels.
6. Node close: when the current node's items are all terminal, propose the
   roadmap advance to the user (see `roadmap.md` header rule).

## Artifact Adapters

The harness owns these outputs; workflow skills only help produce them.

- PRD/spec artifacts: {tracker issue | repo doc path | external doc path}
- Issueization outputs: {tracker issues | local ledger entries | automation graph | task item}
- Approval points: {where user approval is required before publishing or dispatch}
- Dispatch boundary: `docs/harness/tracker.md` § Dispatch Eligibility.

## Domain Docs

- Glossary route: {`CONTEXT.md` | `CONTEXT-MAP.md` with per-area `CONTEXT.md` files | none yet}
- ADR route: {`docs/adr/` | per-area ADR dirs | none yet}
- Lazy-create rule: create glossary/ADR files only when there is real material.
- Consumer rule: read glossary routes before naming things; read ADR routes
  before architectural changes; update them when a term or decision
  crystallises.

## Quality Gates

Read `docs/harness/quality-gates.md` before claiming completion. The tracker
completion evidence must name which required checks ran and what happened.

## Coexisting Systems

| System | Class | Truth |
|---|---|---|
| {detected system} | orthogonal-composed \| overlap-resolved \| conflict-user-decided | {where its truth lives} |
| {detected orchestrator, if any} | orthogonal-composed | its own config; state/label names must match `tracker.md` |

## Conventions

- Tracker: `docs/harness/tracker.md` — the only file that names the tracker.
- Roadmap: `docs/harness/roadmap.md` — long-horizon direction; node
  transitions are user decisions (agents propose with evidence, never
  advance alone).
- Workflow skills: configured by this index plus `tracker.md`; no shadow
  per-skill config files.
- Archives: `completed.md` / `abandoned.md` exist in every mode; entries
  written per `tracker.md` § Archive Policy.
- Entry formats: {paste the applicable formats from ledger-conventions as fenced blocks:
  archives always; live entries in local mode only}
- Markers: `codex-harness` comments delimit generated regions. Edit outside
  them freely; refresh never touches user-authored content.
- Quality gates: `docs/harness/quality-gates.md`.
```

## `docs/harness/roadmap.md`

The layer above the tracker: milestone sequence and current position.
Backlog items live in the tracker; direction lives here. Written at node
boundaries only — exactly when the user is in the loop — so write-cost
stays human-supervised.

```markdown
<!-- codex-harness: generated {DATE} -->
# Roadmap

Last verified: {DATE}

Long-horizon direction. Work items live in the tracker
(`docs/harness/tracker.md`); this file holds the milestone sequence and the
current position. In local mode, current-node slices are found by matching
work-ledger entries with `parent: <milestone-id>`. Node transitions are user
decisions made in interactive sessions: an agent may propose advancing — with
evidence that the current node's items are all terminal — but never advances a
node alone.

## Current Node

{milestone-id} — {one-line goal}

## Milestones

### {milestone-id}: {name}
- status: done | current | next | later
- goal: {one line}
- spec: {PRD / spec / ADR refs, or "not yet specced"}
- items: {how this node's work items are found in the tracker — label,
  milestone, project ref, or local `parent: <milestone-id>` — or "not yet
  issueized"}

{one section per milestone, in sequence order; greenfield repos get a
single current milestone capturing the project's first goal}

## Direction Notes

{cross-node intent, constraints, deliberately-not-doing — or nothing}
```

## `docs/harness/quality-gates.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Quality Gates

Last verified: {DATE}

Required before completion evidence is posted.

## Checks

| Gate | Command / evidence | Required when |
|---|---|---|
| Formatting | {command or "none detected"} | {always / touched files} |
| Lint | {command or "none detected"} | {always / touched files} |
| Typecheck | {command or "none detected"} | {typed code changed / always / none} |
| Tests | {command or "none detected"} | {code changed / touched area} |
| Build / smoke | {command or "none detected"} | {user-facing or integration change} |

## Evidence Format

Completion evidence must include:

- commands run and outcomes;
- checks intentionally skipped, with the reason;
- remaining risk or "none";
- follow-up refs or "none".

## Failure Rule

If a required gate fails, do not claim completion. Follow
`docs/harness/tracker.md` § Failure Handling.
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
- done: {date of first commit; today only if the repo has no commits}
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
