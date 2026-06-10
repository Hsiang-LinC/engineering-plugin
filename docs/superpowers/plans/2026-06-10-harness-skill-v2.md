# setup-codex-development-harness v2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rewrite the harness-setup skill to the v2 design: 4 skill files, core/extended topology, detection-based tracker rule, markers, multi-bootloader rule, history backfill, refresh mode — then verify with three subagent test scenarios on Sonnet/Opus.

**Architecture:** Pure documentation work inside `plugins/engineering/skills/setup-codex-development-harness/`. Spec: `docs/superpowers/specs/2026-06-10-harness-skill-redesign-design.md` (repo-relative). Templates are grouped by topology state (core/extended) plus one conventions spec. Testing follows superpowers:writing-skills (scenarios = tests; run with `model: "sonnet"` subagents so skill clarity is verified, not masked by model capability — design decision D8).

**Tech Stack:** Markdown, git, Agent tool (subagent testing).

**Conventions used in file contents below:** `{DATE}`, `{REPO}`, `{...}` braces mark values the *generating agent* fills at runtime — they appear verbatim in templates on purpose. They are not plan placeholders.

---

### Task 1: Write `ledger-conventions.md`

**Files:**
- Create: `skills/setup-codex-development-harness/ledger-conventions.md`

- [ ] **Step 1: Write the file with exactly this content**

````markdown
# Ledger Conventions

Rules referenced by generated harness docs. When generating, copy the
*applicable* rules into `docs/harness/index.md` `## Conventions` — generated
repos must not depend on this plugin file at runtime.

## Entry Format

Section entries, never tables. Rationale: append-only, merge-friendly, and a
missing field is visibly absent (table columns get silently dropped).

### `active.md` / `follow-ups.md` — no-tracker variant (ledger is full truth)

```markdown
## <kebab-slug>
- status: planned | in-progress | blocked
- source: <spec / plan / conversation ref>
- next: <single concrete next action>
- updated: YYYY-MM-DD
```

### `active.md` / `follow-ups.md` — tracker variant (tracker is truth)

```markdown
## <kebab-slug>
- source: <tracker id, e.g. gh#142>
- summary: <one line>
```

Status, priority, and detail live in the tracker. Never copy them into the
ledger. Adopting a tracker later: refresh mode demotes existing full entries
to this variant.

### `completed.md`

```markdown
## <kebab-slug>
- done: YYYY-MM-DD
- summary: <what changed>
- verified: <test command run / evidence; "backfilled from git history" for backfill entries>
- follow-ups: <ref into follow-ups.md, or none>
```

### `abandoned.md`

```markdown
## <kebab-slug>
- abandoned: YYYY-MM-DD
- why: <reason>
- resume-if: <condition that would make it viable again>
```

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

- [ ] **Step 2: Verify and commit**

Run: `grep -c '^## ' ledger-conventions.md` — Expected: `8` (4 top-level sections + 4 `## <kebab-slug>` lines inside code blocks).

```bash
git add ledger-conventions.md
git commit -m "feat(harness-skill): add ledger-conventions spec (v2)"
```

---

### Task 2: Write `core-templates.md`

**Files:**
- Create: `skills/setup-codex-development-harness/core-templates.md`

- [ ] **Step 1: Write the file with exactly this content**

````markdown
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
````

- [ ] **Step 2: Verify and commit**

Run: `grep -c 'codex-harness' core-templates.md` — Expected: `>= 10` (markers in every template).

```bash
git add core-templates.md
git commit -m "feat(harness-skill): add core topology templates (v2)"
```

---

### Task 3: Write `extended-templates.md`

**Files:**
- Create: `skills/setup-codex-development-harness/extended-templates.md`

- [ ] **Step 1: Write the file with exactly this content**

````markdown
# Extended Templates

