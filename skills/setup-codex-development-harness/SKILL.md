---
name: setup-codex-development-harness
description: Use when adopting an agent in a new or existing repo, when agents re-explore the codebase every session, when project state (done/doing/abandoned) is scattered or stale, when switching issue trackers (local ledger, GitHub, Linear, custom), when wiring an orchestrator to dispatch agent work autonomously (acceptance gates, failure states, dependency unblocking), when a long-horizon roadmap or milestone sequence needs a durable home agents pick up every session, when workflow skills (to-issues, to-prd, triage) need tracker/label/artifact/domain-doc/quality-gate config, or when an existing harness needs refresh or a drift check.
---

# Setup Codex Development Harness

Create or refresh a repo-local harness so agents start from a durable map
instead of re-exploring. Core artifacts: **tracker contract**
(`docs/harness/tracker.md`), **direction** (`docs/harness/roadmap.md`),
**quality gates** (`docs/harness/quality-gates.md`), **archives**
(`docs/work-ledger/`), **index + routing** (`docs/harness/index.md`), and
the **bootloader block**. The harness owns project workflow routing and
handoffs; selected skills supply methodology; orchestrators and workflow skills integrate by reading
`tracker.md` + `index.md` + `quality-gates.md` — the skill never generates
orchestrator config or per-skill shadow config.

## Doctrine

- Write-cost first: judge every addition by whether agents will keep it updated.
- One fact, one residence. A fact in two generated places is a bug.
- Detection over mandate: absorb existing systems; require none.
- Uncommitted memory is not memory. Remote trackers hold live state; the
  git-resident archives (`completed.md`, `abandoned.md`) hold history in
  every mode.
- Tracker identity lives in exactly one file. Switching trackers must not
  touch routing.
- Workflow skills are methodology providers, not artifact owners. The
  harness names the repo's artifact adapters, domain-doc routes, tracker
  roles, and quality gates.
- Autonomy is a contract fact: who may accept work lives in `tracker.md`'s
  state machine. Orchestrators read it; they never decide it.
- Direction is user-owned: `roadmap.md` holds the milestone sequence and
  current node. It changes only at node boundaries — in interactive
  sessions — so its write-cost is human-supervised. Agents propose
  advances with evidence; they never advance a node alone.
- Three write cadences, three residences: direction (`roadmap.md`, per
  node), specs/PRDs/ADRs (repo docs, per node), work items (tracker, high
  frequency). A fact at the wrong cadence rots.

## Mode Selection

- User asks to switch trackers → **swap mode**.
- `codex-harness` markers + `docs/harness/tracker.md` → **refresh mode**.
- `codex-harness` markers without `tracker.md` → **v2 migration**.
- Harness-shaped files (`docs/harness/`, `docs/work-ledger/`) without
  markers → **v1 migration**.
- Otherwise → **setup mode**.

## Setup Mode

### 1. Explore

Record a compact project profile in the index: actors/goals, important state
transitions, data invariants, external side effects and operational risks. Map
only applicable risks to design examples and verification (for example, UI
cancel/undo, retry/idempotency for integrations, dry-run/rollback for scripts).
Use observed evidence; distinguish unknowns from confirmed requirements.

Six detections (large repos: read-only subagents per area):

- **Structure** — source tree, build/test commands, module and runtime boundaries.
- **Docs** — classify each doc (spec, PRD, ADR, CONTEXT, dev logs,
  memory-bank-like) as source-of-truth/stale/historical. Staleness test:
  sample concrete claims (modules, APIs, flows) against code. Also record:
  domain layout (`CONTEXT.md` single-context vs `CONTEXT-MAP.md`
  multi-context; `docs/adr/` locations); existing roadmap/milestone docs
  (`ROADMAP.md`, milestone sections) — roadmap-residence candidates; existing
  spec/plan/artifact roots (`docs/features/`, `docs/superpowers/plans/`,
  `docs/specs/`, similar) — artifact-residence candidates.
- **Environment** — workflow skills *with actual namespaces* (from the
  session's skill listing; if skills cannot be enumerated, use generic
  fallbacks); specifically detect the design-workflow chain — grilling,
  PRD, issueization, triage skills — which fills the index's Work
  Production pipeline; bootloaders (AGENTS.md/CLAUDE.md/GEMINI.md): which
  exist, mirrored, drifted.
- **History** — `git log` for milestone-level events.
- **Tracker** — candidates in order: existing `tracker.md`; live GitHub
  issues; Linear/custom-tracker traces (configs, issue-ref formats, prior docs);
  existing `docs/work-ledger/`. Also detect the access path
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
| Overlapping | old state notes in CLAUDE.md, memory-bank files, prior tracker/label config, existing `ROADMAP.md` | truth moves to harness; foreign file gets a one-line pointer — ask before editing any foreign file. An existing roadmap doc is either adopted in place (index routes to it) or migrated into `roadmap.md` — user decides |
| Conflicting | rival state system in active use | list differences; user decides which survives |

