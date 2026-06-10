# Design: setup-codex-development-harness v2 Redesign

Date: 2026-06-10
Status: Approved design, pending implementation plan
Target: `plugins/engineering/skills/setup-codex-development-harness/`

## Problem

The v1 skill generates a 12-file harness unconditionally, duplicates routing
facts across three layers (AGENTS block / index.md / routing files), hardcodes
skill namespaces that break across installs, has no generated-section markers,
no staleness signals, no tracker integration rule, and no multi-bootloader
handling. A field audit of a real v1-generated harness (trading-advisor,
generated 2026-06-09) confirmed six concrete failures:

1. Dual bootloaders drift: harness block only in AGENTS.md; CLAUDE.md sessions
   never see the harness.
2. Routing facts duplicated in three places (drift surface x3).
3. Tracker dual-truth: GitHub Issues active, but ledger entries carry no issue
   refs; ADR status double-written into active.md.
4. Zero staleness signals: no markers, no dates; the template `Updated` field
   was dropped during generation.
5. Ledger born incomplete and uncommitted: pre-harness project history absent
   from completed.md; entire harness untracked in git.
6. Hardcoded skill namespaces (`engineering:*`) resolve to nothing when the
   plugin is installed under a different namespace.

## Doctrine (design principles)

- The harness owns three layers: **state + index + routing**. The workflow
  layer is delegated to whatever process system exists in the environment
  (superpowers, native skills, anything). Never duplicate content, never
  prescribe workflow.
- **Write-cost minimization** is the first design principle. The system is
  judged by the probability the map gets updated per unit of work, not by map
  completeness.
- **One fact, one residence.** Any fact appearing in two generated places is a
  design bug.
- **Detection over mandate.** Absorb existing systems (trackers, process
  skills, old harnesses) by detection and classification, never by requiring
  prior setup.
- An uncommitted memory is not a memory.

## Decisions (settled during brainstorming)

| # | Decision |
|---|---|
| D1 | State layer keeps the four-file ledger directory (`active/completed/follow-ups/abandoned`). Write-cost risk mitigated by section-entry format and quality gates, not by collapsing files. |
| D2 | Truth source is detection-based: tracker present → `active.md`/`follow-ups.md` entries are "issue ID + one-line summary" refs and tracker is truth; tracker absent → ledger is full truth. Adopting a tracker later is handled by refresh mode (entries demoted to refs). |
| D3 | Two legal topologies: **core** and **extended**. Transitions happen only in refresh mode against deterministic thresholds. Day-to-day agents append content; they never change topology. |
| D4 | Absorption procedure: inventory coexisting systems → classify each as orthogonal (compose into routing) / overlapping (assign truth to harness, other file gets a one-line pointer, user approves any edit to foreign files) / conflicting (user decides). Never rewrite foreign systems' content. |
| D5 | Enforcement is prompt-layer only: AGENTS hard rules ("definition of done includes ledger update") + quality gates. No hooks generated (portable across agent environments). |
| D6 (B-7) | Multi-bootloader rule: harness block has a single residence (default AGENTS.md); every other detected bootloader (CLAUDE.md, GEMINI.md) gets a one-line pointer. Refresh checks pointer liveness and warns on mirror drift. |
| D7 (B-8) | Setup backfills `completed.md` from git history at milestone granularity. Validation hard-gates on "harness docs committed". |
| D8 | Test with Opus or Sonnet class models, not the strongest available model, so the skill's clarity is verified rather than compensated by model capability. |

## Skill file topology (5 files → 4)

```
setup-codex-development-harness/
├── SKILL.md                  # process: setup mode + refresh mode, absorption,
│                             # reconciliation, drift procedures, edge rules
├── core-templates.md         # AGENTS block + harness/index.md + ledger (4 files)
├── extended-templates.md     # architecture/, routing split files, optional tracks
└── ledger-conventions.md     # entry format (tracker/no-tracker variants),
                              # archive policy, marker spec, Last-verified semantics
```

Template grouping equals topology states: setting up core reads one template
file; upgrading to extended reads the second. `ledger-conventions.md` is a
referenced spec (generated docs point at its rules), distinct from one-shot
writing guides.

## Generated artifact topology

### Core (every repo's starting state)

```
AGENTS.md                     # harness block: pointer + hard rules, ~15 lines max
CLAUDE.md / GEMINI.md         # if present: one-line pointer (D6)
docs/harness/index.md         # the only routing residence
docs/work-ledger/
├── active.md                 # tracker → ID+ref entries; no tracker → full entries
├── completed.md              # backfilled from git history at setup (D7)
├── follow-ups.md
└── abandoned.md
```

### Extended (refresh-mode upgrade only)

```
+ docs/architecture/index.md, module-map.md
+ docs/harness/decision-routing.md, context-routing.md
    # split out of index.md sections; original section replaced by a one-line
    # pointer — the fact moves, it is never copied
+ optional tracks (product/contracts/ui/agent-system/data-model/ops),
    each justified independently
```

Upgrade thresholds (written verbatim in SKILL.md): `index.md` > ~150 lines, or
modules > 10, or >= 2 runtime boundaries, or real material exists for an
optional track.

All generated files carry `<!-- codex-harness: generated YYYY-MM-DD -->`.
The AGENTS block is wrapped in `<!-- codex-harness:begin -->` /
`<!-- codex-harness:end -->`.

## Template content keys

### AGENTS block (~15 lines, no routing tables)

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

### `index.md` sections (core form, all inline)

1. **Start Sequence** — read `active.md` → identify task type → consult routing
   table → update ledger on completion.
