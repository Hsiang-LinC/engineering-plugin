# Harness v3: Tracker-Adapter Architecture — Design

Date: 2026-06-11
Status: approved-pending-implementation
Scope: in-place rewrite of `plugins/engineering/skills/setup-codex-development-harness` (v2 → v3)

## Motivation

Field experience from the trading-advisor repo (v2 harness + Linear + Symphony
orchestration) surfaced three structural weaknesses in v2:

1. **Tracker knowledge is scattered.** v2 encodes tracker behavior as
   `{variant}` substitutions across `index.md` Conventions, ledger file
   headers, and the bootloader. Switching trackers (manual ledger → Linear)
   required rewriting every generated file and left migration residue.
2. **Interactive-track awareness gap.** The bootloader demanded tracker
   updates but presupposed an "assigned issue" (orchestrator worldview).
   Ad-hoc interactive work had no bright-line trigger, so agents skipped the
   tracker by default.
3. **No orchestration interface.** Symphony had to invent its own contract
   (WORKFLOW.md) for dispatch eligibility, worker entry reading, completion
   evidence, and state authority. None of that was harness-defined, so it is
   not portable to the next repo or the next orchestrator.

## Goals

- Tracker-agnostic harness: local ledger, GitHub Issues, Linear, JIRA, or
  custom — swappable by regenerating exactly one file.
- Prefer the repo's existing system; if none detected, ask the user which to
  use. Never mandate a tracker.
- Orchestration-ready by default: any orchestrator can integrate by reading
  harness files only. The skill defines the interface contract; it does not
  generate or manage orchestrator-specific config.
- Git-resident history in every mode: `completed.md` / `abandoned.md` archives
  survive tracker outages and tracker migrations.

## Non-Goals

- No code shims, CLIs, or MCP servers shipped by the skill. The adapter is a
  documentation contract, not software. (Assessed and rejected as
  over-engineered; revisit only on observed format-error incidents.)
- No orchestrator config generation (e.g., Symphony WORKFLOW.md). Detected
  orchestrators are registered as coexisting systems and consistency-checked,
  nothing more.
- No per-package harnesses in monorepos (unchanged from v2).

## Decision Anchors (from design review)

| Decision | Choice |
|---|---|
| Delivery | In-place v3 rewrite of the existing skill |
| Orchestration depth | Interface contract only |
| Remote-mode history | `completed.md` (+ `abandoned.md`) retained as git archives with backfill |
| Tracker abstraction | A1 — single adapter file `docs/harness/tracker.md` |
| Orchestration interface residence | B1 — folded into `tracker.md` + `index.md` (no separate file) |

## Architecture

### Generated topology (core)

```
bootloader block (single residence; bright-line rule)        [rewritten]
docs/harness/index.md     (routing; fully tracker-agnostic)  [rewritten]
docs/harness/tracker.md   (tracker adapter; ONLY tracker-
                           specific file in the repo)         [new]
docs/work-ledger/completed.md  (archive; all modes)          [kept]
docs/work-ledger/abandoned.md  (archive; all modes)          [kept]
docs/work-ledger/active.md     (local mode only)             [conditional]
docs/work-ledger/follow-ups.md (local mode only)             [conditional]
```

Extended topology (architecture/, split routing files, optional tracks) is
unchanged from v2.

### The tracker adapter contract (`docs/harness/tracker.md`)

Every adapter fills the same eight sections. This file is simultaneously the
agent's instruction manual and the orchestrator's integration interface.

1. **Identity** — kind (`local` | `github` | `linear` | `jira` | `custom`),
   where truth lives, work-item ID format.
2. **State machine** — table of states: name / meaning / which actor may set
   it. Authority boundaries are encoded here (e.g., agents never set `Done`;
   human review is the acceptance gate).
3. **Labels** — actor / work-type / gate classifications. May be empty
   (local mode).
4. **Dispatch eligibility** — a machine-checkable rule for what an
   orchestrator may dispatch (e.g., state `Todo` + label `agent` + unblocked +
   has acceptance criteria).
5. **Read / write** — how an agent reads its work item and posts updates:
   MCP tool names, CLI commands, or direct file edits (local mode).
6. **Completion evidence** — required format: changed files, verification
   commands and outcomes, remaining risks, follow-up refs.
7. **Archive policy** — `Done` → `completed.md` entry, `Canceled` →
   `abandoned.md` entry (with `resume-if:`); backfilled per item or batch at
   refresh.
8. **Interactive rule** — behavior when work has no matching item: create one
   (state/label defaults) or ask the user; tracker-side detail behind the
   bootloader bright line.

### Local ledger as adapter, not special case

The `local` adapter fills the same contract with file semantics: states map to
`active.md` `status:` fields, read/write is file editing, dispatch eligibility
is expressed over entry fields. Consequences:

- The skill's process has no tracker/no-tracker forks; every mode reads the
  same contract.
- An orchestrator can in principle dispatch against a local ledger by reading
  `active.md` per the adapter — orchestration-readiness does not require a
  remote tracker.

### Worker entry contract (`index.md` Start Sequence)

The Start Sequence becomes the orchestrator-facing worker entry contract:

1. Read `docs/harness/tracker.md`; read your work item per its Read/write
   section.
2. Identify task type in the routing table; read listed context; use listed
   workflow.
3. Before closing: post completion evidence and state update per
   `tracker.md`; update durable repo docs when facts changed.

