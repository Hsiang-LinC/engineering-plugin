# Symphony Orchestration Skill — Design

Date: 2026-06-13
Status: approved (brainstorming), pending implementation plan

## Purpose

Eliminate the slow manual setup of an autonomous Symphony pipeline in each new
repo. trading-advisor's `symphony/` is a heavily-extended Symphony (review,
accept, janitor, reconcile — automation upstream `openai/symphony` lacks).
Re-creating that by hand per repo is the slow path. This design extracts the
engine into a reusable package and adds a skill that generates the per-repo
wiring from the existing harness contract.

For whom: a developer who already runs `setup-codex-development-harness` in a
repo and wants the orchestration layer (scheduler + spec→implement→review→merge
pipeline) stood up without re-deriving it.

## Boundary decisions (settled in brainstorming)

- **Tracker scope:** mixed/pluggable. Engine gets a tracker-client factory keyed
  on `tracker.kind`. Linear ships. GitHub is a documented extension point —
  **not built** (YAGNI on the client; the seam stays open).
- **Package home:** standalone GitHub repo, `git+url` pip install. Engine fully
  decoupled from trading-advisor. Optionally a license-fork of `openai/symphony`
  for attribution; no plan to merge upstream (divergence too large to be worth it).
- **Harness dependency:** hard prerequisite. `docs/harness/tracker.md` must
  exist; missing → stop and tell the user to run the harness skill. Tracker
  identity is always derived from `tracker.md`, never re-asked
  (one-fact-one-residence).
- **Automation reach:** generate + install + verify. The skill stops before any
  side effect on the live tracker or the machine. Tracker state provisioning
  (`symphony tracker states ensure`) and daemon autostart (launchd) are **printed
  manual follow-ups**, not auto-run.
- **Derivation mechanism (Approach C — extract-then-confirm):** the skill parses
  `tracker.md` heuristically to *propose* the WORKFLOW.md YAML, then shows it and
  waits for user confirmation before writing. Matches the harness's own
  propose-then-write doctrine; keeps `tracker.md` format untouched (no
  orchestrator-shaped data added to the harness); fails loud instead of silent on
  the state names that drive every dispatch.

### Approaches considered for the derivation mechanism

- **A — heuristic prose parsing, no confirm.** Rejected: brittle mis-maps land
  silently in tracker config, the worst place.
- **B — machine-readable block in `tracker.md`.** Rejected: couples the harness
  format to this skill; the harness would carry orchestrator-shaped data, cutting
  against "harness never generates orchestrator config."
- **C — extract-then-confirm.** Chosen (see above).

## Architecture

Three artifacts, three homes, one source of truth (`docs/harness/tracker.md`).

```
codex-symphony (standalone GitHub repo, git+url install)
  engine: symphony/*.py (2724 lines, 20 files) + symphony/tracker/
  default prompt templates: templates/implement.md.j2, templates/review.md.j2
  tracker-client factory (kind -> client); Linear shipped, GitHub = extension point
        ^ pip install git+url
        |
setup-symphony-orchestration (engineering plugin, beside setup-codex-development-harness)
  reads  docs/harness/tracker.md (+ index.md for prompt context)
  writes WORKFLOW.md, REVIEW.md, .env stub, .gitignore patch
  installs the package, verifies config loads
  prints (does NOT run) state-provision + daemon steps
        | generates
        v
target repo
  WORKFLOW.md, REVIEW.md, .env (per-repo config, editable in-repo)
  .symphony/ (state + runtime, gitignored)
  matched-to-tracker.md by construction
```

The skill never holds tracker facts (derives them from `tracker.md` each run and
confirms). The engine never holds repo facts (reads WORKFLOW.md at runtime).

## Component 1 — `codex-symphony` package

**Moves out of trading-advisor verbatim:** all of `symphony/*.py` and
`symphony/tracker/` (20 files, 2724 lines). No logic changes except the factory
seam below.

**Added:**
- `pyproject.toml` — package metadata; deps: pydantic, jinja2, pyyaml,
  python-dotenv, plus the LinearClient HTTP dependency; `symphony` console
  entry-point.
- `templates/implement.md.j2`, `templates/review.md.j2` — default prompt
  templates, harness-aware (reference AGENTS.md / tracker.md / index.md
  directly — safe because the consuming skill makes the harness a hard prereq),
  with one clearly-marked `repo-specific rules` placeholder.
- `README.md`.

**The one code change — tracker factory** (delivers the mixed/pluggable answer):

```python
# config.py — was: if tracker.kind != "linear": raise SymphonyError(...)
# now: validated against a registry
TRACKER_CLIENTS = {"linear": LinearClient}   # GitHubClient: documented, not built

def make_tracker(cfg: TrackerConfig) -> Tracker:
    client = TRACKER_CLIENTS.get(cfg.kind)
    if client is None:
        raise SymphonyError(
            "unsupported_tracker_kind",
            f"codex-symphony has no client for kind '{cfg.kind}'. "
            f"Implement the Tracker Protocol (orchestrator.py) and register it.",
        )
    return client(...)

# orchestrator.py:291 — was: tracker or LinearClient(...)
# now: tracker or make_tracker(config.tracker)
```

The `Tracker` Protocol (orchestrator.py:19) already exists; this routes `kind` →
client instead of hard-rejecting. ~15 lines. GitHubClient is **not** in scope;
only the open seam is.

