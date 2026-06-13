# setup-symphony-orchestration — clean-room fixtures

Each fixture sets up a throwaway repo (under `/tmp/symphony-fixtures/<name>`),
runs the skill against it as a fresh agent would (honoring the Hard Gates and
the extract-then-confirm flow; assume the user approves the proposed config),
then checks the assertions. A gate fixture passes when the skill **stops and
writes nothing**.

Status legend: ✅ executed & passing · ⬜ specified (run on change).

## Fixture A — greenfield-linear (happy path) ✅

**Setup:** repo with `AGENTS.md`, `docs/harness/index.md` (stub with a
`## Task Routing` heading), and a Linear `docs/harness/tracker.md` (kind=linear,
project `demo-proj`; states Backlog/Todo/In Progress/In Review/Human Review/
Done/Blocked/Canceled; actor label `agent`). A `.venv` for the install.

**Run:** invoke the skill, approve the proposed config; `export LINEAR_API_KEY=dummy-key`
before the verify step.

**Assertions (all passed 2026-06-13):**
- `WORKFLOW.md` front-matter maps from `tracker.md`: `kind: linear`,
  `project_slug: demo-proj`, `required_labels: [agent]`, `active_states: [Todo]`,
  `terminal_states: [Done, Canceled]`, `running_state: In Progress`,
  `agent_review_state: In Review`, `human_review_state: Human Review`,
  `blocked_state: Blocked`, `done_state: Done`, `require_work_item_format: true`.
- `WORKFLOW.md` body contains the `REPO-SPECIFIC RULES` marker and references
  `docs/harness/tracker.md`.
- `REVIEW.md` exists with all four `VERDICT:` lines.
- `.gitignore` contains `.symphony/` and `.env`; `.env` holds the `LINEAR_API_KEY=` stub.
- `codex-symphony` installs from `git+https://github.com/Hsiang-LinC/codex-symphony.git`.
- `symphony validate WORKFLOW.md` (with `LINEAR_API_KEY` set) prints `ok`, exit 0.
- The skill did NOT run `symphony tracker states ensure` or start a daemon — they
  appear as printed manual follow-ups.

## Fixture B — no-harness (gate 1) ✅

**Setup:** a git repo with NO `docs/harness/tracker.md`.
**Run:** invoke the skill.
**Expected:** stops at Hard Gate 1; message names `setup-codex-development-harness`;
no `WORKFLOW.md` / `REVIEW.md` / `.env` written.

## Fixture C — github-tracker (gate 2) ✅

**Setup:** repo whose `docs/harness/tracker.md` § Identity has `- kind: github`.
**Run:** invoke the skill.
**Expected:** stops at Hard Gate 2; message says Linear-only and names the
`symphony/tracker/factory.py` extension point; no files written.

## Fixture D — rerun-idempotent ✅

**Setup:** Fixture A's end state, with a hand-edited line added inside the
`REPO-SPECIFIC RULES` block of `WORKFLOW.md`.
**Run:** invoke the skill again; approve.
**Expected:** tracker-derived front-matter keys unchanged (no spurious diff in
state/label values); the hand-edited REPO-SPECIFIC line preserved verbatim.

## Running

These are prompt-driven, not a pytest suite. Run them by dispatching a fresh
agent per fixture with the prepared repo, then checking the assertions (greps /
file existence / `symphony validate` exit code). When a fixture exposes skill
wording that yields a wrong outcome, patch `SKILL.md` and re-run — the same
loophole-to-wording-patch method `setup-codex-development-harness` uses.
