<!-- codex-harness: generated 2026-09-28 -->
# Development Harness Index

This repository develops the Engineering plugin as one product. The plugin
manifest and `skills/*` are deliverables; this harness governs their ongoing
development. Tracker identity lives only in `docs/harness/tracker.md`.

## Project Profile

The maintainer and coding agents develop reusable skills for other repositories.
Changes to a skill's trigger, method, or bundled resources can change agent
behavior in every consuming project. The manifest registers the plugin; README
describes its public use. This repo has no application runtime or detected
automated test suite. Validate changed skills with targeted scenarios and
document the observed result rather than claiming general enforcement.

## Start Sequence

1. Read `docs/harness/tracker.md` and the current work item. Use its `phase`,
   `source`, `next`, and evidence to resume; do not rely on conversation memory.
2. Read `docs/harness/quality-gates.md` and the relevant skill, reference file,
   manifest, or README before changing it.
3. Choose the task route below. Resolve missing product decisions before edits.
4. Update the work item and durable docs with verification and review evidence.

## Task Routing

| Task | Read first | Method | Exit evidence |
|---|---|---|---|
| New or changed skill | relevant `skills/<name>/`, README, adjacent skills | `superpowers:brainstorming` for unresolved behavior; `skill-creator` or `superpowers:writing-skills` for the skill change; `engineering:tdd` when changing executable scripts | scenario showing trigger and behavior, changed artifact identity |
| Harness change | `skills/setup-codex-development-harness/`, this harness, affected consumers | `engineering:setup-codex-development-harness` refresh; compare template behavior against one concrete consuming repo | scenario evidence and affected template/consumer list |
| Bug or regression | failing skill behavior or script, related source | `engineering:diagnose`, then `engineering:tdd` for executable behavior | reproduction and regression check |
| Approved multi-item plan | approved source and Work Production | `engineering:to-issues` | independently checkable items with dependencies |
| Completion | `docs/harness/quality-gates.md`, `tracker.md` State Machine | `superpowers:verification-before-completion`, then Codex built-in review on the frozen candidate; if unavailable, `superpowers:requesting-code-review` to dispatch an independent reviewer | verification and independent acceptance for the same candidate |
| Delivery in scope | Delivery & Recovery below; README installation instructions when relevant | follow the authorized Git or plugin-release stage, then verify its result | landed or pushed revision, or installed version and smoke result; failure handoff per tracker |

## Work Production

Use the smallest path fitting the work. A bounded change with approved scope,
acceptance, and verification can remain one item. Unresolved plugin behavior
starts with design; product-level changes needing a durable approved source use
`engineering:to-prd`; multiple independently reviewable results use
`engineering:to-issues`. A bug starts with reproduction and diagnosis.

| Phase | Enter and use | Leave with |
|---|---|---|
| Clarify | unclear behavior, scope, or terms: `engineering:grill-with-docs` or `superpowers:brainstorming` | confirmed examples, non-goals, decision owner, open questions |
| Specify | behavior understood: `engineering:to-prd` when product scope needs a durable spec; otherwise scoped plan in the item | approved source revision and acceptance examples |
| Slice | approved scope needs multiple outputs: `engineering:to-issues` | items with dependencies, acceptance, and verification |
| Implement | tracker readiness holds: selected skill from Task Routing | candidate revision and criterion-level evidence |
| Accept | verification passes | independent decision on that candidate per tracker policy |
| Deliver (when in scope) | source accepted; use Delivery & Recovery under its own authority | applicable Git or install result and post-delivery checks, or a linked open delivery item |

For interactive work, the main agent dispatches an independent reviewer after
verification. Record a commit SHA, or freeze the base SHA, complete file list,
and patch hash when uncommitted. Resolve findings and re-review changed
candidates. Skill invocation or an `in-review` label alone is not acceptance.
If review cannot run, keep the item in review with a concrete next action.
This repository has no detected orchestration runtime; do not invent one.

## Interactive Work Item Lifecycle

One independently accepted item owns one identifiable candidate. Plan steps
within that item may share a branch; another item defaults to a separate branch
even when both reuse the same worktree. Before switching items, preserve the
current candidate, inspect its unmerged changes, and check the next item's
readiness and owner. An independent item starts from the verified integration
target (`main` in this repo), not the current feature branch. Stack on another
item's candidate only for a recorded dependency; record that item, exact base
revision, branch, checkout and integration order. If the base is uncertain,
clarify it before creating the branch. A stacked base does not waive tracker
dependencies.
Discovering adjacent work permits read-only investigation, not edits to that
item until separately claimed.

