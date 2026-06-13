# Symphony Orchestration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extract trading-advisor's extended Symphony engine into a standalone git-installable package, then add a harness-consuming skill that generates per-repo Symphony config from `docs/harness/tracker.md`.

**Architecture:** Two phases in two repos. Phase 1 lifts `symphony/` (2724 lines) out of trading-advisor into a new `codex-symphony` repo, adds a tracker-client factory seam and a thin `validate` command, and ships default prompt templates. Phase 2 authors `setup-symphony-orchestration` in the engineering plugin: it reads `tracker.md`, proposes WORKFLOW.md config (extract-then-confirm), writes the per-repo files, installs the package, and verifies. Tracker facts flow `tracker.md → WORKFLOW.md` only.

**Tech Stack:** Python 3.10+, pydantic v2, Jinja2, PyYAML, python-dotenv, requests; pytest. The skill is a markdown `SKILL.md` with clean-room fixture tests (same method as `setup-codex-development-harness`).

**Spec:** `docs/superpowers/specs/2026-06-13-symphony-orchestration-skill-design.md`

**Convention used throughout:** `PACKAGE_GIT_URL` = the GitHub URL of the repo created in Task 1.1 (e.g. `https://github.com/<you>/codex-symphony`). `CODEX_SYMPHONY_DIR` = the local checkout path of that repo. `TA_DIR` = `~/Desktop/GitHub/trading-advisor` (the extraction source).

---

## Phase 1 — `codex-symphony` package

### Task 1.1: Create the package repo and lift the engine

**Files:**
- Create: `$CODEX_SYMPHONY_DIR/` (new git repo)
- Copy: `$TA_DIR/symphony/*.py` + `$TA_DIR/symphony/tracker/` → `$CODEX_SYMPHONY_DIR/symphony/`
- Copy: 19 `$TA_DIR/tests/test_symphony_*.py` → `$CODEX_SYMPHONY_DIR/tests/`

- [ ] **Step 1: Create and init the repo**

```bash
mkdir -p "$CODEX_SYMPHONY_DIR" && cd "$CODEX_SYMPHONY_DIR" && git init
mkdir -p symphony tests
```

- [ ] **Step 2: Copy the engine verbatim (no edits yet)**

```bash
cp "$TA_DIR"/symphony/*.py symphony/
cp -R "$TA_DIR"/symphony/tracker symphony/tracker
cp "$TA_DIR"/tests/test_symphony_*.py tests/
```

- [ ] **Step 3: Confirm the file inventory**

Run: `ls symphony/ symphony/tracker/ tests/ | sort`
Expected: 20 engine `.py` files (incl. `__init__.py`, `orchestrator.py`, `reviewer.py`, `acceptance.py`, `janitor.py`, `reconciliation.py`, `config.py`, `cli.py`, `workflow.py`, `workspace.py`, `daemon.py`, `launchd.py`, `models.py`, `state.py`, `review.py`, `review_actions.py`, `codex.py`, `issue_template.py`, `errors.py`, `logging.py`); `tracker/` has `__init__.py`, `linear.py`, `states.py`; `tests/` has 19 `test_symphony_*.py`.

- [ ] **Step 4: Commit the lift**

```bash
git add symphony tests
git commit -m "chore: lift Symphony engine + tests from trading-advisor verbatim"
```

---

### Task 1.2: Package metadata (pyproject.toml)

**Files:**
- Create: `$CODEX_SYMPHONY_DIR/pyproject.toml`

- [ ] **Step 1: Write pyproject.toml**

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "codex-symphony"
version = "0.1.0"
description = "Issue-tracker-driven coding-agent orchestration engine (scheduler + review/accept/janitor/reconcile)"
readme = "README.md"
license = {text = "MIT"}
requires-python = ">=3.10"
dependencies = [
    "pydantic>=2.0",
    "PyYAML>=6.0",
    "Jinja2>=3.1",
    "python-dotenv>=1.0",
    "requests>=2.31",
]

[project.scripts]
symphony = "symphony.cli:main"

[tool.hatch.build.targets.wheel]
packages = ["symphony"]

[tool.hatch.build.targets.wheel.force-include]
"templates" = "symphony/_templates"

