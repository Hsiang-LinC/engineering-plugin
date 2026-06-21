# Harness-First Engineering / SMDA Routing Spec

Status: approved for Engineering implementation
Date: 2026-06-21

## Decision Summary

Engineering owns the generic Codex development harness. SMDA automation consumes
that harness and adds only SMDA-specific Tier-3 config, routing pointers, and
operator guidance.

Matt Pocock-derived workflow skills remain useful as methodology providers:

- `grill-with-docs` stress-tests language and decisions.
- `to-prd` turns context into a durable spec/product artifact.
- `to-issues` slices an approved plan/spec into independently reviewable work.
- `triage` classifies and prepares tracker items.

Those skills do not own artifact formats. The repo harness owns artifact
adapters: where PRDs live, what a work item looks like, which tracker fields make
work dispatchable, and how automation routes are selected.

## Engineering Scope

This repo should:

- restore `skills/setup-codex-development-harness`;
- remove `skills/setup-matt-pocock-skills`;
- make `to-prd`, `to-issues`, and `triage` harness-native;
- make `docs/harness/index.md` the first-class source for Work Production,
  artifact adapters, Domain Docs, and Quality Gates routing;
- make `docs/harness/tracker.md` the source for tracker identity, states,
  labels, dispatch eligibility, read/write paths, completion evidence, and
  failure handling;
- generate `docs/harness/quality-gates.md` as a first-class generic harness
  artifact;
- stop generating `docs/agents/*`.

## Harness Contract Changes

`docs/harness/index.md` owns:

- task routing;
- Work Production and artifact adapters;
- Domain Docs routing (`CONTEXT.md` or `CONTEXT-MAP.md`, ADR locations, and lazy
  creation rules);
- Quality Gates routing;
- coexisting systems;
- generated-file conventions.

`docs/harness/tracker.md` owns:

- tracker identity and access path;
- state machine and acceptance authority;
- labels, including triage category roles (`bug`, `enhancement`) and state roles
  (`needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`,
  `wontfix`) when workflow skills are present;
- work item format and dispatch eligibility;
- completion evidence and failure handling.

`docs/harness/quality-gates.md` owns:

- required gate commands;
- fast vs full gate guidance when detected;
- when gates run before completion or automated review;
- environment notes needed to run the commands.

Domain files are not created empty during setup. The harness records where they
belong. `CONTEXT.md` is created lazily when the first term is resolved, and ADRs
are created lazily only for decisions that are hard to reverse, surprising
without context, and the result of a real trade-off.

## Workflow Skill Rules

`to-prd`, `to-issues`, and `triage` should start from the harness:

1. Read `docs/harness/index.md`.
2. Read `docs/harness/tracker.md`.
3. Read the Domain Docs and Quality Gates paths named by the harness.
4. Use the skill's methodology to produce the artifact required by the harness.

If no harness exists, instruct the user to run
`engineering:setup-codex-development-harness`. Do not instruct new repos to run
`setup-matt-pocock-skills`.

## SMDA Glossary Mapping

AFK/HITL, `Execution:`, and review states are different layers.

| Term | Layer | Meaning |
|---|---|---|
| AFK | planning/intake | Context is sufficient for automation to start. |
| HITL | planning/intake | Human decision, scope, context, or approval is needed before or during automation. |
| `Execution:` | scheduler routing | Machine-readable route selecting an SMDA workflow definition. |
| `Agent Review` | execution gate | Automated candidate is ready for non-human review/acceptance handling. |
| `Human Review` | execution gate | Runtime needs human decision, approval, missing context, or escalation handling. |
| `Execution: manual` | routing opt-out | Scheduler must not claim the issue. |

`Execution:` is not mandatory for all tracker items. It is mandatory for work
that should be claimed by SMDA under `explicit-only` policy. Missing
`Execution:` means unmodeled/not-yet-routed work. `Execution: manual` means a
human explicitly opted out of automatic claim.

SMDA's important automation routes:

- `Execution: smda` for full parent-driven work.
- `Execution: smda-task` for small scoped bugs and single-task fixes.
- `Execution: smda-roadmap` for roadmap decomposition into member parents.
- `Execution: smda-child` only for scheduler-created child issues.
- `Execution: manual` to prevent automatic claim.

## SMDA Follow-Up Scope

Do not implement these changes in this Engineering repo. The SMDA repo/plugin
should own its own follow-up implementation plan.

Recommended SMDA follow-up:

- remove the duplicate executable `setup-codex-development-harness` from the
  SMDA plugin;
- update `setup-smda-automation` to require
  `engineering:setup-codex-development-harness` or an equivalent harness;
- add SMDA routing text to harness updates for `smda`, `smda-task`,
  `smda-roadmap`, `smda-child`, and `manual`;
- document the AFK/HITL to execution/review-state mapping;
- keep SMDA Scheduler runtime contracts product-owned: phases, transitions,
  role contracts, schema IDs, report sections, execution modes, scheduler
  commands, adapter implementations, phase ledger, claim/lease/retry logic, and
  tracker projection outbox;
- update SMDA product docs/ADR separately after the setup surface changes land.

## Non-Goals

- Do not vendor SMDA runtime prompts, schemas, workflow manifests, adapter code,
  or phase transition logic into Engineering.
- Do not keep `setup-matt-pocock-skills` as a deprecated shim.
- Do not generate `docs/agents/*` compatibility files.
- Do not make every tracker issue carry `Execution:`.

## Validation

Engineering implementation should verify:

- `skills/setup-codex-development-harness` exists.
- `skills/setup-matt-pocock-skills` is removed.
- `to-prd`, `to-issues`, and `triage` reference the harness, not
  `setup-matt-pocock-skills`.
- setup harness templates mention `docs/harness/quality-gates.md`.
- setup harness templates do not generate `docs/agents/*`.
- README skill list matches the actual `skills/` directory.