2. **Task Routing** — task type → read first → workflow → completion update.
   Workflow column holds detected actual skill names; undetected → generic
   fallback wording ("use your debugging workflow").
3. **Coexisting Systems** — absorption output: one line per detected system
   (name / classification: orthogonal-composed, overlap-resolved,
   conflict-user-decided / truth assignment).
4. **Conventions** — this repo's tracker status and entry variant, marker
   explanation, staleness markers.

### Ledger entry format (sections, not tables)

```markdown
## auth-token-refresh
- status: in-progress
- source: gh#142          # tracker variant: these lines + one summary line only
- next: wire refresh endpoint to session store
- updated: 2026-06-10
```

Rationale: append-only, merge-friendly, missing fields visibly absent (audit
finding #4: table columns silently dropped). `completed.md` adds a
`verified:` field (test evidence).

### `ledger-conventions.md`

Entry field definitions (both tracker variants), archive policy
(`completed.md` > ~200 entries or > 1 year → roll to
`archive/completed-YYYY.md`, executed by refresh), marker spec, Last-verified
semantics.

## Process

### Setup mode (six steps)

1. **Explore** — four parallel detections:
   - Structure: source tree, build/test config, module boundaries, runtime
     boundaries.
   - Doc inventory: classify every existing doc (spec/PRD/ADR/CONTEXT/dev
     logs/memory-bank-like) as source-of-truth / stale / historical. Staleness
     test: sample concrete claims (module names, APIs, flows) against current
     code.
   - Environment: available skills (actual namespaces), issue tracker
     (`docs/agents/` config or live GH issues), bootloaders (which of
     AGENTS.md/CLAUDE.md/GEMINI.md exist; are they mirrors; have they drifted).
   - History: coarse `git log` read, extract milestone-level events (for D7
     backfill).
2. **Absorb** — classify each coexisting system per D4.
3. **Propose** — present detection summary, topology verdict (core/extended
   with threshold data), absorption dispositions, applicable tracker variant.
   **Wait for user approval before writing.**
4. **Write** — generate from templates. Generated header on every file.
   Backfill `completed.md` (D7). Tracker present → ref-format entries.
5. **Bootloaders** — write harness block to its single residence (default
   AGENTS.md; absent-but-CLAUDE.md-exists → ask user where). One-line pointer
   into every other bootloader (D6). Mirror drift detected → warn, do not fix,
   include in report.
6. **Validate** — hard checks: every path referenced in the block exists; no
   duplicate blocks; routing-table skill names resolve or are marked fallback;
   **harness docs are committed** (D7 gate — cannot report done otherwise).

### Refresh mode (entered when markers are detected)

1. **Drift scan**: module-map vs actual tree diff; active entries vs recent
   git log (completed but still listed?); Last-verified overdue list;
   bootloader pointer liveness.
2. **Present drift summary**, wait for approval.
3. **Execute**: patch generated regions (inside markers) only — user-edited
   regions untouched; archive roll-off; topology upgrade check (thresholds met
   → split files, leave pointer at origin); `completed.md` gap-fill
   (milestones present in git log but missing from ledger).

## Edge cases (explicit rules in SKILL.md)

| Case | Rule |
|---|---|
| Greenfield empty repo | Core form; ledger structurally complete but empty; `completed.md` gets a "project started YYYY-MM-DD" line; no backfill. |
| No git / shallow clone | Skip D7 backfill; extract history from existing docs; note the gap in the report. |
| v1 harness present (harness files, no markers) | Treat as v1 → propose migration: consolidate routing into index.md, slim AGENTS block, add markers, backfill. Execute after approval. |
| User-authored content in generated files without markers | Treated as user-authored; ask before touching (v1 hard rule retained, now machine-checkable). |
| Monorepo | Single root harness; module-map sectioned by package. Per-package harnesses explicitly out of scope (YAGNI). |
| Dirty git state | Harness commit includes harness paths only; never sweep unrelated files. |
| No bootloader exists at all | Ask user which to create; never silently create one. |

## Frontmatter / CSO

```yaml
description: Use when adopting an agent in a new or existing repo, when agents
  re-explore the codebase every session, when project state (done/doing/abandoned)
  is scattered or stale, or when an existing harness needs refresh or drift check.
```

Triggering conditions only — no workflow summary (per writing-skills CSO rule:
a description that summarizes workflow becomes a shortcut that skips the skill
body).

## Testing plan (writing-skills Iron Law)

Run with **Opus or Sonnet class models** (D8) — the skill must carry weaker
models; do not let frontier-model capability mask skill ambiguity.

Three scenarios, each run baseline (no skill) then with-skill:

1. **Greenfield**: empty repo. Verify: core 5 files + block only; no extended
   files; ledger format conforms to conventions; committed.
2. **Mature messy repo**: tracker present, stale docs, superpowers installed.
   Verify: tracker detected → ref entries; absorption classifications correct;
   history backfilled; propose-before-write honored.
3. **v1 migration**: use trading-advisor as fixture (real v1 output with six
   known defects). Verify: drift summary names the routing triplication and
   dual bootloaders; post-migration every fact has one residence; user-edited
   regions untouched.

Record every failure rationalization verbatim → feed back into SKILL.md
counters (REFACTOR phase).

## Budget

SKILL.md body target < 500 words; procedures stay tight by pushing reference
material into `ledger-conventions.md` and the two template files.

## Out of scope

- Per-package monorepo harnesses.
- Generated enforcement hooks (D5 keeps enforcement prompt-layer).
- Fixing the trading-advisor AGENTS.md sed corruption (repo's own bug; noted
  for separate repair).