[project.optional-dependencies]
test = ["pytest>=8"]

[tool.pytest.ini_options]
testpaths  = ["tests"]
pythonpath = ["."]
```

- [ ] **Step 2: Create a venv and install editable with test extras**

Run:
```bash
cd "$CODEX_SYMPHONY_DIR" && python3 -m venv .venv
.venv/bin/pip install -e '.[test]'
```
Expected: `Successfully installed codex-symphony-0.1.0 …` (pydantic, PyYAML, Jinja2, python-dotenv, requests resolved).

Note: the `templates/` dir referenced by `force-include` does not exist until
Task 1.6. Editable installs (`-e`) symlink the source tree and do not run the
wheel `force-include` step, so this install succeeds without it. Only a real
wheel build (`hatch build`) needs `templates/` present — do that after Task 1.6.

- [ ] **Step 3: Confirm the console entry point resolves**

Run: `.venv/bin/symphony --help`
Expected: usage text listing subcommands (`run`, `daemon`, `review`, `accept`, `reconcile-applied`, `reconcile-claim`, `request-changes`, `tracker`). (`validate` is added in Task 1.4.)

- [ ] **Step 4: Commit**

```bash
git add pyproject.toml
git commit -m "build: add codex-symphony package metadata"
```

---

### Task 1.3: Tracker-client factory seam

Replaces the Linear-only hard reject with a registry, so `tracker.kind` routes to a client. Linear ships; unknown kinds raise a clear "implement the Protocol" error. GitHubClient is NOT built.

**Files:**
- Create: `$CODEX_SYMPHONY_DIR/symphony/tracker/factory.py`
- Create: `$CODEX_SYMPHONY_DIR/tests/test_symphony_tracker_factory.py`
- Modify: `$CODEX_SYMPHONY_DIR/symphony/config.py` (the `kind != "linear"` check, ~line 98)
- Modify: `$CODEX_SYMPHONY_DIR/symphony/orchestrator.py` (the `tracker or LinearClient(...)` default, ~line 291)

- [ ] **Step 1: Write the failing test**

```python
# tests/test_symphony_tracker_factory.py
import pytest

from symphony.errors import SymphonyError
from symphony.tracker.factory import SUPPORTED_KINDS, make_tracker
from symphony.tracker.linear import LinearClient


class _Cfg:
    kind = "linear"
    endpoint = "https://api.linear.app/graphql"
    api_key = "key"
    project_slug = "proj"


def test_linear_kind_builds_linear_client():
    client = make_tracker(_Cfg())
    assert isinstance(client, LinearClient)


def test_unknown_kind_raises_clear_error():
    cfg = _Cfg()
    cfg.kind = "github"
    with pytest.raises(SymphonyError) as exc:
        make_tracker(cfg)
    assert exc.value.code == "unsupported_tracker_kind"
    assert "github" in exc.value.message


def test_supported_kinds_is_linear_only():
    assert set(SUPPORTED_KINDS) == {"linear"}
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.venv/bin/pytest tests/test_symphony_tracker_factory.py -v`
Expected: FAIL — `ModuleNotFoundError: No module named 'symphony.tracker.factory'`.

- [ ] **Step 3: Write the factory**

```python
# symphony/tracker/factory.py
from __future__ import annotations

from typing import Callable

from ..errors import SymphonyError
from .linear import LinearClient

# kind -> builder. GitHub and others are intentionally absent: the seam is
# open, the client is not built (see design § out of scope).
TRACKER_CLIENTS: dict[str, Callable[[object], object]] = {
    "linear": lambda cfg: LinearClient(
        endpoint=cfg.endpoint, api_key=cfg.api_key, project_slug=cfg.project_slug
    ),
}

SUPPORTED_KINDS = tuple(TRACKER_CLIENTS)


def make_tracker(cfg: object) -> object:
    builder = TRACKER_CLIENTS.get(getattr(cfg, "kind", None))
    if builder is None:
        raise SymphonyError(
            "unsupported_tracker_kind",
            f"codex-symphony has no client for kind '{getattr(cfg, 'kind', None)}'. "
            "Implement the Tracker Protocol (see orchestrator.py) and register it "
            "in symphony/tracker/factory.py.",
        )
    return builder(cfg)
