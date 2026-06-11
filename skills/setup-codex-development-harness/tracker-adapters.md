# Tracker Adapters

Presets for `docs/harness/tracker.md`. Generation picks one preset, fills
`{...}` braces from detection, and writes it as `docs/harness/tracker.md`
with the standard generated header and `Last verified:` line. Generated
repos must not depend on this plugin file at runtime.

## The Contract

Every adapter fills the same eight sections, in this order. A missing or
brace-containing section fails validation. This file is simultaneously the
agent's tracker manual and any orchestrator's integration interface.

1. **Identity** — kind, where truth lives, work-item ID format.
2. **State Machine** — states: name / meaning / which actor may set it.
   Authority boundaries are encoded here.
3. **Labels** — actor / work-type / gate classifications ("none" is valid).
4. **Dispatch Eligibility** — one machine-checkable rule for what an
   orchestrator may dispatch.
5. **Read / Write** — how an agent reads its work item and posts updates
   (MCP tool names, CLI commands, or file edits). Name the access path
   actually detected in the repo; if none, state "none detected — report
   to user".
6. **Completion Evidence** — required content: changed files, verification
   commands and outcomes, remaining risks, follow-up refs.
7. **Archive Policy** — how Done/Canceled items become `completed.md` /
   `abandoned.md` entries (per-item at completion, batch at refresh).
8. **Interactive Rule** — behavior when bright-line work has no matching
   item: create one (with what defaults) or ask the user.

## Preset: local

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: Local Ledger

Last verified: {DATE}

## Identity
- kind: local
- truth: `docs/work-ledger/` files in this repo
- id format: kebab-slug section headings (`## <slug>`)

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| planned | scoped, not started | anyone |
| in-progress | being worked | the agent working it |
| blocked | needs human decision or external change | anyone |
| done | verified complete; entry moves to `completed.md` | the agent, with evidence |
| abandoned | dropped; entry moves to `abandoned.md` with `resume-if:` | human, or agent with human approval |

States live in the `status:` field of `active.md` / `follow-ups.md` entries.

## Labels
{repo-specific labels, else "none"}

## Dispatch Eligibility
An item is dispatchable when its `active.md` entry has `status: planned`,
no `blocked-by:` field, and a concrete action in `next:`.

## Read / Write
- read: open `docs/work-ledger/active.md`, find your entry
- write: edit entry fields directly; move entries between ledger files on
  state change
- entry formats: `docs/harness/index.md` § Conventions

## Completion Evidence
Moving an entry to `completed.md` requires: `done:` date, `summary:`,
`verified:` (command run + outcome), `follow-ups:` ref or none.

## Archive Policy
`completed.md` and `abandoned.md` are written at completion time — they ARE
the archive; no backfill loop needed.

## Interactive Rule
Bright-line work with no matching entry: add one to `active.md`
(`status: planned` or `in-progress`) before the first edit. Entry creation
is cheap and reversible — do not ask permission for it.
```

## Preset: github

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: GitHub Issues

Last verified: {DATE}

## Identity
- kind: github
- truth: GitHub issues in `{owner/repo}`
- id format: `#<number>`

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| open | backlog or active; refine with labels | anyone |
| open + label `in-progress` | claimed | the claiming agent |
| open + label `blocked` | waiting on human or external change | anyone |
| closed (completed) | accepted done | human, after review |
| closed (not planned) | abandoned | human |

Agents never close issues as completed — human review closes.

## Labels
- actor: `agent`, `human` {extend per repo}
- work-type: {repo-specific, else omit}
- gate: `needs-plan`, `needs-review` {extend per repo}

## Dispatch Eligibility
open, labeled `agent`, not labeled `blocked` or `in-progress`, body contains
acceptance criteria and verification expectations.

## Read / Write
- read: {detected: `gh issue view <n>` | GitHub MCP tool names | none detected — report to user}
- write: {detected: `gh issue comment <n>` / `gh issue edit <n> --add-label` | MCP equivalents}

## Completion Evidence
Completion comment must include: changed files; verification commands and
outcomes; remaining risks; follow-up issue refs.

