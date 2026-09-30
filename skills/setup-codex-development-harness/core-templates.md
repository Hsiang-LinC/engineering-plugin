# Core Templates

Everything the **core** topology generates: bootloader block, pointer line,
`docs/harness/index.md`, `docs/harness/tracker.md` (from a
[tracker-adapters.md](tracker-adapters.md) preset), optional `docs/harness/roadmap.md`,
`docs/harness/quality-gates.md`, and the work-ledger files. `{...}` braces
= fill at generation time. Entry formats come from
[ledger-conventions.md](ledger-conventions.md).

Ledger files by mode: **local** generates all four; **remote trackers** use
native terminal history. Preserve existing remote archives when present.

## Bootloader block (single residence, ~15 lines max)

```markdown
<!-- codex-harness:begin -->
## Development Harness

Before any development task, read `docs/harness/index.md` and follow its routing.

Hard rules:
1. Read `docs/harness/tracker.md` for work-state ownership and write authority.
2. Bright line: any work that changes code, contracts, or docs is
   tracker-worthy — before the first edit, confirm a work item covers it or
   create one per `tracker.md` in interactive work. Runtime workers use the
   assigned item and report missing coverage to the execution owner. Pure
   reading, discussion, or Q&A is not tracker-worthy.
3. Completion requires evidence and durable doc updates when facts change.
   The execution owner applies tracker updates per `tracker.md`; runtime
   workers return artifacts without independently changing lifecycle state.
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

Single residence of routing facts for this repo. Bootloaders point here;
never copy these tables elsewhere. Tracker identity lives only in
`docs/harness/tracker.md`.

## Project Profile

{observed actors/goals, state transitions, data invariants, external effects
and operational risks; applicable design examples and verification routes only}

## Start Sequence

1. Read `docs/harness/tracker.md`; read your work item per its Read/Write
   section.
2. If a roadmap exists, read its Current Node.
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
| New feature | Domain Docs; roadmap Current Node if present; {repo-specific docs/dirs} | {detected design+planning skills, else "design before code"} | tracker update per `tracker.md`; durable docs if facts changed |
| Plan intake (approved spec/plan → work items) | Work Production; Artifact Adapters; the approved spec/plan | {detected issueization skill, else split per `tracker.md` § Work Item Format} | work items created, dependencies encoded, each linking the source plan |
| Bug / regression | `quality-gates.md`; {repo-specific docs/tests} | {detected debugging skill, else "reproduce before fixing"} | regression test; tracker update per `tracker.md` |
| Unfamiliar area | {architecture docs if extended, else key source dirs} | {detected exploration skill, else targeted reading} | index/map update if stable knowledge gained |
| Architecture decision | Domain Docs | {detected decision skill, else "write an ADR"} | the decision doc; tracker update per `tracker.md` |
| Completion check | `docs/harness/quality-gates.md`; Delivery & Recovery when applicable | {detected verification skill, else "run required checks"} | acceptance and applicable delivery evidence per `tracker.md` |

Rows are a starting set — keep only the ones meaningful for this repo, add
repo-specific ones found during exploration.

For new features that add or change a subsystem, persisted state, external
dependency, state owner, or cross-component interface, route to the selected
design skill before implementation. Trace one user path through the existing
code and docs: origin, changes, storage, readers, failure/retry, and external
effects. Record existing boundaries, proposed changes, and blocking unknowns
in the selected spec; place confirmed contracts through Domain Docs. Ask the
product owner about behavior trade-offs; the agent resolves local technical
choices. No boundary change means no extra document or phase.

## Interactive Work Item Lifecycle

An independently accepted tracker item needs an identifiable candidate.
Account for its review state and local changes before switching items. Merge
and discard remain separate authority decisions under `tracker.md`.
A candidate is bounded by its item's approved scope and acceptance criteria.
Discovering another item permits read-only investigation; it does not
authorize claiming or modifying that item's scope. Record a real dependency
on the current item or notify the existing item's owner. Create a follow-up
only when no tracker item already owns the discovered work.

In Git repositories, plan tasks within one item may share a branch; default
to a separate branch for another item unless an explicit repo integration
policy says otherwise. Before creating it, identify the repo's integration
target and compare the new item's scope with unmerged work on the current
branch. An independent item starts from the verified integration target,
not the current feature tip. Use another item's candidate as the base only
for a real recorded dependency; record that item, exact base revision and
integration order. If the target or dependency is uncertain, clarify it
before choosing a base. A stacked Git base never waives tracker dependencies.
Before switching to that branch, confirm the other item is dispatch-eligible
and unowned, then claim it through `tracker.md` and record its base, candidate
branch and checkout; otherwise report it to its execution owner and stop at
the smallest affected boundary. If the current item requires the discovered
item, preserve its candidate, encode the dependency and block only affected
work. After the dependency is accepted, recheck the base, candidate identity
and required verification before resuming.
Reuse an available worktree after accounting for its prior work; create
another when simultaneous work or an active candidate needs a separate
checkout. Keep in-use checkouts and those needed for active review or PR
feedback. After landing, explicit abandonment or a safe blocked-work handoff,
preserve commits and useful local files, then archive/remove an unused
worktree through the platform that owns it. Delete a branch only after its
work is integrated or explicitly discarded; do not force-remove a worktree
for routine cleanup. After integration, run the required checks on the landed
target before cleanup. Omit these Git mechanics when the project has no Git repo.

## Delivery & Recovery

Source acceptance, integration, release/deployment and local installation are
distinct outcomes. Apply only the stages this repo uses. A source item may
close after acceptance when later delivery has a separate linked work item;
when delivery belongs to the same item's acceptance, keep it open until its
applicable post-delivery checks pass. Do not infer routine release or merge
authority from a workflow file. An unresolved authority or required check is a
question for the decision maker, with a suggested default grounded in evidence.

| Stage / trigger | Executable source | Authority / owner | Success evidence | Failure handoff / cleanup |
|---|---|---|---|---|
| {observed Git integration, or omit} | {existing repo instructions / platform} | {who may integrate} | {target, candidate and landed revision; required checks} | {blocked owner and retry condition; checkout/branch rule} |
| {observed CI or publish/release, or omit} | {workflow/config/runbook} | {who may trigger and approve} | {run ID, result, artifact/tag/target revision} | {logs, recovery owner, safe retry/rollback rule} |
| {observed deploy or local install/update, or omit} | {existing install/runbook source} | {who may perform it} | {environment, version/hash and smoke result} | {partial-success state, recovery owner and next action} |

Never copy executable steps from their native source into this table. If no
delivery stage exists, say so in one line rather than keeping placeholder rows.
After a partial success, preserve completed stage identities and check whether
retrying an external action is safe before rerunning it. The execution owner
records proof and handoff in `tracker.md`; runtime-owned work follows its
runtime's authoritative lifecycle.

## Work Production

One phase contract serves interactive and runtime execution. The execution
owner advances it; skills supply the method, not a second controller.
This harness is the common software-development contract. Interactive Goal
mode carries a work item end to end; SMDA schedules and decomposes roles that
consume the same contract while its runtime workflow refines the shared phases
and owns runtime execution state. It does not create a competing project phase
contract or parallel tracker lifecycle.

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
| Implement | Tracker eligibility holds; agent checks that the plan covers approved acceptance, affected boundaries and verification before using {one installed implementation/debugging skill, else reproduce/test/change/check} | Changed artifact revision and criterion-level evidence |
| Accept | Implementation evidence exists → {one installed review/verification skill, else documented review} | Authorized decision on the source candidate per tracker; passing tests alone do not accept work |
| Deliver (when in scope) | Source accepted; use Delivery & Recovery under its separate authority | Applicable integration, release or installation result and post-delivery checks, or a linked open delivery item |

After Accept, follow Delivery & Recovery for stages within scope. Keep the item
active with `phase: deliver` while this item owns unfinished delivery; the
reviewer's source acceptance remains recorded. A separate delivery item may
own later integration, release or installation; link it so the accepted source
is not described as already delivered.

Fix plan gaps before implementation. Return new product decisions or scope changes
to the designated decision maker; a bounded plan within approved scope needs
no separate human plan approval.

If the project requires human acceptance of a user-facing product slice,
the independent reviewer records a technical pass; keep the slice item pending;
provide a usable candidate, the key user scenarios, and known limitations.
Record the human's explicit product decision against that candidate. Feedback
returns the affected slice to implementation and a changed candidate receives
fresh technical review. A technical pass alone does not mark the product slice
accepted. This gate is selected during setup and recorded in `tracker.md`;
do not add it to projects without user-facing slices.

For interactive agent-owned work, the implementer records the candidate
commit SHA and verification evidence, moves the item to review, and dispatches
an independent reviewer agent. Review failure returns to implementation with
findings; a changed candidate requires fresh review. If a commit is unavailable,
freeze a patch with base SHA, complete included file list (including untracked
files), and artifact hash. Recheck that identity before acceptance. The
independent reviewer records acceptance under the tracker policy; unresolved decisions or repeated
failure escalate as specified there. A runtime-assigned worker does not run
this interactive review loop: the runtime owns reviewer dispatch, phase changes
and tracker publication. If reviewer delegation is unavailable, preserve the
review state and handoff evidence for the next owner.

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

When a roadmap node closes, check accepted outcomes and explicitly dropped
scope; propose advancement to the user.

## Artifact Adapters

The harness owns these outputs; workflow skills only help produce them.

- Artifact root: {`docs/features/` or adopted existing root}
- Project packet: {`docs/features/<project-or-roadmap-slug>/` or adopted pattern}
- Slice packet: {`docs/features/<project-or-roadmap-slug>/<slice-slug>/` or
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

Read `docs/harness/quality-gates.md` before claiming acceptance or applicable
delivery completion. The tracker evidence must name which stage checks ran and
what happened.

## Coexisting Systems

| System | Class | Truth |
|---|---|---|
| {detected system} | orthogonal-composed \| overlap-resolved \| conflict-user-decided | {where its truth lives} |
| {detected orchestrator, if any} | orthogonal-composed | its own config; state/label names must match `tracker.md` |

## Conventions

- Tracker: `docs/harness/tracker.md` — the only file that names the tracker.
- Roadmap, if present: `{approved roadmap path}` — long-horizon direction; node
  transitions are user decisions (agents propose with evidence, never
  advance alone).
- Feature packets: project and slice artifacts live under the Artifact
  Adapters paths; do not duplicate tracker state there.
- Workflow skills: configured by this index plus `tracker.md`; no shadow
  per-skill config files.
- Archives: local mode uses `completed.md` / `abandoned.md`; remote mode uses
  native terminal history and preserves existing archives.
- Entry formats: {paste the applicable formats from ledger-conventions as fenced blocks:
  local ledger entries; retained remote archives only when present}
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

{one section per real milestone, in sequence order}

## Direction Notes

{cross-node intent, constraints, deliberately-not-doing — or nothing}
```

