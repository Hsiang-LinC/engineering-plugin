# Ledger Conventions

Rules referenced by generated harness docs. When generating, copy the
*applicable* rules into `docs/harness/index.md` `## Conventions` — generated
repos must not depend on this plugin file at runtime.

## Entry Format

Section entries, never tables. Rationale: append-only, merge-friendly, and a
missing field is visibly absent (table columns get silently dropped).

### `active.md` / `follow-ups.md` — no-tracker variant (ledger is full truth)

```markdown
## <kebab-slug>
- status: planned | in-progress | blocked
- source: <spec / plan / conversation ref>
- next: <single concrete next action>
- updated: YYYY-MM-DD
```

### `active.md` / `follow-ups.md` — tracker variant (tracker is truth)

```markdown
## <kebab-slug>
- source: <tracker id, e.g. gh#142>
- summary: <one line>
```

Status, priority, and detail live in the tracker. Never copy them into the
ledger. Adopting a tracker later: refresh mode demotes existing full entries
to this variant.

### `completed.md`

```markdown
## <kebab-slug>
- done: YYYY-MM-DD
- summary: <what changed>
- verified: <test command run / evidence; "backfilled from git history" for backfill entries>
- follow-ups: <ref into follow-ups.md, or none>
```

### `abandoned.md`

```markdown
## <kebab-slug>
- abandoned: YYYY-MM-DD
- why: <reason>
- resume-if: <condition that would make it viable again>
```

## Markers

- Every generated file starts with: `<!-- codex-harness: generated YYYY-MM-DD -->`
- The bootloader block is wrapped in `<!-- codex-harness:begin -->` /
  `<!-- codex-harness:end -->`
- Refresh mode patches **only inside markers**. Content outside markers is
  user-authored and untouchable without asking.

## Staleness

- Every generated doc carries `Last verified: YYYY-MM-DD` directly under its
  title. Refresh updates it after re-verifying the file's claims.
- Refresh flags any file overdue by more than 90 days.

## Archive Policy

When `completed.md` exceeds ~200 entries or spans more than 1 year, refresh
rolls the oldest entries into `docs/work-ledger/archive/completed-YYYY.md`
(same entry format, one file per year).
