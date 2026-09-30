<!-- codex-harness: generated 2026-09-28 -->
# Abandoned Work

Record dropped work with `abandoned`, `why`, and `resume-if` fields.

## rename-plugin-namespace-eng
- abandoned: 2026-09-30
- why: owner reversed the decision before any delivery. The change was
  implemented and independently ACCEPTED (base 3101913, patch sha256
  692d3a8af17e09ddc93aa2ee5a349eb3eef404865207b264c4fb4ffc5b95c9cf), then
  reverted at the owner's direction, so the repo does not contain it and a
  completed entry would have been false. Reverted files:
  `.codex-plugin/plugin.json` (name and version back to `engineering` / 0.2.4),
  `docs/harness/index.md` (nine routes back to `engineering:`), and README's
  rename text. The plugin keeps the `engineering` name and the `engineering:`
  routing prefix.
- resume-if: this plugin is actually installed into Claude Code, where a
  bundled `engineering` plugin already occupies the `engineering:` prefix and
  contains none of these skills. Until then the collision is hypothetical:
  there is no `.claude-plugin/plugin.json`, and in Codex the current name
  works. Rename cost, measured during this attempt: 22 references in this repo
  plus 15 across 6 files in smda (including
  `packages/scheduler/tests/token_packaging.py`), a per-machine Codex
  marketplace migration, and a re-registration. Making the marketplace a git
  dist repo, as smda already does, would remove the per-machine part first.
- kept-from-attempt: the README drift fix is retained deliberately and is
  independent of naming — the update procedure asserted a marketplace named
  `engineering-local`, but the real one is `local`, so it would have failed
  its own assertion. Also discovered and still true:
  `/Users/danny/codex-local-marketplace/plugins/engineering` is a dangling
  symlink to `/Users/danny/Desktop/GitHub/engineering-plugin`, a path that no
  longer exists, so the documented update procedure cannot currently run at
  all; and the installed plugin is 0.1.1, not 0.2.4. See
  `docs/work-ledger/follow-ups.md`.