```

- [ ] **Step 4: Run the factory test to verify it passes**

Run: `.venv/bin/pytest tests/test_symphony_tracker_factory.py -v`
Expected: PASS (3 tests).

- [ ] **Step 5: Route config validation through the registry**

In `symphony/config.py`, replace the Linear-only guard (currently around line 98):

```python
# OLD:
#     if tracker.kind != "linear":
#         raise SymphonyError("unsupported_tracker_kind", f"Unsupported tracker.kind: {tracker.kind}")
# NEW:
from .tracker.factory import SUPPORTED_KINDS

if tracker.kind not in SUPPORTED_KINDS:
    raise SymphonyError(
        "unsupported_tracker_kind",
        f"Unsupported tracker.kind: {tracker.kind}. Supported: {', '.join(SUPPORTED_KINDS)}.",
    )
```

(Keep the existing Linear-specific `api_key` / `project_slug` required-field checks that follow — they are correct while Linear is the only kind.)

- [ ] **Step 6: Route orchestrator instantiation through the factory**

In `symphony/orchestrator.py`, change the default tracker construction (currently around line 291):

```python
# OLD:
#     tracker = tracker or LinearClient(
#         endpoint=config.tracker.endpoint,
#         api_key=config.tracker.api_key,
#         project_slug=config.tracker.project_slug,
#     )
# NEW:
from .tracker.factory import make_tracker

tracker = tracker or make_tracker(config.tracker)
```

Remove the now-unused `from .tracker.linear import LinearClient` import in orchestrator.py if nothing else uses it (grep first: `grep -n LinearClient symphony/orchestrator.py`).

- [ ] **Step 7: Run the config + orchestrator tests to verify no regression**

Run: `.venv/bin/pytest tests/test_symphony_config.py tests/test_symphony_orchestrator.py -v`
Expected: PASS (existing behavior preserved; Linear still the resolved client).

- [ ] **Step 8: Commit**

```bash
git add symphony/tracker/factory.py tests/test_symphony_tracker_factory.py symphony/config.py symphony/orchestrator.py
git commit -m "feat: tracker-client factory seam (linear shipped, others as extension point)"
```

---

### Task 1.4: Thin `validate` command

A no-side-effect command that loads WORKFLOW.md through the engine and reports OK/error. This is the skill's verify step (Phase 2). No live tracker call.

**Files:**
- Create: `$CODEX_SYMPHONY_DIR/tests/test_symphony_cli_validate.py`
- Modify: `$CODEX_SYMPHONY_DIR/symphony/cli.py` (add subparser + handler)

- [ ] **Step 1: Write the failing test**

```python
# tests/test_symphony_cli_validate.py
from pathlib import Path

from symphony.cli import main

GOOD_WORKFLOW = """---
tracker:
  kind: linear
  api_key: test-key
  project_slug: demo-proj
  active_states: [Todo]
  terminal_states: [Done, Canceled]
  running_state: In Progress
  agent_review_state: Agent Review
  human_review_state: Human Review
  blocked_state: Blocked
  done_state: Done
workspace:
  root: .symphony/workspaces
review:
  enabled: true
  prompt_path: REVIEW.md
---
You are a worker for {{ issue.identifier }}.
"""


def test_validate_ok(tmp_path, capsys, monkeypatch):
    wf = tmp_path / "WORKFLOW.md"
    wf.write_text(GOOD_WORKFLOW, encoding="utf-8")
    monkeypatch.setenv("LINEAR_API_KEY", "test-key")
    rc = main(["validate", "--workflow", str(wf)])
    assert rc == 0
    assert "OK" in capsys.readouterr().out


def test_validate_reports_error_on_bad_config(tmp_path, capsys, monkeypatch):
    wf = tmp_path / "WORKFLOW.md"
    wf.write_text("---\ntracker:\n  kind: linear\n---\nbody", encoding="utf-8")
    monkeypatch.delenv("LINEAR_API_KEY", raising=False)
    rc = main(["validate", "--workflow", str(wf)])
    assert rc != 0
    assert "error" in capsys.readouterr().out.lower()
