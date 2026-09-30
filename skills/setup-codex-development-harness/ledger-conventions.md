# Ledger Conventions

Rules referenced by generated harness docs. When generating, copy the
*applicable* rules into `docs/harness/index.md` `## Conventions` — generated
repos must not depend on this plugin file at runtime.

## Entry Format

Section entries, never tables. Rationale: append-only, merge-friendly, and a
missing field is visibly absent (table columns get silently dropped).

### `active.md` / `follow-ups.md` — local mode only

Remote-tracker modes do not generate these files; live state lives in the
tracker per `docs/harness/tracker.md`.

```markdown
## <kebab-slug>
- status: planned | in-progress | in-review | blocked
- phase: clarify | specify | slice | implement | accept | deliver (interactive, deliver only when in scope); runtime:<ledger-ref> (runtime-owned)
- owner: unassigned | interactive | runtime:<assignment-ref>
- parent: <roadmap node slug, if this belongs to a node>
- source: <spec / plan / conversation ref>
- base: <Git base revision, when a separate candidate branch is used>
- branch: <candidate branch, when used>
- checkout: <checkout/worktree path or identity, when used>
- delivery: <current stage and last successful identity, when delivery is in scope>
- next: <single concrete next action>
- updated: YYYY-MM-DD
```

Runtime-owned entries refer to the runtime ledger for authoritative phase and
next action; the tracker records ownership without starting a second controller.
All executable entries carry `blocked-by:`
(slugs; omit when none), `acceptance:` (observable outcomes), and `verify:`
(commands + expected outcomes) — fields defined in `tracker.md` § Work Item
Format.

### `completed.md` — local archive or retained remote archive

```markdown
## <kebab-slug>
- done: YYYY-MM-DD
- parent: <roadmap node slug, if carried from the live item>
- summary: <what changed>
- verified: <test command run / evidence; "backfilled from git history" or
  "backfilled from <tracker> <id>" for backfill entries>
- accepted: <actor, decision, object/revision, evidence reference and date; unknown for historical backfill>
- delivery: <applicable landed/run/release/install identities and post-delivery checks, or linked open delivery item>
- follow-ups: <ref into follow-ups.md (local mode) or the tracker (remote modes), or none>
```

### `abandoned.md` — local archive or retained remote archive

```markdown
## <kebab-slug>
- abandoned: YYYY-MM-DD
- parent: <roadmap node slug, if carried from the live item>
- why: <reason>
- resume-if: <condition that would make it viable again>
```

Remote-tracker modes: archive entries may carry the tracker work-item ID in
`verified:`/`why:` — IDs inside entries are data, not tracker identity, and
do not violate the tracker-leak gate.

## Markers

- Every generated file starts with: `<!-- codex-harness: generated YYYY-MM-DD -->`
- The bootloader block is wrapped in `<!-- codex-harness:begin -->` /
  `<!-- codex-harness:end -->`
- Refresh patches generated instructions only. A file-level generated header
  identifies the generated template, not permission to replace work entries
  or user additions. Preserve entries and project decisions; explicit begin/end
  markers delimit mixed-file generated blocks. Ask when ownership is unclear.

## Staleness

- A factual doc may carry a verification date. Refresh verifies changed claims;
  preserve existing dates until those claims are checked. No fixed age expires a doc.

## Archive Policy

When an authoritative local `completed.md` exceeds ~200 entries or spans more than 1 year, refresh
rolls the oldest entries into `docs/work-ledger/archive/completed-YYYY.md`
(same entry format, one file per year).