## Archive Policy
closed-completed → `completed.md` entry; closed-not-planned →
`abandoned.md` entry (`resume-if:` from the closing comment). Per item at
completion or batch at refresh.

## Interactive Rule
Bright-line work with no matching issue: create one with an actor label, or
ask the user when scope is unclear.
```

## Preset: linear

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: Linear

Last verified: {DATE}

## Identity
- kind: linear
- truth: Linear project `{project}`
- id format: `{TEAM}-<number>`

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| Backlog | captured, not ready | human |
| Todo | scoped, dispatch-eligible when labeled | human |
| In Progress | claimed | orchestrator or agent |
| In Review | work done; human review pending | agent, with evidence |
| Done | human accepted | human only |
| Blocked | waiting on decision/dependency/credential | anyone |
| Canceled | will not be actioned | human |

Agents and orchestrators never set `Done` — human review is the acceptance gate.

## Labels
- actor: `agent`, `human`, `pairing`
- work-type: {repo-specific}
- gate: `needs-plan`, `needs-review` {extend per repo}

## Dispatch Eligibility
state `Todo`, labeled `agent`, no non-terminal blocking dependencies, body
contains acceptance criteria and verification expectations.

## Read / Write
- read: {detected Linear MCP tool names | none detected — report to user}
- write: comment + state update via the same path; final state changes
  agents may make: `In Review` (success), `Blocked` (failure)

## Completion Evidence
Completion comment must include: changed files; verification commands and
outcomes; remaining risks; follow-up issue refs.

## Archive Policy
`Done` → `completed.md` entry; `Canceled` → `abandoned.md` entry with
`resume-if:`. Batch backfill at refresh.

## Interactive Rule
Bright-line work with no matching issue: create one (`Todo`, actor label),
or ask the user when scope is unclear.
```

## Preset: jira

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: JIRA

Last verified: {DATE}

## Identity
- kind: jira
- truth: JIRA project `{KEY}` at `{instance URL}`
- id format: `{KEY}-<number>`

## State Machine

JIRA workflows are instance-specific — fill from the actual board:

| State | Meaning | Who may set |
|---|---|---|
| {To Do} | scoped, dispatch-eligible when labeled | human |
| {In Progress} | claimed | orchestrator or agent |
| {In Review} | work done; human review pending | agent, with evidence |
| {Done} | human accepted | human only |
| {Blocked} | waiting | anyone |

Agents never transition to {Done} — human review is the acceptance gate.

## Labels
- actor: `agent`, `human` {map to labels or components per instance}
- work-type / gate: {repo-specific}

## Dispatch Eligibility
state {To Do}, labeled `agent`, no blocking links, description contains
acceptance criteria and verification expectations.

## Read / Write
- read: {detected: JIRA MCP tools | `jira issue view` CLI | none detected — report to user}
- write: comment + transition via the same path; agent-allowed transitions:
  {In Review}, {Blocked}

## Completion Evidence
Completion comment must include: changed files; verification commands and
outcomes; remaining risks; follow-up issue refs.

## Archive Policy
{Done} → `completed.md` entry; abandoned resolutions → `abandoned.md` with
`resume-if:`. Batch backfill at refresh.

## Interactive Rule
Bright-line work with no matching issue: create one ({To Do}, actor label),
or ask the user when scope is unclear.
```

## Custom skeleton

For trackers without a preset. Same eight sections; every line is a brace to
fill with the user. The validation gate (all sections filled, no braces left)
applies unchanged.

```markdown
<!-- codex-harness: generated {DATE} -->
# Tracker: {name}

Last verified: {DATE}

## Identity
- kind: custom
- truth: {where}
- id format: {format}

## State Machine
{states table: name / meaning / who may set. Encode the human acceptance gate.}

## Labels
{classifications, or "none"}

## Dispatch Eligibility
{one machine-checkable rule}

## Read / Write
{detected access path; "none detected — report to user" is valid}

## Completion Evidence
{required content — default: changed files; verification commands and
outcomes; remaining risks; follow-up refs}

## Archive Policy
{terminal states → completed.md / abandoned.md mapping}

## Interactive Rule
{create-or-ask behavior for bright-line work without a matching item}
```