### 3. Propose

Present: detection summary, topology verdict (core unless extended
thresholds met), absorption dispositions, and **tracker adjudication**:

- exactly one candidate → propose adopting it;
- none → ask the user (local / GitHub / Linear / custom), with a
  recommendation (local, unless detection found remote-tracker evidence);
- multiple → list differences; user decides.
- trace-only (unverified) candidates: state the uncertainty in the proposal.

**Roadmap residence**: existing roadmap/milestone doc found → adopt in
place or migrate into `docs/harness/roadmap.md` (user decides; one
residence either way, index routes to it); none → generate `roadmap.md` —
fill milestones from the conversation or git milestones when available,
else a single current node capturing the project's present goal.

**Artifact residence**: existing per-project/per-slice artifact root found →
adopt it; none → default to `docs/features/<roadmap-node-slug>/` for large
node packets, with slice packets under
`docs/features/<roadmap-node-slug>/<slice-slug>/` only when a slice has real
artifacts. Workflow-skill default paths (for example
`docs/superpowers/plans/`) are adopted only when chosen as the artifact
residence; otherwise record the override in `index.md`. Do not create empty
packet directories during setup.

**Domain layout**: single-context vs multi-context from the Docs detection;
confirm the route in `index.md` before writing. Do not create empty domain
docs during setup: create `CONTEXT.md` / `CONTEXT-MAP.md` lazily when a
term is resolved, and create ADRs lazily when a decision is hard to
reverse, surprising without context, and a real trade-off.

**Workflow labels** (when workflow skills are detected): propose the
category roles (`bug`, `enhancement`) and state roles (`needs-triage`,
`needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`) mapped to
any existing repo labels (see tracker-adapters substitution rule).

And **acceptance authority** for the generated state machine: human-gated
(default — a human accepts the Done-equivalent state) or agent-gated (a
reviewer agent distinct from the author accepts, with verification
evidence; humans handle escalations only). Default to human-gated unless the user explicitly authorizes agent acceptance;
an installed orchestrator does not grant that authority. Child acceptance and
parent/release acceptance may differ; record each boundary in the tracker. Both
profiles keep two invariants: the author of a change never accepts its own
item, and a human may set any state — profiles grant agent authority, they
never revoke human authority.

When agent delivery is authorized, record the merge target, required checks,
human-only exception paths/actions, and escalation conditions. An independent
reviewer and verification must cover the exact revision delivered. New product
scope, changed approved UX/contracts or missing decisions return to clarification;
AFK/readiness alone grants no extra authority. Merge and release/deployment are
separate permissions. With a runtime, reference its checked project acceptance
artifact from `tracker.md` as the single residence of executable values; without
one, keep the same policy in `tracker.md`. Never install a scheduler-specific
workflow engine into the generic harness. Refuse unsupported policy mappings.

**Wait for approval before writing.**

### 4. Write

Generate from [core-templates.md](core-templates.md) and the chosen preset
in [tracker-adapters.md](tracker-adapters.md) (plus
[extended-templates.md](extended-templates.md) if approved). Every file gets
the generated header. Local mode writes all four ledger files; remote modes
write the two archives only. Backfill `completed.md` from git milestones —
and from the tracker's Done/Canceled items in remote modes. Write
`roadmap.md` per the approved roadmap residence (skip only when an
existing doc was adopted in place). Always write
`docs/harness/quality-gates.md`. Record workflow-skill routing, artifact
adapters, Domain Docs routing, and Quality Gates routing in
`docs/harness/index.md`; do not generate `docs/agents/*`.

### 5. Bootloaders

The harness block lives in exactly **one** file — default `AGENTS.md`; if only
others exist, ask which hosts it; if none, ask which to create (recommend
`AGENTS.md`). Every other bootloader gets the one-line pointer. Mirror drift:
warn in the report, do not fix.

### 6. Validate

All hard gates must pass before reporting done. Exercise the scenarios in
[behavioral-checks.md](behavioral-checks.md) against the generated instance;
file presence alone does not verify agent behavior:

- [ ] every path referenced in block and index exists
- [ ] exactly one full harness block; other bootloaders contain pointers only
- [ ] routing skill names resolve in this environment, or are generic fallbacks
- [ ] harness docs committed (harness paths only — never sweep unrelated dirty files)
- [ ] tracker-leak: in instruction files (bootloader, `index.md`, split
      routing files), the concrete tracker is named only as the
      `tracker.md` pointer; work-item IDs inside archive entries are data
      — exempt; naming a platform for non-tracker purposes (e.g. CI,
      hosting) in Coexisting Systems is exempt
