---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable work artifacts through the repo harness using tracer-bullet vertical slices. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into issues.
---

# To Issues

Break a plan into independently-grabbable issues using vertical slices (tracer bullets).

Before publishing, read the repo harness: `docs/harness/index.md`,
`docs/harness/tracker.md`, `docs/harness/quality-gates.md`, and the Domain
Docs routes named by the index. If the harness is missing or does not name
where issueization outputs go, run or ask to run `setup-codex-development-harness`.

## Handoff contract

Check the index for graph ownership first. For SMDA-managed work, hand the
approved source to its decomposition/review/publication path; do not publish a
parallel child graph. When invoked inside a runtime role, use this skill’s
slicing method but obey that role’s output schema and authority: return the
proposed graph, do not publish issues, and use runtime graph review instead of
an independent interactive quiz. Surface ambiguity through the role’s supported
escalation/report mechanism. Outside a runtime role, follow the process below.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user
passes a tracker item reference (issue number, URL, Linear ID, local ledger
slug, or path) as an argument, fetch it using `docs/harness/tracker.md` and
read its full body and comments.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices have sufficient inputs for implementation without clarification.
Acceptance and merge still follow the tracker’s authority policy; AFK grants
neither permission. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every applicable layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Publish through the harness adapter

For each approved slice, publish the output named by `docs/harness/index.md`
§ Artifact Adapters. This may be tracker issues, local ledger entries, an
automation graph, or another repo-specific work artifact. Use the issue body
template below when the adapter is a tracker item.

Check the tracker’s content, scope, approval and clarification conditions
before assigning the mapped `ready-for-agent` actor/triage role. This
classification does not assert dispatch eligibility: unsatisfied dependencies
keep a queued item undispatchable; the runtime checks all conditions at start. Publishing a slice does not satisfy approval, dependency or
clarification gates. If the adapter feeds an automation
runtime, also encode the harness-required dispatch boundary from
`tracker.md` § Dispatch Eligibility.

Publish items in dependency order (blockers first) so you can reference real
item identifiers in the "Blocked by" field or the tracker-native dependency
encoding.

<issue-template>
## Parent

A reference to the parent tracker item (if the source was an existing item,
otherwise omit this section).

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

Avoid specific file paths or code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it here and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Source and boundaries

Approved source revision and decision reference; scope and non-goals for this
slice. Link unresolved questions rather than presenting assumptions as decisions.

## Verification

Commands or review steps, expected observable results, and relevant behavior
examples. Record how each acceptance criterion will be checked.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- A reference to the blocking ticket (if any)

Or "None - can start immediately" if no blockers.

</issue-template>

Do NOT close or modify any parent issue.