```

- [ ] **Step 2: Run it to verify it fails**

Run: `.venv/bin/pytest tests/test_symphony_cli_validate.py -v`
Expected: FAIL — `validate` is not a known subcommand (argparse `SystemExit` / unknown command).

- [ ] **Step 3: Add the `validate` subparser and handler in cli.py**

Add a subparser alongside the existing ones (follow the existing `sub.add_parser(...)` pattern near the top of `build_parser`/`main`):

```python
# in the parser-building section:
validate_cmd = sub.add_parser("validate")
validate_cmd.add_argument("--workflow", default="WORKFLOW.md")
```

Add the dispatch branch where the other commands are handled:

```python
# in the command dispatch section of main():
if args.command == "validate":
    from .workflow import load_workflow
    from .config import load_config
    try:
        wf = load_workflow(args.workflow)
        load_config(wf, workflow_path=args.workflow)
    except SymphonyError as exc:
        print(f"error: {exc.code}: {exc.message}")
        return 1
    print("OK: WORKFLOW.md is valid")
    return 0
```

Ensure `main()` returns the int return code (the existing `main` already returns codes for other commands; match that contract). If `main` currently returns `None` for success, make `validate` explicit as above and confirm the test's `rc` assertions hold.

**Signature check:** the test calls `main(["validate", ...])` — i.e. `main` must
accept an `argv` list. Open `tests/test_symphony_cli.py` first and match however
it already invokes `main` (existing CLI tests prove the supported call shape). If
`main` is `def main(argv=None)`, the test above works as written; if the existing
tests use a different entry (e.g. a helper that builds the parser), mirror that
convention instead of assuming `main(argv)`.

- [ ] **Step 4: Run the validate test to verify it passes**

Run: `.venv/bin/pytest tests/test_symphony_cli_validate.py -v`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add symphony/cli.py tests/test_symphony_cli_validate.py
git commit -m "feat: add thin 'symphony validate' command (loads WORKFLOW.md, no tracker call)"
```

---

### Task 1.5: Full suite green after extraction

**Files:** none (verification only)

- [ ] **Step 1: Run the entire test suite**

Run: `.venv/bin/pytest -q`
Expected: all tests pass. If any `test_symphony_*` test imports `trading_advisor`-specific paths or `shim/`, that is a leak from extraction — fix the import to the package-local path and note it in the commit.

- [ ] **Step 2: Commit any extraction fixups**

```bash
git add -A
git commit -m "test: green the extracted suite under codex-symphony" || echo "nothing to fix"
```

---

### Task 1.6: Default prompt templates

Ship harness-aware implement/review prompt templates the skill copies into target repos. Derived from trading-advisor's WORKFLOW.md body and REVIEW.md, with repo-specific lines turned into a marked placeholder.

**Files:**
- Create: `$CODEX_SYMPHONY_DIR/templates/implement.md.j2`
- Create: `$CODEX_SYMPHONY_DIR/templates/review.md.j2`

- [ ] **Step 1: Write templates/implement.md.j2**

```jinja
You are a Codex worker for {{ project_name }}.

Issue:
- Identifier: {{ issue.identifier }}
- Title: {{ issue.title }}
- State: {{ issue.state }}
- URL: {{ issue.url }}
- Attempt: {{ attempt }}

Issue body:
{% if issue.description %}{{ issue.description }}{% else %}No issue description provided.{% endif %}

Before editing:
1. Read `AGENTS.md`.
2. Read `docs/harness/tracker.md`.
3. Read `docs/harness/index.md`.
4. Route the task through the Task Routing table in `docs/harness/index.md`.
5. Treat the embedded issue fields above as the assigned tracker issue context.

Development rules:
- Do not call tracker tools from this worker. Symphony owns operational
  tracker lifecycle writes (comments, state transitions, review/accept/
  request-changes, reconciliation). If a needed lifecycle op is unsupported,
  report it as a follow-up instead of using tracker tools directly.
- Do not update `docs/work-ledger/` as an active tracker; it is historical.
- Update repository docs only when durable architecture, contract, plan,
  quality-gate, or domain facts change.
- Worker changes are candidate changes until Symphony accept applies them to
  main, verifies, commits, comments, and moves the issue to Done.
- Keep changes scoped to the issue.
- Prefer tests at the narrowest durable boundary; run targeted tests before
  reporting completion.

<!-- REPO-SPECIFIC RULES: the setup skill leaves this block for the user.
     e.g. "Keep Symphony separate from shim/." Edit or delete. -->

Return a stdout report for Symphony to post as the completion comment:
- Changed files
- Verification commands and outcomes
- Remaining risks or follow-up issue suggestions
```

