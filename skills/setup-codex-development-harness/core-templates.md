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
2. Identify your task type in the routing table.
3. Read the listed context; use the listed workflow.
4. Before closing: post completion evidence and the state update per
   `tracker.md`; update durable repo docs when facts changed.

## Task Routing

| Task type | Read first | Workflow | Completion update |
|---|---|---|---|
| New feature | {repo-specific docs/dirs} | {detected design+planning skills, else "design before code"} | tracker update per `tracker.md`; durable docs if facts changed |
| Plan intake (approved spec/plan → work items) | the approved spec/plan | {detected issueization skill, else split per `tracker.md` § Work Item Format} | work items created, dependencies encoded, each linking the source plan |
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
- Entry formats: {paste the applicable formats from ledger-conventions as fenced blocks:
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
