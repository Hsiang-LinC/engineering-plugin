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

- `docs/harness/tracker.md` — § Identity (kind, project slug), § State Machine
  (every state name + which is running / agent-review / human-review / blocked /
  done / terminal / active), § Labels (the dispatch/actor label), § Dispatch
  Eligibility (whether a work-item-format rule applies), § Completion Evidence
  (verification commands).
- `docs/harness/index.md` — Work Production + Task Routing, for prompt context.
- existing `WORKFLOW.md` — if present, this is a re-run (refresh; see Edge cases).
- the codex CLI command in use (from harness docs or `.codex/config.toml`); fall
  back to the engine default
  `codex --ask-for-approval never exec --sandbox workspace-write -`.

## 2. Extract (propose config)

Build the proposed WORKFLOW.md front-matter YAML from `tracker.md`. Map:

| tracker.md source | WORKFLOW.md key |
|---|---|
| § State Machine: active state(s) | `tracker.active_states` |
| § State Machine: terminal states | `tracker.terminal_states` |
| § State Machine: running state | `tracker.running_state` |
| § State Machine: agent-review state | `tracker.agent_review_state` |
| § State Machine: human-review/escalation state | `tracker.human_review_state` |
| § State Machine: blocked state | `tracker.blocked_state` |
| § State Machine: done state | `tracker.done_state` |
| § Labels: dispatch/actor label | `tracker.required_labels` (list) |
| § Dispatch Eligibility: work-item-format rule present | `tracker.require_work_item_format: true` |
| § Completion Evidence: verification commands | `accept.verification_commands` (list) |

Constant keys: `tracker.kind: linear`, `tracker.api_key: $LINEAR_API_KEY`,
`tracker.project_slug:` (from § Identity), `workspace.root: .symphony/workspaces`,
`review.enabled: true`, `review.prompt_path: REVIEW.md`, `codex.command:`
(detected or default). Use the engine defaults for `polling`, `agent`, `hooks`
unless the harness implies otherwise.

## 3. Confirm

Show the user the full proposed WORKFLOW.md YAML block. State which values came
from `tracker.md` and which are defaults. **Wait for approval or corrections
before writing.** If the user corrects a value, it does not change `tracker.md`
— the harness remains the source of truth; only this repo's generated config
reflects the correction, and you note the divergence in the final report.

## 4. Write

- `WORKFLOW.md` — the confirmed front-matter, then the implementer prompt body
  from the package template `implement.md.j2`, rendered with `project_name` (the
  repo/project name). Leave the `REPO-SPECIFIC RULES` block intact for the user.
- `REVIEW.md` — from the package template `review.md.j2`, same `project_name`.
- `.env` — append `LINEAR_API_KEY=` (a stub) only if not already present; never
  overwrite an existing key.
- `.gitignore` — ensure `.symphony/` and `.env` are ignored (append if missing).

The package templates ship inside the installed engine. Locate them with:

```bash
python -c "import symphony, pathlib; print(pathlib.Path(symphony.__file__).parent / '_templates')"
```

(`force-include` installs `templates/` to `symphony/_templates/` in the built
package.) Render with Jinja2 `StrictUndefined`, providing `project_name` plus the
runtime variables the engine supplies (`issue`, `attempt`, `artifact`) — for the
generated repo files, render only `project_name` and leave the `{{ issue.* }}` /
`{{ artifact.* }}` placeholders intact (the engine fills them at dispatch time).
In practice: copy the template text and substitute `{{ project_name }}` only.

## 5. Install + Verify

- Install the engine into the repo's environment:
  `pip install "git+https://github.com/Hsiang-LinC/codex-symphony.git"`
  (private repo — relies on the machine's GitHub credential helper; if the
  install fails on auth, tell the user to run `gh auth setup-git`).
- Verify the config loads, no live tracker call:
  `symphony validate WORKFLOW.md` — expect output `ok` and exit code 0. (The
  workflow path is a positional argument; it defaults to `WORKFLOW.md`.)

  The engine resolves `tracker.api_key` from `$LINEAR_API_KEY` while loading, so
  validate needs the key. Two cases:
  - **Key available:** `export LINEAR_API_KEY=...` (also persist it to `.env`),
    then `symphony validate WORKFLOW.md` → `ok`, exit 0.
  - **Key not yet available:** run validate anyway. A failure naming **only**
    `missing_tracker_api_key` means the config is otherwise valid and just needs
    the key — treat that as a pass-pending-key, not a config error. **Any other**
    validation failure (unknown state, bad YAML, missing field) is a real
    problem — surface it and stop before the report.

## 6. Report (print, do NOT run)

Tell the user setup is complete and list the manual follow-ups explicitly as
commands they run when ready:

1. Persist the API key in `.env` (`LINEAR_API_KEY=...`) so the daemon picks it
   up across sessions (if you only `export`ed it during verify).
2. Provision tracker states: `symphony tracker states ensure` — creates the
   Agent Review / Human Review / Blocked states in the live Linear board.
   **This writes to the external tracker.**
3. Start the daemon when ready: `symphony daemon` (or install a launchd plist).
   **This starts a live autonomous loop.**

Also report: any value the user corrected away from `tracker.md` (divergence),
and that editing `WORKFLOW.md` / `REVIEW.md` later is fine — re-running this
skill is only needed to re-derive from a changed `tracker.md`.

## Edge cases

| Case | Rule |
|---|---|
| No `tracker.md` | stop (hard gate 1) |
| `kind` != linear | stop, name the extension point (hard gate 2) |
| Codex command undetectable | use the engine default, note it |
| Verification commands undetectable | `accept.verification_commands: []`, note it |
| Re-run (WORKFLOW.md exists) | re-extract, diff vs existing, confirm only the changes; never clobber an edited prompt body or the `REPO-SPECIFIC RULES` block |
| `.env` already has `LINEAR_API_KEY` | do not overwrite |
| pip install fails (offline / no venv / auth) | report, leave generated files in place — setup resumes on re-run |
| Live tracker drifted from `tracker.md` | out of scope — this skill reads `tracker.md`, not the live tracker; provisioning is the manual follow-up |
