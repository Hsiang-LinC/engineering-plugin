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

## Project Profile

{observed actors/goals, state transitions, data invariants, external effects
and operational risks; applicable design examples and verification routes only}

## Start Sequence

1. Read `docs/harness/tracker.md`; read your work item per its Read/Write
   section.
2. Read `{approved roadmap path}` § Current Node — know where this work
   sits in the long-horizon sequence.
3. Read `docs/harness/quality-gates.md`.
4. Identify the execution owner from the work item and, when supplied, its
   runtime assignment. An installed runtime alone does not own this item.
5. Follow Work Production's shared phase contract. Interactive work resumes
   the recorded phase and selects the routed skill. Runtime-assigned work
   performs only the assigned role using its context, methodology and output
   schema; do not independently select another phase or start another pipeline.
6. Missing decisions return to clarification through the execution owner:
   ask the user interactively, or report through runtime escalation.
7. Return evidence to the execution owner. Interactive agents update the
   tracker within their authority; runtime workers return role artifacts and
   leave lifecycle writes/publication to the runtime. Update durable docs only
   within the assigned scope.

## Task Routing

| Task type | Read first | Workflow | Completion update |
|---|---|---|---|
| New feature | Domain Docs; `{approved roadmap path}` § Current Node; {repo-specific docs/dirs} | {detected design+planning skills, else "design before code"} | tracker update per `tracker.md`; durable docs if facts changed |
| Plan intake (approved spec/plan → work items) | Work Production; Artifact Adapters; the approved spec/plan | {detected issueization skill, else split per `tracker.md` § Work Item Format} | work items created, dependencies encoded, each linking the source plan |
| Bug / regression | `quality-gates.md`; {repo-specific docs/tests} | {detected debugging skill, else "reproduce before fixing"} | regression test; tracker update per `tracker.md` |
| Unfamiliar area | {architecture docs if extended, else key source dirs} | {detected exploration skill, else targeted reading} | index/map update if stable knowledge gained |
| Architecture decision | Domain Docs | {detected decision skill, else "write an ADR"} | the decision doc; tracker update per `tracker.md` |
| Completion check | `docs/harness/quality-gates.md` | {detected verification skill, else "run required checks"} | completion evidence per `tracker.md` |

Rows are a starting set — keep only the ones meaningful for this repo, add
repo-specific ones found during exploration.

## Work Production

One phase contract serves interactive and runtime execution. The execution
owner advances it; skills supply the method, not a second controller.

| Responsibility | Interactive execution | Runtime execution |
|---|---|---|
| Phase and next action | Agent reads the work item | Runtime supplies its authoritative assignment |
| Method | Agent loads the selected skill | Role uses injected/assigned methodology mapped to this contract |
| Gates and acceptance | Agent checks evidence; designated authority accepts | Runtime enforces supported checks and routes the designated acceptance decision |
| State and publication | Authorized agent writes tracker | Runtime writes its ledger and projects tracker updates |
| Uncertainty | Agent asks the decision maker | Worker reports; runtime pauses/escalates affected work |

Runtime states may refine a shared phase into several roles; they need not
match phase names one-to-one. Setup verifies that role methods and gates satisfy
this contract; unsupported mappings are reported, not silently substituted.
Execution ownership changes require an explicit handoff of source revision,
phase, evidence and next action, with the previous owner no longer active.

Select the smallest
applicable path; a clear bug goes directly to diagnosis, regression check and
acceptance, without a PRD. A bounded investigation has its own question, limits
and evidence deliverable; unknowns do not make exploration impossible.

| Phase | Entry / selected workflow | Exit evidence |
|---|---|---|
| Clarify | Unresolved goal, term, scope or behavior → {one installed grilling/design skill, else explicit interview fallback} | Confirmed scope, non-goals, rules/examples, unresolved questions in the selected spec; glossary terms and consequential ADRs linked |
| Specify | Product behavior understood → {one installed PRD skill, else scoped written plan} | Reviewed behavior examples or prototype when useful; approved source revision and remaining assumptions distinguished |
| Slice | Approved scope → {one installed issueization skill, else tracker work-item format} | Verifiable slices, source revision, dependencies, acceptance/verification; triage before readiness |
| Implement | Tracker eligibility holds → {one installed implementation/debugging skill, else reproduce/test/change/check} | Changed artifact revision and criterion-level evidence |
| Accept | Implementation evidence exists → {one installed review/verification skill, else documented review} | Authorized decision per tracker; passing tests alone do not accept work |

Resolve every workflow cell to one actual skill name and read that skill before
acting; no manual invocation from the user is needed. If unavailable, report
that fact and use the recorded fallback. Do not silently invent a replacement
method or invoke every installed skill. The execution owner persists phase,
source and next action in its authoritative state, exposing a reference from
the work item when runtime-owned. Keep decisions/questions in the spec, not
the glossary. A worker must not create a parallel phase ledger.

During clarification, use a small set of rules, concrete examples and open
questions. Walk through the normal path and relevant empty, error, cancel,
retry and permission cases; a sketch or prototype is useful when words leave
interaction ambiguous. Review examples in small groups, not just a long PRD.

Re-enter clarification whenever implementation reveals a material uncertainty.
Record changed decisions and invalidate only affected readiness, approvals and
evidence; unaffected work can continue. Scope, product behavior, public-contract
or authority changes need the designated decision maker. Repeated failure or a
missing capability blocks the smallest affected item with evidence and a
specific question; retries cannot silently relax scope or gates.

Graph production has exactly one owner per item: normal work uses the selected
issueization skill; SMDA-managed work hands the approved spec to SMDA’s
reviewed decomposition/publication path. Skills invoked inside a runtime role
produce only its requested artifact; they do not independently publish issues
or run a second interactive pipeline. An external graph import is permitted
only when the installed adapter explicitly supports reviewed import.

At node closure, check accepted outcomes and explicitly dropped scope, not just
terminal item counts; propose roadmap advancement to the user.

## Artifact Adapters

The harness owns these outputs; workflow skills only help produce them.

- Artifact root: {`docs/features/` or adopted existing root}
- Project packet: {`docs/features/<roadmap-node-slug>/` or adopted pattern}
- Slice packet: {`docs/features/<roadmap-node-slug>/<slice-slug>/` or
  adopted pattern; create only when a slice has real artifacts}
- PRD/spec/plan artifacts: {project packet | slice packet | tracker issue |
  external doc path}
- Issueization outputs: {tracker issues | local ledger entries | automation graph | task item}
- Approval points: {where user approval is required before publishing or dispatch}
- Dispatch boundary: `docs/harness/tracker.md` § Dispatch Eligibility.
- Workflow-skill path overrides: {for example, `superpowers:writing-plans`
  saves plans to the selected packet path instead of its default
  `docs/superpowers/plans/`, or "none"}

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
- Roadmap: `{approved roadmap path}` — long-horizon direction; node
  transitions are user decisions (agents propose with evidence, never
  advance alone).
- Feature packets: project and slice artifacts live under the Artifact
  Adapters paths; do not duplicate tracker state there.
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
- spec: {project packet PRD/spec/plan refs, ADR refs, or "not yet specced"}
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

- work item, source revision and changed artifact revision;
- acceptance criteria mapped to observed results (including behavior examples);
- commands run and outcomes;
- checks intentionally skipped, with the reason;
- remaining risk or "none";
- follow-up refs or "none".

Repository quality gates are the shared definition of done; each item’s
acceptance criteria define its behavior. Acceptance authority is a separate
tracker decision. Evidence from an older revision must be rechecked for impact.

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