## `docs/harness/quality-gates.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Quality Gates

Run applicable checks at their stated stage. Source acceptance, landed-target
verification, release and installation can require different evidence.

## Checks

| Gate | Command / evidence | Required when |
|---|---|---|
| Formatting | {command or "none detected"} | {always / touched files} |
| Lint | {command or "none detected"} | {always / touched files} |
| Typecheck | {command or "none detected"} | {typed code changed / always / none} |
| Tests | {command or "none detected"} | {code changed / touched area} |
| Build / smoke | {command or "none detected"} | {user-facing or integration change} |
| Landed target | {command/evidence or "none detected"} | {after integration, before checkout cleanup} |
| Release / install | {command/evidence or "not applicable"} | {when release, deployment or local installation is in scope} |

## Evidence Format

Completion evidence must include:

- work item, source revision and changed artifact revision;
- acceptance criteria mapped to observed results (including behavior examples);
- commands run and outcomes;
- checks intentionally skipped, with the reason;
- remaining risk or "none";
- follow-up refs or "none".
- when delivery is in scope: stage, source/candidate/landed identity as
  applicable, CI run or release/install identity, outcome, and recovery owner
  for any incomplete stage; link a separate delivery item when used.

Repository quality gates are the shared definition of done; each item’s
acceptance criteria define its behavior. Acceptance authority is a separate
tracker decision. Evidence from an older revision must be rechecked for impact.

## Failure Rule

If a required gate fails, do not claim that stage completed. Follow
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

## `docs/work-ledger/completed.md` (local mode or retained remote archive)

```markdown
<!-- codex-harness: generated {DATE} -->
# Completed Work

Archive — newest first. Entry format: see `docs/harness/index.md` § Conventions.

{backfilled milestone entries from git history in local mode — newest first}

## project-started
- done: {date of first commit; today only if the repo has no commits}
- summary: project started
- verified: {backfilled from git history | greenfield init}
- follow-ups: none
```

## `docs/work-ledger/abandoned.md` (local mode or retained remote archive)

```markdown
<!-- codex-harness: generated {DATE} -->
# Abandoned Work

Archive — paths tried and dropped, each with a resume condition. Entry
format: see `docs/harness/index.md` § Conventions.

{entries found during local exploration, or nothing}
```