Read only when refresh mode upgrades a repo to the **extended** topology, or
when setup detects thresholds already exceeded (then propose extended at
setup). A split **moves** a section out of `index.md` and leaves a one-line
pointer in its place — it never copies.

Every generated file gets the standard header
`<!-- codex-harness: generated {DATE} -->` and `Last verified: {DATE}` line.

## `docs/architecture/index.md`

```markdown
# Architecture Index

## System Shape

{one paragraph: current architecture}

## Major Modules

### {module-name}
- owns: {responsibility}
- interface: {what callers need to know}
- depends-on: {dependencies}
- warnings: {invariants / common wrong edits, or none}

## Runtime Boundaries

### {boundary-name}
- producer: {module/process}
- consumer: {module/process}
- contract: {doc or contract path}
```

## `docs/architecture/module-map.md`

```markdown
# Module Map

### {module-name}
- owns: {responsibility}
- interface: {public seams}
- tests: {test files or commands}
- context: {related docs/ADRs}
- do-not: {outdated patterns to avoid, or none}

## Cross-Module Flows

### {flow-name}
- steps: {module A -> module B -> module C}
- source-of-truth: {doc or contract}
```

(Monorepo: section the map by package under `## {package-name}` headings —
still one file.)

## `docs/harness/decision-routing.md` (split from index.md)

```markdown
# Decision Routing

Where decisions belong. Split out of `index.md`; the index links here.

| Decision type | Write/update | Escalate to ADR when |
|---|---|---|
| Product capability | {docs/product/ if track exists, else README/specs} | it changes product direction |
| Architecture / module design | docs/architecture/ | hard to reverse or surprising |
| API / schema / contract | {docs/contracts/ if track exists} | consumers depend on it |
| Data model / persistence | {docs/data-model/ if track exists} | usually |

ADR threshold: hard to reverse + surprising without context + real trade-off.
```

## `docs/harness/context-routing.md` (split from index.md)

```markdown
# Context Routing

What to read before touching an area. Split out of `index.md`; the index links here.

### {area/module}
- read-first: {path}
- also: {path}
- notes: {source of truth, invariants, warnings}
```

## Optional track indexes

Create a track only when real material for it exists (threshold rule). Each
follows the same shape — an index of facts with residences, not prose:

`docs/product/index.md` — capability / user value / status / related docs.
`docs/contracts/index.md` — contract / producer / consumer / stability / path.
`docs/ui/index.md` — flow or view / user goal / data dependencies / related docs.
`docs/agent-system/index.md` — agent or workflow / responsibility / knowledge sources / tools / contracts.
`docs/data-model/index.md` — concept / source of truth / consumers / invariants.
`docs/ops/index.md` — runtime concern / command or location / owner / warnings.

Use section-entry format (like the architecture files above), one `###` per
row-equivalent. When a track is created, add one row to the index.md Task
Routing "Read first" column where relevant — that is the only index.md change
a track addition makes.
````

- [ ] **Step 2: Verify and commit**

Run: `grep -c '^## ' extended-templates.md` — Expected: `9` (5 top-level sections + 4 `## ` headings inside code blocks).

```bash
git add extended-templates.md
git commit -m "feat(harness-skill): add extended topology templates (v2)"
```

---

### Task 4: Rewrite `SKILL.md`, delete v1 templates

**Files:**
- Modify: `skills/setup-codex-development-harness/SKILL.md` (full rewrite)
- Delete: `harness-docs-template.md`, `architecture-docs-template.md`, `work-ledger-template.md`, `agents-block-template.md`

- [ ] **Step 1: Replace SKILL.md with exactly this content**

````markdown
---
name: setup-codex-development-harness
description: Use when adopting an agent in a new or existing repo, when agents re-explore the codebase every session, when project state (done/doing/abandoned) is scattered or stale, or when an existing harness needs refresh or a drift check.
---

# Setup Codex Development Harness

