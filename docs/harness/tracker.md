<!-- codex-harness: generated 2026-09-28 -->
# Tracker: Local Ledger

## Identity

- kind: local
- truth: `docs/work-ledger/` in Git
- id: kebab-case section heading

## State Machine

| State | Meaning | Who may set |
|---|---|---|
| planned | scoped, not yet started | anyone |
| in-progress | work underway | working agent or human |
| in-review | candidate and verification posted; independent decision pending | working agent or human |
| blocked | missing decision, capability, or external change | anyone |
| done | independently accepted; move to `completed.md` | independent reviewer decides, execution owner records; human may decide |
| abandoned | dropped with resume condition; move to `abandoned.md` | human, or agent with human approval |

An author cannot accept their own change. A human may set any state.
Review must cover the exact candidate delivered; a changed candidate needs
fresh review of affected evidence. Publishing a plugin release is a separate
decision from accepting a repository change.

## Labels

The entry's `type:` may be `bug` or `enhancement`. Triage states map to
`status:` and `next:`: `needs-triage` → planned with triage next;
`needs-info` → blocked with a concrete question; `ready-for-agent` → planned
and dispatch-eligible; `ready-for-human` → blocked pending a human action;
`wontfix` → abandoned. These are roles, not duplicate status fields.

## Work Item Format

Each executable item records `status:`, `phase:`, `owner:`, `source:` with
approved revision or conversation decision, `next:`, `updated:`, scope and
non-goals, observable `acceptance:`, and `verify:` with commands or scenarios
and expected outcomes. Add `blocked-by:` slugs for dependencies, omit if none.
Record unresolved questions in `next:` and the source artifact.

## Dispatch Eligibility

An item is ready only when its `status:` is `planned`, § Work Item Format is
complete, `next:` is executable, the source is current and approved, no
blocking question or review/human gate remains, and every `blocked-by:` item
has accepted completion in `completed.md` or a recorded waiver/supersession.
Recheck before starting. Interactive work uses the same readiness test;
clarification may start earlier.

## Read / Write

- Read: open `docs/work-ledger/active.md` and the source named by the item.
- Write: edit the item directly; move accepted or abandoned entries to the
  corresponding archive. Use `docs/harness/index.md` § Conventions.
- Only the execution owner advances the item. A reviewer records a decision;
  the owner applies the resulting state change.

## Completion Evidence

List changed files, candidate commit or frozen patch identity, criterion-level
results, commands/scenarios and outcomes, skips and remaining risks. Record
the independent acceptance actor, decision, reviewed identity, evidence
reference, and date. For delivery in scope, record pushed or landed revision,
CI/run, release or installed identity and post-delivery checks as applicable.
When later delivery is separately scoped, link its open item. Source acceptance alone is not proof of
merge or installation. Silence or casual acknowledgment is not acceptance.

## Failure Handling

On worker, verification or delivery failure, record the last successful stage,
failing command/run and output, suspected cause, and recovery owner; set
`status: blocked` and make `next:` the precise safe retry or unblock action.
Do not repeat a potentially non-idempotent publish without checking its result.
Never leave a finished worker's item `in-progress`. Anyone may restore
`planned` after recording what changed; scope or authority changes require the
appropriate human decision and invalidate affected approval/evidence.

## Archive Policy

Move accepted items to `completed.md` and dropped items to `abandoned.md`.
Both archives remain in Git. `follow-ups.md` holds non-committed ideas, not
duplicate active state.

## Interactive Rule

Before editing code, skills, contracts, or docs, create an item in
`active.md` if none covers the work. This is routine and does not need another
approval. Read-only exploration and discussion need no item.
