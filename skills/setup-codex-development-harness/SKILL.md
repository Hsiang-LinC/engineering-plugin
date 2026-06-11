---
name: setup-codex-development-harness
description: Use when adopting an agent in a new or existing repo, when agents re-explore the codebase every session, when project state (done/doing/abandoned) is scattered or stale, when switching issue trackers (local ledger, GitHub, Linear, JIRA), when wiring an orchestrator to dispatch agent work autonomously (acceptance gates, failure states, dependency unblocking), or when an existing harness needs refresh or a drift check.
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
- Autonomy is a contract fact: who may accept work lives in `tracker.md`'s
  state machine. Orchestrators read it; they never decide it.

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
- **Environment** — workflow skills *with actual namespaces* (from the
  session's skill listing; if skills cannot be enumerated, use generic
  fallbacks); bootloaders (AGENTS.md/CLAUDE.md/GEMINI.md): which exist,
  mirrored, drifted.
- **History** — `git log` for milestone-level events.
- **Tracker** — candidates in order: existing `tracker.md`; live GitHub
  issues; Linear/JIRA traces (configs, issue-ref formats, `docs/agents/`
  descriptions); existing `docs/work-ledger/`. Also detect the access path
  (MCP tools, `gh` CLI, none). A remote candidate needs structural evidence
  (a configured remote, tracker config, or live issues) — CLI auth alone is
  not a candidate; trace-only evidence (issue refs without live access) is a
  candidate but flagged unverified.
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
  recommendation (local, unless detection found remote-tracker evidence);
- multiple → list differences; user decides.
- trace-only (unverified) candidates: state the uncertainty in the proposal.

And **acceptance authority** for the generated state machine: human-gated
(default — a human accepts the Done-equivalent state) or agent-gated (a
reviewer agent distinct from the author accepts, with verification
evidence; humans handle escalations only). Recommend human-gated unless an
orchestrator was detected or the user asked for autonomous operation. Both
profiles keep the invariant: the author of a change never accepts its own
item.

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
others exist, ask which hosts it; if none, ask which to create (recommend
`AGENTS.md`). Every other bootloader gets the one-line pointer. Mirror drift:
warn in the report, do not fix.

### 6. Validate

All hard gates must pass before reporting done:

- [ ] every path referenced in block and index exists
- [ ] exactly one harness block in the repo
- [ ] routing skill names resolve in this environment, or are generic fallbacks
- [ ] harness docs committed (harness paths only — never sweep unrelated dirty files)
- [ ] tracker-leak: in instruction files (bootloader, `index.md`, split
      routing files), the concrete tracker is named only as the
      `tracker.md` pointer; work-item IDs inside archive entries are data —
      exempt; naming a platform for non-tracker purposes (e.g. CI, hosting)
      in Coexisting Systems is exempt
- [ ] `tracker.md` has all ten contract sections filled, no `{...}` braces left
- [ ] dispatch eligibility reads as one machine-checkable rule referencing
      § Work Item Format and the dependency encoding
- [ ] failure handling is one rule: evidence posted + failure state set —
      no path leaves an item in the claimed state after its worker exits
- [ ] no state allows the agent that authored a change to accept its own
      item (holds in both acceptance profiles)
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
   converts them to one-line pointers once migration completes. While the
   unmigrated list is non-empty, `active.md` stays a live ledger file —
   demote only when the list empties; retained unmigrated entries count as
   open items for any later reverse swap.
5. Validate (all setup gates). **Success criterion: no file outside
   `tracker.md` and the migrating ledger files changed.** Flag any now-stale
   `index.md` § Conventions entries (e.g. live-entry format listed when the
   new mode is remote) in the report for cleanup at next refresh. Swap is
   not done while the unmigrated list is non-empty — report it.
   Re-running swap mode with the same target resumes the unmigrated list —
   never regenerate a `tracker.md` already at the target. The report must
   tell the user to run refresh after migration completes.

## Refresh Mode

1. **Drift scan** — module-map vs tree; active items vs git log (finished
   but still listed?); `Last verified` overdue (>90 days); bootloader pointer
   liveness; **archive backfill gap** (tracker Done/Canceled items missing
   from `completed.md`/`abandoned.md`); **orchestrator consistency**
   (state/label names and the transitions the orchestrator performs in
   detected orchestrator config match `tracker.md` — mismatch: warn only);
   **contract gap** (a `tracker.md` generated before the ten-section
   contract lacks § Work Item Format / § Failure Handling — generate the
   missing sections from the matching preset, asking the user for the
   acceptance profile; preserve existing sections verbatim);
   **tracker-leak scan**.
2. **Present drift summary. Wait for approval.**
3. **Execute** — patch only inside markers; batch-backfill archives;
   archive roll-off per conventions; topology upgrade check.

If the tracker is unreachable (API down, no credentials): skip
tracker-dependent checks, note the gap in the report — never block on
remote availability.

**v2 migration**: markers exist but no `tracker.md`. Extract tracker facts
from `index.md` § Conventions into a generated `tracker.md` (matching
preset, else custom); run the six Explore detections first; replace the
bootloader block with the v3 template; regenerate `index.md` in full — the
entire file is generated content; the file-level header is its marker
(tracker-agnostic wording); demote live ledger files if the mode is remote;
ensure `abandoned.md` exists; refresh ledger-file generated headers to the
v3 templates, preserving entries verbatim; backfill `completed.md` gaps from
git history. Anything not clearly generated is user-authored — ask before
touching.

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
| Acceptance authority change (human-gated ↔ agent-gated) | edit `tracker.md` only — State Machine authority rows and Read/Write allowed transitions; no other file changes |
| Swap with unmigrated entries | keep old format, list in report; swap incomplete until the list is empty |
| Tracker detail undetectable at generation (e.g. JIRA state names, GitHub owner/repo) | ask the user to supply it before writing tracker.md; never generate with braces unfilled |