Create or refresh a repo-local harness so agents start from a durable map
instead of re-exploring. The harness owns three layers — **state**
(`docs/work-ledger/`), **index + routing** (`docs/harness/index.md`), and a
**bootloader block** — and delegates the workflow layer to whatever process
system the environment has. Never duplicate content, never prescribe workflow.

## Doctrine

- Write-cost first: judge every addition by whether agents will keep it updated.
- One fact, one residence. A fact in two generated places is a bug.
- Detection over mandate: absorb existing systems; require none.
- Uncommitted memory is not memory.

## Mode Selection

- `codex-harness` markers anywhere in repo → **refresh mode**.
- Harness-shaped files (`docs/harness/`, `docs/work-ledger/`) without markers → **v1 migration** (refresh variant).
- Otherwise → **setup mode**.

## Setup Mode

### 1. Explore

Four detections (dispatch read-only subagents per area in large repos):

- **Structure** — source tree, build/test commands, module and runtime boundaries.
- **Docs** — classify every existing doc (spec, PRD, ADR, CONTEXT, dev logs,
  memory-bank-like) as source-of-truth / stale / historical. Staleness test:
  sample its concrete claims (module names, APIs, flows) against the code.
- **Environment** — available workflow skills *with their actual namespaces*;
  issue tracker (`docs/agents/` config or live GitHub issues); bootloaders
  (AGENTS.md / CLAUDE.md / GEMINI.md — which exist, whether they mirror each
  other, whether the mirrors have drifted).
- **History** — `git log` read for milestone-level events (backfill input).

### 2. Absorb

Classify each coexisting system; never rewrite a foreign system's content:

| Class | Example | Disposition |
|---|---|---|
| Orthogonal | workflow/process skills | compose into index.md Task Routing |
| Overlapping | old state notes in CLAUDE.md, memory-bank files | truth moves to harness; foreign file gets a one-line pointer — ask before editing any foreign file |
| Conflicting | a rival state system in active use | list the differences; the user decides which survives |

### 3. Propose

Present: detection summary, topology verdict (core, unless extended
thresholds already met), absorption dispositions, tracker variant
(see [ledger-conventions.md](ledger-conventions.md)). **Wait for approval
before writing anything.**

### 4. Write

Generate from [core-templates.md](core-templates.md) (plus
[extended-templates.md](extended-templates.md) only if extended was approved).
Every file gets the generated header. Backfill `completed.md` from git
milestones. Tracker present → ref-variant entries.

### 5. Bootloaders

The harness block lives in exactly **one** file — default `AGENTS.md`; if only
other bootloaders exist, ask which should host it; if none exist, ask which to
create. Every other bootloader gets the one-line pointer. Mirror drift between
bootloaders: warn in the final report, do not fix.

### 6. Validate

Hard gates — all must pass before reporting done:

- [ ] every path referenced in block and index exists
- [ ] exactly one harness block in the repo
- [ ] routing skill names resolve in this environment, or are written as generic fallbacks
- [ ] harness docs committed — commit harness paths only, never sweep unrelated dirty files

Report: created / refreshed / left for later / warnings (e.g. mirror drift).

## Topology

Two legal forms. Day-to-day agents append content inside existing files; only
this skill changes topology.

- **Core** (every repo starts here): bootloader block + `docs/harness/index.md`
  (all routing inline) + the four ledger files.
- **Extended** — upgrade only when: `index.md` > ~150 lines, or modules > 10,
  or ≥ 2 runtime boundaries, or real material exists for an optional track.
  A split **moves** the section and leaves a one-line pointer. Never copy.

## Refresh Mode

1. **Drift scan** — module-map vs actual tree; active entries vs recent git
   log (finished but still listed?); `Last verified` overdue (> 90 days);
   bootloader pointer liveness.
2. **Present drift summary. Wait for approval.**
3. **Execute** — patch only inside markers; archive roll-off per conventions;
   topology upgrade check; `completed.md` gap-fill from git log.

