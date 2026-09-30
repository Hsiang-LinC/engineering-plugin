<!-- codex-harness: generated 2026-09-28 -->
# Follow-ups

Record real debt or opportunities here; do not duplicate active work.

## codex-local-marketplace-unusable
Found 2026-09-30 while attempting the abandoned `rename-plugin-namespace-eng`.
`/Users/danny/codex-local-marketplace/plugins/engineering` is a dangling
symlink to `/Users/danny/Desktop/GitHub/engineering-plugin` — a path that no
longer exists, since the repo moved to `~/dev/GitHub/`. Verified with
`ls -la` and `readlink`. Consequences, independent of any rename:

- README § Update the local Engineering plugin cannot run: its
  `read_text()` on the plugin manifest raises `FileNotFoundError` before any
  assertion is reached.
- `codex plugin list` reports `engineering@local` at 0.1.1, so the installed
  copy is far behind this repo's 0.2.4 manifest.
- The symlink implies the marketplace was originally wired to the live working
  tree, which contradicts the README's `git archive HEAD` + rsync model. Two
  incompatible install philosophies coexist; that is why the breakage went
  unnoticed.
- Hazard if anyone repairs the symlink instead of replacing it: README's
  `rsync -a --delete` follows a destination symlink and would delete
  everything under the linked checkout absent from `git archive HEAD`,
  including `.git`.

Worth fixing whenever the local plugin next needs updating. The durable fix is
a git dist marketplace, as `smda` already uses
(`git@github.com:Hsiang-LinC/smda-plugin-dist.git`), which removes per-machine
marketplace maintenance entirely.

Superseded 2026-09-30 by `remote-marketplace-distribution`: the README no
longer documents the rsync update procedure, so the `--delete` hazard above no
longer applies to it. The broken local marketplace itself remains on the
owner's machine until the migration step in README § Migrating from the local
marketplace is run. Kept for history.

## swap-policy-pointer-and-check-wording
Deferred from the 0.3.3 review to keep its accepted identity unchanged; all are
small skill-text or wording edits, none changes a mandate or gate outcome.
- Swap Mode step 5 says "Validate (all setup gates)" while the swap-mode policy
  lives only in the § 6 reach-gap gate. Add a pointer, for example "(a reach gap
  is reported, not repaired, per the § 6 policy)", so dropping or moving the
  policy sentence cannot silently reintroduce the ambiguity the two 0.3.2
  reviewers disagreed about.
- The new behavioral check for a tracker swap in a repo whose `CLAUDE.md` is a
  bare pointer should say the user runs Claude Code; under the skill's own rule a
  reach gap exists only for an agent in use.
- The refresh Drift-scan bullet was split only by line breaks; convert the named
  checks into sub-bullets if a structural split is wanted.
- README § Update: "against the same real remote" follows a Codex clause and has
  no clear antecedent. The Completion route's "a different model family (Codex)"
  reads Claude-centric.
- The new swap check was confirmed by reading only; run it once against a
  generated instance when a repo with a bare-pointer bootloader is next swapped.