- [ ] `tracker.md` has all ten contract sections filled, no `{...}` braces left
- [ ] dispatch eligibility reads as one machine-checkable rule referencing
      § Work Item Format and the dependency encoding
- [ ] failure handling is one rule: evidence posted + failure state set —
      no path leaves an item in the claimed state after its worker exits
- [ ] no state allows the agent that authored a change to accept its own
      item (holds in both acceptance profiles)
- [ ] roadmap residence exists and is routed from `index.md`; a generated
      `roadmap.md` has § Current Node naming a milestone defined in
      § Milestones (a single greenfield milestone is valid)
- [ ] `docs/harness/quality-gates.md` exists and is routed from `index.md`
- [ ] `index.md` contains Work Production, Artifact Adapters, Domain Docs,
      and Quality Gates routing
- [ ] workflow skills detected ⇒ `tracker.md` § Labels carries the
      category/state vocabulary those skills apply, mapped to real tracker
      labels/states
- [ ] no `docs/agents/*` files were generated by this skill
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

Compare this setup skill and its current templates directly with the existing
harness, actual code/tests, installed toolbox and recent work evidence. An
architecture-improvement review is optional input, never a prerequisite.
Refresh repairs documented drift; it does not refactor application code or
promote the current implementation into intended product behavior.

1. **Drift scan** — module-map vs tree; active items vs git log (finished
   but still listed?); `Last verified` overdue (>90 days); bootloader pointer
   liveness; **archive backfill gap** (tracker Done/Canceled items missing
   from `completed.md`/`abandoned.md`); **orchestrator consistency**
   (state/label names and the transitions the orchestrator performs in
   detected orchestrator config match `tracker.md` — mismatch: warn only);
   **contract gap** (a `tracker.md` generated before the ten-section
   contract lacks § Work Item Format / § Failure Handling — generate the
   missing sections from the matching preset; also check existing readiness,
   acceptance, dependency and skill handoff semantics for contradictions.
   Preserve project decisions; do not overwrite them with template defaults);
   **roadmap drift** (current node's items all terminal but the node not
   advanced — local mode checks entries with matching `parent:`; flag and
   propose the advance to the user, never advance alone; no roadmap residence
   in an existing harness — offer to
   generate); **workflow-config drift** (`index.md` missing workflow-skill
   routing, artifact adapters, Domain Docs, or Quality Gates); **tracker
   label drift** (workflow skills present but `tracker.md` lacks their
   category/state roles); **tracker-leak scan**.
2. **Present drift summary** with evidence, proposed changes and retained
   project decisions. Existing explicit authorization to refresh covers these
   changes; ask only for unresolved scope or authority decisions.
3. **Execute** — patch only inside markers; batch-backfill archives;
   archive roll-off per conventions; topology upgrade check. Re-run setup
   validation and behavioral checks; record what could not be verified.
   Do not infer acceptance from git history, or advance the roadmap implicitly.

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
  + `docs/harness/tracker.md` + `docs/harness/quality-gates.md` + roadmap
  residence + ledger files per mode.
- **Extended** — upgrade only when: `index.md` >~150 lines, or modules >10,
  or ≥2 runtime boundaries, or real material exists for an optional track.
  A split **moves** the section, leaving a one-line pointer — never copy.

## Edge Rules

| Case | Rule |
|---|---|
| Greenfield repo | core; ledger structurally complete but empty; `project-started` entry; no backfill; `roadmap.md` gets a single current milestone |
| Design-workflow skills absent | Work Production pipeline uses generic fallbacks; still record artifact adapters, Domain Docs, and Quality Gates routing |
| Existing roadmap doc actively maintained | adopt in place — index routes to it; never create a duplicate `roadmap.md` |
| No git/shallow clone | skip backfill; mine existing docs for history; note gap in report |
| User content in generated files without markers | user-authored; ask before touching |
| Monorepo | one root harness; module-map sectioned by package; per-package harnesses out of scope |
| Dirty git state | commit harness paths only |
| Tracker unreachable | skip tracker-dependent checks; note gap; never block |
| No preset for chosen tracker | generate from the custom skeleton with the user; gates apply unchanged |
| Orchestrator config conflicts with `tracker.md` | warn only; never edit foreign config |
| Acceptance authority change (human-gated ↔ agent-gated) | update the authoritative policy residence; `tracker.md` references checked runtime values when present. Refresh runtime validation and invalidate stale acceptance evidence; otherwise update the tracker authority rows directly |
| Swap with unmigrated entries | keep old format, list in report; swap incomplete until the list is empty |
| Tracker detail undetectable at generation (e.g. custom state names, GitHub owner/repo) | ask the user to supply it before writing tracker.md; never generate with braces unfilled |