- [ ] **Step 2: Write templates/review.md.j2**

```jinja
You are a Symphony reviewer agent for {{ project_name }}. You are NOT the author
of this candidate — judge it against the issue's acceptance criteria. Symphony
executes your verdict; you only decide.

Issue:
- Identifier: {{ issue.identifier }}
- Title: {{ issue.title }}
- State: {{ issue.state }}
- URL: {{ issue.url }}

Issue body:
{% if issue.description %}{{ issue.description }}{% else %}No issue description provided.{% endif %}

Candidate under review:
- Changed files:
{% for file in artifact.changed_files %}  - {{ file }}
{% endfor %}- Worker status: {{ artifact.worker_status }}
- Worker report:
{{ artifact.worker_report }}

Review steps:
1. Read `AGENTS.md`, `docs/harness/tracker.md`, and the repo's quality gates.
2. Inspect the candidate in this workspace: `git diff HEAD` shows the change.
3. Check the change against the issue's acceptance criteria, line by line.
4. Run the issue's verification commands when the environment allows. If the
   environment cannot run them, that is an environment failure, not a candidate
   failure — use `block`, not `escalate`.
5. Do not modify files. Do not call tracker tools — Symphony executes your verdict.

End your report with exactly one verdict line (and a reason line for anything
other than accept):

- `VERDICT: accept` — satisfies acceptance criteria and verification.
- `VERDICT: request-changes` then `REASON: <actionable feedback>` — needs rework.
- `VERDICT: block` then `REASON: <external/environment cause>` — cannot be judged.
- `VERDICT: escalate` then `REASON: <why human judgment is needed>` — risky/ambiguous.
```

- [ ] **Step 3: Confirm templates render with a dummy context**

Run:
```bash
.venv/bin/python -c "
from jinja2 import Environment, StrictUndefined
env = Environment(undefined=StrictUndefined, autoescape=False)
ctx = {'project_name':'Demo','attempt':1,
       'issue':{'identifier':'D-1','title':'t','state':'Todo','url':'u','description':'d'},
       'artifact':{'changed_files':['a.py'],'worker_status':'succeeded','worker_report':'r'}}
for f in ['templates/implement.md.j2','templates/review.md.j2']:
    env.from_string(open(f).read()).render(**ctx); print('rendered', f)
"
```
Expected: `rendered templates/implement.md.j2` and `rendered templates/review.md.j2` (no `UndefinedError`).

- [ ] **Step 4: Commit**

```bash
git add templates/
git commit -m "feat: ship harness-aware implement/review prompt templates"
```

---

### Task 1.7: README and publish

**Files:**
- Create: `$CODEX_SYMPHONY_DIR/README.md`
- Create: `$CODEX_SYMPHONY_DIR/LICENSE` (MIT; preserve openai/symphony attribution if forked)

- [ ] **Step 1: Write a README** covering: what it is (tracker-driven coding-agent orchestrator), install (`pip install git+PACKAGE_GIT_URL`), the WORKFLOW.md/REVIEW.md/.env contract, the `symphony` CLI surface (incl. `validate`), and that per-repo config is generated by the `setup-symphony-orchestration` skill.

- [ ] **Step 2: Push to GitHub**

```bash
cd "$CODEX_SYMPHONY_DIR"
git add README.md LICENSE && git commit -m "docs: README + LICENSE"
gh repo create codex-symphony --public --source=. --remote=origin --push
```
Record the resulting URL as `PACKAGE_GIT_URL` for Phase 2.

- [ ] **Step 3: Verify a clean install from the URL**

Run (in a throwaway venv):
```bash
python3 -m venv /tmp/cs-check && /tmp/cs-check/bin/pip install "git+$PACKAGE_GIT_URL"
/tmp/cs-check/bin/symphony --help
```
Expected: install succeeds; `--help` lists subcommands including `validate`.

---

## Phase 2 — `setup-symphony-orchestration` skill