**Public surface** (what the skill and repos depend on):
- the `symphony` CLI: `run`, `daemon`, `review`, `accept`, `reconcile-applied`,
  `reconcile-claim`, `request-changes`, `tracker states ensure`, and a new thin
  `validate` (loads WORKFLOW.md via `load_config`, no live tracker call — the
  skill's verify step)
- `load_workflow` / `load_config`

Everything else is package-internal.

**Stays in the target repo, never the package:** WORKFLOW.md, REVIEW.md, `.env`,
`.symphony/` state.

## Component 2 — `setup-symphony-orchestration` skill

**Hard gates (stop if either fails):**
1. `docs/harness/tracker.md` missing → stop: "run `setup-codex-development-harness`
   first."
2. `tracker.md` § Identity `kind` not in the engine registry (i.e. not `linear`)
   → stop: "codex-symphony speaks Linear only today; implement a Tracker-Protocol
   client for `<kind>` first." (Mixed-tracker answer enforced at the boundary —
   fail loud, name the extension point.)

**Process:**
1. **Explore** — read `tracker.md` (State Machine, Labels, Dispatch Eligibility,
   Completion Evidence), `index.md` (Work Production + Task Routing, for prompt
   context); detect the codex CLI command and verification commands (§ Completion
   Evidence / quality-gates).
2. **Extract** — build proposed WORKFLOW.md YAML:
   - State Machine rows → `active_states`, `terminal_states`, `running_state`,
     `agent_review_state`, `human_review_state`, `blocked_state`, `done_state`
   - dispatch/actor label → `required_labels`
   - Dispatch Eligibility work-item rule → `require_work_item_format`
   - verification commands → `accept.verification_commands`
3. **Confirm** — show the extracted YAML; wait for approval/correction (Approach C).
4. **Write** — WORKFLOW.md (confirmed front-matter + harness-aware implement
   prompt from `templates/implement.md.j2`), REVIEW.md (from
   `templates/review.md.j2`), `.env` stub (`LINEAR_API_KEY=`), `.gitignore` patch
   (`.symphony/`, `.env`).
5. **Install** — `pip install git+https://…/codex-symphony` into the repo venv.
6. **Verify** — `symphony validate` (loads WORKFLOW.md via `load_config`; config
   parses + validates); **no live tracker call.**
7. **Report** — print, do **not** run: set `LINEAR_API_KEY`,
   `symphony tracker states ensure` (provision Linear states), launchd/daemon
   start.

**Outputs:** WORKFLOW.md, REVIEW.md, `.env` stub, `.gitignore` patch.

**Never:** writes tracker facts anywhere but as a consumer of `tracker.md`; never
touches the live tracker; never starts the daemon.

## Data flow

```
tracker.md --parse--> proposed WORKFLOW.md YAML --confirm(user)--> render templates
  --> write WORKFLOW/REVIEW/.env/.gitignore --> pip install codex-symphony
  --> load_config(WORKFLOW.md) validates --> report manual follow-ups
```

One direction, one source of truth. Tracker facts flow `tracker.md → WORKFLOW.md`
only — never back, never invented.

## Edge cases

| Case | Rule |
|---|---|
| No `tracker.md` | stop (hard gate 1) |
| `kind` != linear | stop, name extension point (hard gate 2) |
| Codex command undetectable | use engine default, note it |
| Verification commands undetectable | leave `accept.verification_commands: []` + note |
| Re-run (WORKFLOW.md exists) | refresh: re-extract, diff vs existing, confirm only changes; never clobber edited prompt bodies or the repo-specific block |
| `.env` already has key | do not overwrite |
| pip install fails (offline/no venv) | report, leave generated files in place — setup resumable |
| Live tracker drifted from `tracker.md` | out of scope — skill reads `tracker.md`, not live; provisioning is a printed manual step |

## Relationship to the harness

This skill is the counterpart the harness deliberately omits. The harness
"never generates orchestrator config"; this skill is the thing that does, living
outside the harness and consuming its `tracker.md`. Because config is generated
from `tracker.md`, consistency holds by construction at setup; the harness
refresh-mode "orchestrator consistency" check then degrades to a drift detector
for later manual edits. The two halves share a source of truth (`tracker.md`),
not a representation.

## Testing

- **Engine:** trading-advisor's `tests/test_symphony_*` move with the package.
  New unit test for the factory seam: unknown `kind` → clear error; `linear` →
  `LinearClient`.
- **Skill:** clean-room fixture tests (same method as the harness skill).
  - Greenfield repo + Linear `tracker.md` → run skill → assert WORKFLOW.md YAML
    matches `tracker.md` states/labels, REVIEW.md present, config validates.
  - Negative: no `tracker.md` → stops; GitHub `tracker.md` → stops with
    extension-point message.
  - Idempotence: second run yields no spurious diff.

## Explicitly out of scope (YAGNI)

- **Sandcastle integration.** trading-advisor's `workspace.py` + `CodexRunner`
  already fill the execution layer for solo/local/trusted/single-host operation.
  Sandcastle only earns its place at thresholds not yet hit (true container
  isolation for parallelism, remote execution, untrusted code). Revisit then.
- **N declarative pipeline stages (Sandcastle `.sandcastle` style).** The pipeline
  has two agent stages (implement, review); plan is human+skills pre-dispatch and
  merge is deterministic `accept_candidate` — correctly non-agent. Generalizing
  the hardcoded 2 cycles to N declarative stages is engine work to revisit only
  when a concrete third agent stage appears.
- **GitHubClient (and any non-Linear tracker client).** The factory seam stays
  open; the client is not built until a non-Linear repo needs it.

## Build sequence (for the implementation plan)

1. Extract `codex-symphony` package from trading-advisor `symphony/` (+ pyproject,
   templates, README); add the tracker-factory seam and the thin `validate`
   command; move tests; publish repo.
2. Author `setup-symphony-orchestration` skill in the engineering plugin
   (hard gates, extract-then-confirm, generate, install, verify, report).
3. Clean-room fixture tests for the skill; factory unit test for the engine.

Package extraction is load-bearing and first — the skill is useless without a
package to install.