Routing-table completion columns say "tracker update per `tracker.md`" —
never a concrete tracker name.

### Bootloader (v3 core template, tracker-agnostic)

```markdown
<!-- codex-harness:begin -->
## Development Harness

Before any development task, read `docs/harness/index.md` and follow its routing.

Hard rules:
1. Work state lives in the tracker — read `docs/harness/tracker.md` before
   starting work.
2. Bright line: any work that changes code, contracts, or docs is
   tracker-worthy — before the first edit, confirm a work item covers it or
   create one per `tracker.md` (interactive sessions included). Pure reading,
   discussion, or Q&A is not tracker-worthy.
3. Definition of done includes the tracker update defined in `tracker.md`
   and updating durable repo docs when facts changed.
4. Routing tables live only in `docs/harness/index.md`. Do not duplicate them here.
<!-- codex-harness:end -->
```

(Field-validated: rules 1–3 mirror the wording deployed to trading-advisor's
AGENTS.md on 2026-06-11.)

## Process Changes

### Setup mode (v2's six steps, two reinforcements)

- **Explore** gains two detections:
  - *Tracker detection*, in order: existing `tracker.md` → live GitHub issues
    → Linear/JIRA traces (config files, issue-ref formats, `docs/agents/`
    descriptions) → existing `work-ledger/`.
  - *Orchestrator detection*: Symphony `WORKFLOW.md`, CI dispatch jobs, etc. →
    registered in Coexisting Systems.
- **Propose** gains tracker adjudication: exactly one candidate → propose
  adopting it; zero → AskUserQuestion (local / GitHub / Linear / JIRA /
  custom, with recommendation); multiple → list differences, user decides.
  Approval gate before writing is unchanged.

### Swap mode (new, fourth mode)

Triggered when the user asks to switch trackers.

1. Generate new `tracker.md` from the adapter preset.
2. Migrate live entries old-truth → new-truth (e.g., `active.md` entries →
   issues, each annotated with the new ID; reverse direction symmetric).
   Never invent placeholder IDs; unmigratable entries keep local format with
   migration noted in `next:`.
3. Ledger promotion/demotion on mode change: remote→local regenerates
   `active.md`/`follow-ups.md`; local→remote converts them to one-line
   pointers after migration completes.
4. Validate the tracker-leak gate. **Success criterion: no file other than
   `tracker.md` (and migrating ledger files) is modified.**

### Refresh mode (three new drift checks)

- *Archive backfill gap*: items `Done`/`Canceled` in the tracker but missing
  from `completed.md`/`abandoned.md` → batch backfill.
- *Orchestrator consistency*: state/label names in `tracker.md` match any
  detected orchestrator config (e.g., Symphony WORKFLOW.md frontmatter);
  mismatch → warn, do not edit foreign config.
- *Tracker-leak scan*: concrete tracker names outside `tracker.md` → flag.

### v2 → v3 migration (absorbed into refresh detection)

v2 markers present but no `tracker.md` → migration: extract tracker facts from
`index.md` Conventions into a generated `tracker.md`; replace the bootloader
block with the v3 template (bright line included); demote live ledger files if
mode is remote. v1→v2's rule carries over: anything not clearly generated is
user-authored — ask before touching.

## Validation Gates

v2's four gates, plus:

- [ ] Tracker-leak: in instruction files (bootloader block, `index.md`,
      split routing files), concrete tracker names appear only as the
      pointer "see `tracker.md`". Work-item IDs inside archive *entries*
      are data, not identity — exempt.
- [ ] `tracker.md` has all eight contract sections filled (no placeholders).
- [ ] Dispatch eligibility is stated as a machine-checkable rule.
- [ ] `completed.md` and `abandoned.md` exist in every mode.

## Skill File Changes

```
SKILL.md              rewrite: four modes (setup/refresh/swap/migration),
                      detection order, doctrine +1
core-templates.md     rewrite: v3 bootloader, tracker-agnostic index.md,
                      tracker.md skeleton, archive files
tracker-adapters.md   new: local / github / linear / jira presets + custom
                      skeleton (each = the eight sections pre-filled)
extended-templates.md unchanged
ledger-conventions.md slimmed: archive entry formats, markers, staleness,
                      roll-off only (tracker variants move to adapters file)
```

Doctrine gains a fifth rule: **"Tracker identity lives in exactly one file.
Switching trackers must not touch routing."**

## Error Handling & Edge Rules

v2 edge rules carry over (greenfield, no-git, monorepo, dirty state, unmarked
user content). New:

| Case | Rule |
|---|---|
| Tracker unreachable during refresh (API down, no key) | skip tracker-dependent checks, note gap in report; never block on remote availability |
| Adapter preset missing (user picks unsupported tracker) | generate from custom skeleton; user fills read/write specifics; gate still requires all eight sections |
| Orchestrator config conflicts with `tracker.md` | warn-only; foreign config is never edited (detection over mandate) |
| Swap with unmigrated entries | keep old entries in local format, list them in the report; swap is not "done" until migration list is empty |

## Testing

Same method as v2 hardening (cf. commit 846f9a7 "close loopholes found in
subagent testing"): dispatch clean-room subagents to run the skill against
fixture repos — (a) greenfield, (b) repo with live GitHub issues, (c) repo
with a v2 harness (migration path), (d) swap local→github→local round-trip —
and verify gates, especially the tracker-leak gate and swap's
"only tracker.md changed" criterion.