**v1 migration** (harness files, no markers): same flow; propose consolidating
all routing into `index.md`, slimming the bootloader block to the core
template, adding markers, and backfilling history. Anything not clearly
generated by v1 is user-authored — ask before touching.

## Edge Rules

| Case | Rule |
|---|---|
| Greenfield repo | core; ledger structurally complete but empty; `project-started` entry; no backfill |
| No git / shallow clone | skip backfill; mine existing docs for history; note the gap in the report |
| User content in generated files without markers | user-authored; ask before touching |
| Monorepo | one root harness; module-map sectioned by package; per-package harnesses out of scope |
| Dirty git state | commit harness paths only |
````

- [ ] **Step 2: Delete v1 template files**

```bash
git rm harness-docs-template.md architecture-docs-template.md work-ledger-template.md agents-block-template.md
```

- [ ] **Step 3: Verify**

Run: `wc -w SKILL.md` — Expected: < 800 words (body target ~500–700; hard fail > 800 → trim).
Run: `grep -n 'engineering:' SKILL.md core-templates.md extended-templates.md ledger-conventions.md` — Expected: no matches (no hardcoded namespaces).
Run: `grep -rn 'superpowers:' SKILL.md core-templates.md extended-templates.md` — Expected: no matches.

- [ ] **Step 4: Commit**

```bash
git add SKILL.md
git commit -m "feat(harness-skill): rewrite SKILL.md to v2 process, drop v1 templates"
```

---

### Task 5: Test scenario 1 — Greenfield (RED then GREEN)

**Files:**
- Create (fixture): `$CLAUDE_JOB_DIR/tmp/fixtures/greenfield/` (throwaway)

- [ ] **Step 1: Build fixture**

```bash
F=$CLAUDE_JOB_DIR/tmp/fixtures/greenfield && mkdir -p $F/src && cd $F && git init -q
printf 'def main():\n    print("hi")\n' > src/main.py
printf '# myproj\n' > README.md
git add -A && git commit -qm "init"
```

- [ ] **Step 2: RED — baseline subagent (no skill)**

Dispatch Agent (`subagent_type: general-purpose`, `model: "sonnet"`) with prompt:
"Work in `$CLAUDE_JOB_DIR/tmp/fixtures/greenfield`. Set up documentation so a
coding agent waking up in this repo immediately knows project state (done /
doing / not done) and how to navigate, without re-exploring. Do NOT invoke any
Skill tool — use your own judgment." Record verbatim: what files it creates,
whether it commits, whether it duplicates facts.

- [ ] **Step 3: GREEN — with-skill subagent**

Reset fixture (`git -C $F clean -fd && git -C $F checkout .`). Dispatch Agent
(`model: "sonnet"`) with prompt: "Work in `$CLAUDE_JOB_DIR/tmp/fixtures/greenfield`.
Follow the skill instructions in
`/Users/danny/codex-local-marketplace/plugins/engineering/skills/setup-codex-development-harness/SKILL.md`
to set up the development harness. The user request is: 'set up the agent
harness for this repo'. When the skill says wait for approval, state your
proposal and assume approval."

- [ ] **Step 4: Verify against checklist**

In fixture: exactly these generated — `AGENTS.md` block (≤ 15 lines inside
markers), `docs/harness/index.md`, 4 ledger files. NO `docs/architecture/`,
no optional tracks. `completed.md` has `project-started` entry. All files have
generated header. `git -C $F status --porcelain` clean (committed). Record any
deviation + the subagent's rationalization verbatim.

---

### Task 6: Test scenario 2 — Mature messy repo

**Files:**
- Create (fixture): `$CLAUDE_JOB_DIR/tmp/fixtures/mature/` (throwaway)

- [ ] **Step 1: Build fixture**