The skill is a prompt-driven `SKILL.md` (like `setup-codex-development-harness`), not Python. Its "tests" are clean-room fixtures executed by a subagent against throwaway repos.

### Task 2.1: Skill scaffold + frontmatter

**Files:**
- Create: `plugins/engineering/skills/setup-symphony-orchestration/SKILL.md`

(Paths below are relative to the engineering plugin repo: `/Users/danny/codex-local-marketplace/plugins/engineering`.)

- [ ] **Step 1: Write the frontmatter + intro**

```markdown
---
name: setup-symphony-orchestration
description: Use after setup-codex-development-harness when a repo should run autonomous Symphony orchestration. Reads docs/harness/tracker.md and generates the per-repo Symphony config (WORKFLOW.md, REVIEW.md, .env stub), installs the codex-symphony engine, and verifies the config loads. Linear trackers only today; stops with a clear message for other tracker kinds. Does not touch the live tracker or start the daemon — prints those as manual follow-ups.
---

# Setup Symphony Orchestration

Stand up the autonomous orchestration layer on top of an existing development
harness. The harness owns the tracker contract (`docs/harness/tracker.md`); this
skill is the counterpart it deliberately omits — it generates the orchestrator
config *from* that contract, so the two stay consistent by construction.

Engine: the `codex-symphony` package (installed from git). This skill never
holds tracker facts — it derives them from `tracker.md` and confirms with you.

Prompt-driven, not a script: explore, propose, confirm, then write.
```

- [ ] **Step 2: Commit**

```bash
git add skills/setup-symphony-orchestration/SKILL.md
git commit -m "feat(symphony-skill): scaffold setup-symphony-orchestration frontmatter"
```

---

### Task 2.2: Hard gates + Explore section

**Files:**
- Modify: `skills/setup-symphony-orchestration/SKILL.md`

- [ ] **Step 1: Append the gates + Explore section**

````markdown
## Hard gates

Stop immediately (do not write anything) if either fails:

1. **No harness.** `docs/harness/tracker.md` does not exist →
   > "This repo has no development harness. Run `setup-codex-development-harness`
   > first, then re-run this skill."
2. **Unsupported tracker.** `tracker.md` § Identity `kind` is not `linear` →
   > "codex-symphony speaks Linear only today. Your harness tracker is
   > `<kind>`. Implement a Tracker-Protocol client for `<kind>` in
   > codex-symphony (`symphony/tracker/factory.py`) before orchestrating this
   > repo."

## 1. Explore

Read, do not assume:

- `docs/harness/tracker.md` — § Identity (kind, project), § State Machine (every
  state name + which is running/agent-review/human-review/blocked/done/terminal/
  active), § Labels (the dispatch/actor label), § Dispatch Eligibility (whether a
  work-item-format rule applies), § Completion Evidence (verification commands).
- `docs/harness/index.md` — Work Production + Task Routing, for prompt context.
- existing `WORKFLOW.md` — if present, this is a re-run (refresh, see Edge cases).
- the codex CLI command in use (from harness docs or `.codex/config.toml`); fall
  back to the engine default `codex --ask-for-approval never exec --sandbox workspace-write -`.
````

- [ ] **Step 2: Commit**

```bash
git add skills/setup-symphony-orchestration/SKILL.md
git commit -m "feat(symphony-skill): hard gates + Explore section"
```

---

### Task 2.3: Extract + Confirm section (Approach C)

**Files:**
- Modify: `skills/setup-symphony-orchestration/SKILL.md`

- [ ] **Step 1: Append the Extract + Confirm section**

````markdown
## 2. Extract (propose config)

Build the proposed WORKFLOW.md front-matter YAML from `tracker.md`. Map:

| tracker.md source | WORKFLOW.md key |
|---|---|
| § State Machine: active state(s) | `active_states` |
| § State Machine: terminal states | `terminal_states` |
| § State Machine: running state | `running_state` |
| § State Machine: agent-review state | `agent_review_state` |
| § State Machine: human-review/escalation state | `human_review_state` |
| § State Machine: blocked state | `blocked_state` |
| § State Machine: done state | `done_state` |
| § Labels: dispatch/actor label | `required_labels` (list) |
| § Dispatch Eligibility: work-item-format rule present | `require_work_item_format: true` |
| § Completion Evidence: verification commands | `accept.verification_commands` (list) |

