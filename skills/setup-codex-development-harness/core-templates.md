# Core Templates

Everything the **core** topology generates: bootloader block, pointer line,
`docs/harness/index.md`, and the four ledger files. `{...}` braces = fill at
generation time. Entry formats come from [ledger-conventions.md](ledger-conventions.md).

## Bootloader block (single residence, ~15 lines max)

```markdown
<!-- codex-harness:begin -->
## Development Harness

Before any development task, read `docs/harness/index.md` and follow its routing.

Hard rules:
1. Project state lives in `docs/work-ledger/` — read `active.md` before starting work.
2. Definition of done includes updating the relevant work-ledger file(s).
   Code change without ledger update = incomplete work.
3. Routing tables live only in `docs/harness/index.md`. Do not duplicate them here.
<!-- codex-harness:end -->
```

## Pointer line (every other detected bootloader)

```markdown
<!-- codex-harness:begin -->
Development harness: see `AGENTS.md` § Development Harness. State in `docs/work-ledger/`.
<!-- codex-harness:end -->
```

(Replace `AGENTS.md` with the actual residence file if the user chose another.)

## `docs/harness/index.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Development Harness Index

Last verified: {DATE}

Single residence of routing facts for this repo. Bootloaders point here; never
copy these tables elsewhere.

## Start Sequence

1. Read `docs/work-ledger/active.md`.
2. Identify your task type in the routing table.
3. Read the listed context; use the listed workflow.
4. Before closing: update the matching work-ledger file(s). Code change
   without ledger update = incomplete work.

## Task Routing

| Task type | Read first | Workflow | Completion update |
|---|---|---|---|
| New feature | {repo-specific docs/dirs} | {detected design+planning skills, else "design before code"} | active.md entry; move to completed.md when verified |
| Bug / regression | {repo-specific docs/tests} | {detected debugging skill, else "reproduce before fixing"} | completed.md; follow-ups.md if debt found |
| Unfamiliar area | {architecture docs if extended, else key source dirs} | {detected exploration skill, else targeted reading} | index.md, if stable knowledge was gained |
| Architecture decision | {CONTEXT.md / docs/adr/ if present} | {detected decision skill, else "write an ADR"} | the decision doc + completed.md |
| Completion check | Conventions § quality gates | {detected verification skill, else "run full test suite"} | completed.md with verified: evidence |

Rows are a starting set — keep only the ones meaningful for this repo, add
repo-specific ones found during exploration.

## Coexisting Systems

| System | Class | Truth |
|---|---|---|
| {detected system} | orthogonal-composed \| overlap-resolved \| conflict-user-decided | {where its truth lives} |

## Conventions

- Tracker: {“<tracker> — active/follow-ups entries are ID+summary refs; status
  lives in the tracker” | “none — the ledger is full truth”}
- Entry formats: {paste the applicable entry-format rules from ledger-conventions}
- Markers: `codex-harness` comments delimit generated regions. Edit outside
  them freely; refresh never touches user-authored content.
- Quality gates: {repo test/lint commands} must pass before a completed.md entry.
```

## `docs/work-ledger/active.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Active Work

Entry format: see `docs/harness/index.md` § Conventions ({variant} variant).

{entries discovered during exploration, or nothing — an empty section list is valid}
```

## `docs/work-ledger/completed.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Completed Work

Newest first. Entry format: see `docs/harness/index.md` § Conventions.

{backfilled milestone entries from git history, newest first, each with
 `verified: backfilled from git history`}

## project-started
- done: {date of first commit, or today for greenfield}
- summary: project started
- verified: backfilled from git history
- follow-ups: none
```

## `docs/work-ledger/follow-ups.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Follow-ups

Known debt and opportunities. Entry format: see `docs/harness/index.md` § Conventions ({variant} variant).

{entries found during exploration, or nothing}
```

## `docs/work-ledger/abandoned.md`

```markdown
<!-- codex-harness: generated {DATE} -->
# Abandoned Work

Paths tried and dropped — each with a resume condition. Entry format: see
`docs/harness/index.md` § Conventions.

{entries found during exploration, or nothing}
```