```bash
F=$CLAUDE_JOB_DIR/tmp/fixtures/mature && mkdir -p $F/{src/auth,src/billing,docs/agents,docs/adr} && cd $F && git init -q
printf 'class Auth: pass\n' > src/auth/core.py
printf 'class Billing: pass\n' > src/billing/core.py
printf '# Issue tracker\nGitHub Issues. Labels: bug, feature.\n' > docs/agents/issue-tracker.md
printf '# ADR 0001: monolith first\nAccepted.\n' > docs/adr/0001-monolith.md
printf '# Spec v1 (2025)\nThe `payments` module handles auth.\n' > docs/old-spec.md   # stale: wrong module name
printf '# myapp\n' > README.md && printf '## Notes\nCurrently rewriting billing.\n' > CLAUDE.md
git add -A && git commit -qm "milestone: auth module" && printf 'x' >> README.md && git commit -aqm "milestone: billing module"
```

- [ ] **Step 2: RED — baseline** (same baseline prompt as Task 5 Step 2, path swapped). Record verbatim.

- [ ] **Step 3: GREEN — with-skill** (same with-skill prompt as Task 5 Step 3, path swapped).

- [ ] **Step 4: Verify against checklist**

- Tracker detected → `active.md`/`follow-ups.md` use ref variant (no status fields).
- `docs/old-spec.md` classified stale (claim "payments handles auth" contradicts tree).
- `CLAUDE.md` "Currently rewriting billing" classified overlapping → proposal
  includes pointer + truth moved into `active.md`.
- `completed.md` backfilled with the two milestones.
- Proposal presented before any write.
- Record deviations + rationalizations verbatim.

---

### Task 7: Test scenario 3 — v1 migration (trading-advisor fixture)

**Files:**
- Create (fixture): copy, never the real repo

- [ ] **Step 1: Copy fixture**

```bash
cp -R ~/Desktop/GitHub/trading-advisor $CLAUDE_JOB_DIR/tmp/fixtures/migration
```

- [ ] **Step 2: With-skill subagent (no baseline — migration has no meaningful baseline)**

Dispatch Agent (`model: "sonnet"`), prompt: "Work in
`$CLAUDE_JOB_DIR/tmp/fixtures/migration`. Follow
`/Users/danny/codex-local-marketplace/plugins/engineering/skills/setup-codex-development-harness/SKILL.md`.
User request: 'refresh the development harness in this repo'. When the skill
says wait for approval, state the drift summary and assume approval."

- [ ] **Step 3: Verify against checklist**

- Mode detected: v1 migration (files without markers).
- Drift summary names: routing triplication (AGENTS block / index / routing
  files), dual bootloaders (CLAUDE.md missing harness), tracker dual-truth
  (GH issues vs ledger entries without refs), missing markers/dates,
  uncommitted harness, dead `engineering:*` skill names.
- Post-migration: routing lives only in index.md; AGENTS block slimmed to core
  template; CLAUDE.md got pointer line; markers everywhere; ledger entries
  demoted to ref variant; harness committed.
- User-authored regions (e.g. optional track content) preserved byte-for-byte
  or changes were asked about.
- Record deviations + rationalizations verbatim.

---

### Task 8: REFACTOR — fold failures back into the skill

- [ ] **Step 1: Collect every deviation/rationalization** from Tasks 5–7 recordings.

- [ ] **Step 2: For each, add a targeted counter to SKILL.md** — a row in Edge
Rules, a sharpened hard gate, or an explicit "do not" line at the point of
failure. No counters needed if all scenarios passed clean.

- [ ] **Step 3: Re-run only the scenarios that failed** (same prompts) until clean.

- [ ] **Step 4: Final verify + commit**

Run: `wc -w SKILL.md` — Expected: still < 800.

```bash
git add SKILL.md && git commit -m "fix(harness-skill): close loopholes found in subagent testing"
rm -rf $CLAUDE_JOB_DIR/tmp/fixtures
```

- [ ] **Step 5: Update plan checkboxes, report results** — scenarios run, pass/fail per checklist item, counters added.