Constant keys: `tracker.kind: linear`, `tracker.api_key: $LINEAR_API_KEY`,
`tracker.project_slug:` (from § Identity), `workspace.root: .symphony/workspaces`,
`review.enabled: true`, `review.prompt_path: REVIEW.md`, `codex.command:` (detected
or default). Use the engine defaults for `polling`, `agent`, `hooks` unless the
harness implies otherwise.

## 3. Confirm

Show the user the full proposed WORKFLOW.md YAML block. State which values came
from `tracker.md` and which are defaults. **Wait for approval or corrections
before writing.** If the user corrects a value, it does not change `tracker.md`
— the harness remains the source of truth; only this repo's generated config
reflects the correction, and you note the divergence in the final report.
````

- [ ] **Step 2: Commit**

```bash
git add skills/setup-symphony-orchestration/SKILL.md
git commit -m "feat(symphony-skill): extract-then-confirm config derivation"
```

---

### Task 2.4: Write + Install + Verify + Report sections

**Files:**
- Modify: `skills/setup-symphony-orchestration/SKILL.md`

- [ ] **Step 1: Append the remaining sections**

````markdown
## 4. Write

- `WORKFLOW.md` — the confirmed front-matter, then the implement prompt body
  from the package template `symphony/_templates/implement.md.j2` rendered with
  `project_name` (the repo/project name). Leave the `REPO-SPECIFIC RULES` block
  intact for the user.
- `REVIEW.md` — from `symphony/_templates/review.md.j2`, same `project_name`.
- `.env` — append `LINEAR_API_KEY=` (a stub) only if not already present; never
  overwrite an existing key.
- `.gitignore` — ensure `.symphony/` and `.env` are ignored (append if missing).

## 5. Install + Verify

- Install the engine into the repo venv:
  `pip install "git+PACKAGE_GIT_URL"` (substitute the real URL).
- Verify config loads, no live tracker call: `symphony validate --workflow WORKFLOW.md`.
  Expected: `OK: WORKFLOW.md is valid`. On error, surface it and stop before the report.

## 6. Report (print, do NOT run)

Tell the user setup is complete and list the manual follow-ups explicitly as
commands they run when ready:

1. Set the API key: `export LINEAR_API_KEY=...` (and persist in `.env`).
2. Provision tracker states: `symphony tracker states ensure` — creates the
   Agent Review / Human Review / Blocked states in the live Linear board.
   **This writes to the external tracker.**
3. Start the daemon when ready (e.g. install the launchd plist / run
   `symphony daemon`). **This starts a live autonomous loop.**

Also report: any value the user corrected away from `tracker.md` (divergence),
and that editing `WORKFLOW.md` / `REVIEW.md` later is fine — re-running this
skill is only needed to re-derive from a changed `tracker.md`.

## Edge cases

| Case | Rule |
|---|---|
| No `tracker.md` | stop (hard gate 1) |
| `kind` != linear | stop, name the extension point (hard gate 2) |
| Codex command undetectable | use engine default, note it |
| Verification commands undetectable | `accept.verification_commands: []`, note it |
| Re-run (WORKFLOW.md exists) | re-extract, diff vs existing, confirm only the changes; never clobber an edited prompt body or the REPO-SPECIFIC block |
| `.env` already has `LINEAR_API_KEY` | do not overwrite |
| pip install fails (offline/no venv) | report, leave generated files in place — setup resumes on re-run |
| Live tracker drifted from `tracker.md` | out of scope — this skill reads `tracker.md`, not the live tracker; provisioning is the manual follow-up |
````

- [ ] **Step 2: Commit**

```bash
git add skills/setup-symphony-orchestration/SKILL.md
git commit -m "feat(symphony-skill): write/install/verify/report + edge cases"
```

---

### Task 2.5: Clean-room fixture tests

Validate the skill against throwaway repos, the same method `setup-codex-development-harness` uses. Each fixture is a subagent run with a prepared repo; assertions are grep/file checks.

**Files:**
- Create: `skills/setup-symphony-orchestration/fixtures/README.md` (documents the four fixtures + expected outcomes)