Reuse a free worktree after accounting for its prior changes. Use another
checkout when simultaneous work, active review or PR feedback needs isolation.
After landing, explicit abandonment or a safe blocked-work handoff, preserve
commits and useful local files, confirm no process needs the checkout, and
archive or remove it through its platform owner. Delete a branch only after
its work is integrated or explicitly discarded; never force-remove for routine
cleanup. Run applicable checks on the landed target before cleanup. Cleanup
does not grant merge or discard authority.

## Delivery & Recovery

Source acceptance, Git integration and plugin release are separate
outcomes. This repo has no detected CI workflow or automated plugin release.
An accepted source item may close with a linked delivery item when integration
or installation is scheduled separately. When delivery is part of the same
item, keep it active with `phase: deliver` until its applicable verification
passes; retain the recorded source acceptance. A branch push
does not establish that a change was merged or installed.

| Stage / trigger | Executable source | Authority / owner | Success evidence | Failure handoff / cleanup |
|---|---|---|---|---|
| Commit and push, when requested for the item | Git branch and remote; this item records its base and candidate | execution owner under the user's delivery instruction | committed SHA, pushed ref and remote SHA | preserve candidate and failed command; owner records unblock action in tracker; retain checkout until resolved |
| Merge, when requested | Git target and required checks must be confirmed for that request | designated integration authority; no standing merge grant recorded | landed target SHA and applicable checks from `quality-gates.md` | keep checkout for failed landed checks or PR feedback; use tracker failure rule |
| Plugin release through the remote marketplace, when separately authorized | `README.md` § Release and § Update; `.claude-plugin/marketplace.json`, `.agents/plugins/marketplace.json` | release owner named in that work item; needs merge and push authority for `main`, which is not standing | pushed `main` SHA, then for each agent the marketplace refresh and plugin update reporting the new version, plus a matching skill smoke scenario in a fresh session | preserve the prior release; record the failed step and the last successful stage; recover with a newer version in both plugin manifests under the same README procedure |

Do not infer that every branch push triggers a plugin update. Record successful
stage identities before retrying a failed later stage. After integration,
check the landed target before branch/worktree cleanup under Interactive Work
Item Lifecycle. If a future CI or release workflow is added, refresh this route
from the actual workflow and confirm its normal trigger and authority.

## Artifact Adapters

- Product source: the work item for bounded work; `docs/features/<topic>/`
  only when a multi-item project has actual spec or plan artifacts.
- Skill outputs: `skills/<name>/SKILL.md` and its needed bundled resources.
- Manifests: `.codex-plugin/plugin.json` and `.claude-plugin/plugin.json` (same
  `name` and `version`, per `quality-gates.md`), `.claude-plugin/marketplace.json`
  and `.agents/plugins/marketplace.json`; public usage: `README.md`.
- Issueization: work items per `docs/harness/tracker.md`.
- No empty project or slice directories during setup.

## Domain Docs

No glossary or ADR residence is needed yet. Create root `CONTEXT.md` when
shared terms become contested; create `docs/adr/` only for consequential,
hard-to-reverse decisions. Keep usage facts in README and skill behavior in
each skill's own files.

## Quality Gates

Read `docs/harness/quality-gates.md`. Record applicable checks, results, and
skips in the item before asking for acceptance.

## Coexisting Systems

| System | Relationship | Truth |
|---|---|---|
| Installed workflow skills | methodology | each skill's source and current installed version |
| Consuming repositories, including SMDA | separate projects | their own harness and tracker; update only when explicitly in scope |

## Conventions

- One work item section per slug in `docs/work-ledger/active.md`.
- Active item fields: `status`, `phase`, `owner`, `source`, `next`, `updated`,
  `acceptance`, `verify`; `blocked-by` only when dependencies exist.
- For a separate Git candidate, record `base`, `branch`, and `checkout`.
  For delivery in scope, record `delivery` stage and last successful identity.
- `status`: `planned`, `in-progress`, `in-review`, or `blocked`.
- `phase`: `clarify`, `specify`, `slice`, `implement`, `accept`, or `deliver`
  when this item owns later delivery.
- Completed entry fields: `done`, `summary`, `verified`, `accepted`,
  `follow-ups`, and `delivery` when applicable. Keep the reviewed revision and
  evidence in `accepted`; record later stage identities separately.
- Abandoned entry fields: `abandoned`, `why`, and `resume-if`.
- Keep tracker state in the ledger, not in feature packets or skills.