- [ ] **Step 1: Document fixture — greenfield Linear (happy path)**

```markdown
### Fixture A: greenfield-linear
Setup: a repo with docs/harness/tracker.md (Linear preset, agent-gated),
docs/harness/index.md, AGENTS.md. No WORKFLOW.md.
Run: invoke setup-symphony-orchestration; approve the proposed config.
Assert:
- WORKFLOW.md exists; its YAML agent_review_state/blocked_state/done_state/
  required_labels match the values in tracker.md § State Machine / § Labels.
- REVIEW.md exists and contains "VERDICT: accept".
- .gitignore contains ".symphony/" and ".env".
- `symphony validate --workflow WORKFLOW.md` prints "OK".
- Report lists `symphony tracker states ensure` as a manual step and did NOT run it
  (no network calls; Linear board untouched).
```

- [ ] **Step 2: Document fixture — no harness (gate 1)**

```markdown
### Fixture B: no-harness
Setup: a repo with NO docs/harness/tracker.md.
Run: invoke the skill.
Assert: skill stops, message names setup-codex-development-harness; no WORKFLOW.md,
no REVIEW.md, no .env written.
```

- [ ] **Step 3: Document fixture — GitHub tracker (gate 2)**

```markdown
### Fixture C: github-tracker
Setup: a repo with docs/harness/tracker.md whose § Identity kind is github.
Run: invoke the skill.
Assert: skill stops, message says Linear-only + names the factory.py extension
point; no files written.
```

- [ ] **Step 4: Document fixture — idempotent re-run**

```markdown
### Fixture D: rerun-idempotent
Setup: Fixture A's end state (WORKFLOW.md present), with a hand-edited
REPO-SPECIFIC block in WORKFLOW.md.
Run: invoke the skill again; approve.
Assert: tracker-derived YAML keys unchanged (no spurious diff); the hand-edited
REPO-SPECIFIC block is preserved verbatim.
```

- [ ] **Step 5: Execute all four fixtures via subagents and record pass/fail**

For each fixture: create the throwaway repo state, dispatch a clean subagent to run the skill, then run the assertions. Fix any wording in `SKILL.md` that a fixture exposes (loophole → wording patch, same as the harness skill's method). Re-run the failing fixture until green.

- [ ] **Step 6: Commit**

```bash
git add skills/setup-symphony-orchestration/fixtures/README.md skills/setup-symphony-orchestration/SKILL.md
git commit -m "test(symphony-skill): clean-room fixtures (greenfield/no-harness/github/rerun)"
```

---

### Task 2.6: Register the skill in the plugin

**Files:**
- Modify: `plugins/engineering/README.md` (skills list + Notes)

- [ ] **Step 1: Add to the Included skills list** — insert `setup-symphony-orchestration` alphabetically near `setup-matt-pocock-skills` / `setup-codex-development-harness`.

- [ ] **Step 2: Add a Notes line**

```markdown
- `setup-symphony-orchestration` is the orchestration counterpart to the harness:
  it reads `docs/harness/tracker.md` and generates the per-repo `codex-symphony`
  config (WORKFLOW.md/REVIEW.md), installs the engine, and verifies it. Linear
  only today; requires a harness. The harness never generates orchestrator
  config — this skill does, consuming the harness contract.
```

- [ ] **Step 3: Commit**

```bash
git add README.md
git commit -m "docs: register setup-symphony-orchestration in engineering plugin"
```

---

## Self-review notes (for the implementer)

- The factory test uses a `_Cfg` stub rather than constructing a real
  `TrackerConfig` to keep the unit test independent of pydantic field
  requirements; the integration path is covered by the existing
  `test_symphony_config.py` / `test_symphony_orchestrator.py` after the seam edit.
- `make_tracker` is typed loosely (`object`) to avoid a circular import with the
  `Tracker` Protocol defined in `orchestrator.py`. If you prefer a precise type,
  move the `Tracker` Protocol into `symphony/tracker/__init__.py` and import it
  in both places — a clean refactor, but out of this plan's required scope.
- Phase 2 cannot be verified until `PACKAGE_GIT_URL` is real (Task 1.7). Do not
  start Phase 2 install/verify steps before Phase 1 publish.
```
