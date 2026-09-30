<!-- codex-harness: generated 2026-09-28 -->
# Active Work

Entry format: `docs/harness/index.md` § Conventions.

## bootloader-guidance-consolidation
- status: planned
- phase: implement
- owner: unassigned
- source: reviewer Minors 1-9 across both reviews of
  `bootloader-import-templates` 2026-09-30, deferred there by agreement.
- blocked-by: none
- next: single wording pass over the five rationale sites
- updated: 2026-09-30
- scope: `skills/setup-codex-development-harness/` only. (a) The rationale for
  the inlining pointer now appears five times — `SKILL.md` Explore, Propose,
  § 5 twice, and `core-templates.md`; keep one residence and let the others
  point, per the skill's own "one fact, one residence". (b) `SKILL.md` § 5
  still calls it "the one-line pointer" and `core-templates.md` still heads
  the plain template "every other detected bootloader" — both state the
  pre-change rule as universal, and "one-line" is false for the inlining
  form. (c) "finding" is overloaded in the § 6 gate: gate failure in one
  sentence, report-only in the next. (d) `behavioral-checks.md` says
  "unreachable-bootloader finding" while the drift scan says "bootloader
  reach" — neither greppable from the other. (e) `core-templates.md` asserts
  the import path resolves repo-root-relative; both files sit at the repo
  root here, so root- and file-relative are indistinguishable and the general
  claim is untested — scope it to what was observed. (f) Define the
  observable for "block body" in the § 6 gate; the evidence used
  `grep -c "Hard rules"`.
- non-goals: changing any mandate or gate outcome; this is wording and
  de-duplication only.
- acceptance: no generated artifact changes; the rationale has one residence;
  no section states the plain pointer as the universal rule; the two names
  for the same finding are unified.
- verify: re-read the changed files end to end; confirm every mandate and
  gate still reads the same as the accepted revision.

## release-0-2-5-local-install
- status: in-progress
- phase: deliver
- owner: interactive
- source: conversation 2026-09-30 — the installed `engineering@local` is 0.1.1
  while the repo manifest is 0.2.4, and the marketplace entry is a dangling
  symlink (`docs/work-ledger/follow-ups.md` § codex-local-marketplace-unusable).
  Skill content changed since 0.2.4 (bootloader inlining), and README forbids
  reusing a version for changed contents.
- base: 29b94bc on `claude/bootloader-cc-alignment` (stacked; contains caf2daa and e1cc172)
- branch: claude/release-0-2-5
- checkout: /Users/danny/dev/GitHub/engineering-plugin
- blocked-by: none. Stacked, not blocked: this item depends on the unmerged
  bootloader commits caf2daa and e1cc172, because the version being released
  must carry that content. Integration order: that branch lands first; refresh
  this item's base and verification afterwards.
- next: smoke-test a changed skill in a fresh Codex session (not yet run);
  on pass, archive this item with the delivery identities below
- updated: 2026-09-30
- scope: manifest version bump to `0.2.5`; independent review of the README
  update-procedure drift fix (committed in e1cc172 without its own review);
  then repair the local Codex install — replace the dangling
  `plugins/engineering` symlink with a real directory seeded from
  `git archive HEAD`, then `codex plugin add engineering@local`.
- non-goals: renaming the plugin (abandoned, see `abandoned.md`); a Claude Code
  manifest; remote marketplace distribution (own item below); editing skill
  behavior.
- acceptance: `codex plugin list` reports `engineering@local` at 0.2.5; the
  installed content equals the committed source; a changed skill behaves as
  documented in a fresh Codex session; the README drift fix has an independent
  acceptance decision.
- verify: parse `.codex-plugin/plugin.json` and confirm version `0.2.5`;
  `git diff --check`; `diff -qr` between the `git archive HEAD` snapshot and the
  reported installed path; a matching skill scenario in a fresh Codex session.
  The install stage rewrites live Codex config outside this repo and needs the
  user's explicit go-ahead at that step. README's update procedure cannot run
  for this first repair: it reads the installed manifest before asserting, and
  the target directory is empty, so seed it directly.
- candidate: committed. Head 01afb6d340ef4a740bb75974c0cda6d59b3a96bf on
  `claude/release-0-2-5`, compared with 3101913; files `README.md` and
  `.codex-plugin/plugin.json`; patch sha256
  ab601e65167aeccb30673e9723382938c21da17c7a4832703bca5c2e49f646ca.
- accepted: independent reviewer agent, ACCEPT, 2026-09-30, on exactly that
  head and patch hash (re-verified by the reviewer). No Critical or Important
  findings. It checked the README against the real `marketplace.json`
  (`local`, plugin `engineering`, `./plugins/engineering`) and `config.toml`,
  traced the procedure against a healthy marketplace, and confirmed 0.2.5
  exceeds the installed 0.1.1. Covers source and docs only, not the installed
  result.
- minors-deferred: README does not warn that `plugins/engineering` must be a
  real directory, because `rsync --delete` follows a destination symlink
  (recorded in `follow-ups.md`, not where an operator reads the procedure);
  README says to bump above both installed and marketplace versions, but the
  script enforces only the marketplace-copy comparison (pre-existing).
- delivery: install stage DONE 2026-09-30 with the owner's go-ahead. Installed
  from commit b8e615be168eac1e163d6704fdc163a9f3239f41 (branch
  `claude/release-0-2-5`; differs from the accepted 01afb6d only in
  `docs/work-ledger/active.md`). The dangling symlink
  `plugins/engineering -> /Users/danny/Desktop/GitHub/engineering-plugin` was
  removed (link only) and replaced with a real directory seeded by
  `git archive`; `codex plugin add engineering@local` reported version 0.2.5,
  installed path `/Users/danny/.codex/plugins/cache/local/engineering/0.2.5`.
  Observed: `codex plugin list` shows `engineering@local installed, enabled
  0.2.5` at the marketplace path; `diff -qr` of the archive against the
  installed path and against the marketplace copy are both identical; the
  installed `SKILL.md` contains the bootloader guidance; `config.toml` still
  enables the plugin. The 0.1.1 cache was replaced, not retained. Codex
  marketplace upgrade is not needed for a local marketplace.
- not-verified: a fresh Codex session exercising a changed skill. Nothing
  is pushed or merged: both `claude/*` branches are local only.

## remote-marketplace-distribution
- status: in-progress
- phase: clarify
- owner: interactive
- source: conversation 2026-09-30 — owner decision that development moves to
  local edit -> push to GitHub -> Codex and Claude Code both update from a
  remote marketplace, replacing the per-machine local marketplace.
- base: c61611c on `claude/release-0-2-5` (stacked: the item text lives only on
  that chain)
- branch: claude/remote-marketplace-clarify
- checkout: /Users/danny/dev/GitHub/engineering-plugin
- blocked-by: none
- next: owner decides the three questions under "decisions"; then write
  scope/acceptance/verify and move to `implement`
- updated: 2026-09-30
- resolved:
  1. Name collision — RESOLVED by the owner: keep `engineering` and accept the
     collision with Claude Code's bundled plugin; the `skills` app plugin is
     uninstalled. Tested earlier: the skill prefix comes from `plugin.json`'s
     `name` (`name:f.name` in the 2.1.116 loader), not the marketplace entry, so
     renaming only an entry would not have avoided it. Latent risk: a future
     same-named skill here collides silently with the bundled Engineering
     plugin (bundled: architecture, code-review, debug, deploy-checklist,
     documentation, incident-response, standup, system-design, tech-debt,
     testing-strategy); which wins is untested.
  2. Repository visibility — PUBLIC (`gh repo view`; unauthenticated
     `git ls-remote https://github.com/Hsiang-LinC/engineering-plugin.git`
     answers), so no credentials on any host. GitHub `main` is still 3101913:
     nothing has been pushed.
  3. Layout — a plugin at the REPO ROOT installs in both agents with no
     restructuring. Tested with real repo content in isolated homes
     (`CLAUDE_CONFIG_DIR`, `CODEX_HOME`): Claude Code 2.1.116 with
     `.claude-plugin/marketplace.json` `source: "./"`, and Codex 0.149.1 with
     `.agents/plugins/marketplace.json` `path: "./"`, each installed 18 skills
     and did not copy `.git`. Precedent: the owner's `smda-plugin-dist` already
     ships two marketplace manifests and two `plugin.json` files (same name and
     version) beside a shared `skills/`; it nests the plugin in
     `plugins/<name>/`, which this repo does not need.
  4. Update mechanics — measured against a local git remote:
     - Codex: two steps, `codex plugin marketplace upgrade` then
       `codex plugin add`; without the upgrade the old version stays. A content
       change with an UNCHANGED version still refreshed the installed copy in
       0.149.1 (one test), so Codex does not force a bump.
     - Claude Code: two steps, `claude plugin marketplace update` then
       `claude plugin update`. It pins to the version string: a same-version
       content change reached the marketplace clone but NOT the installed copy
       (unique-marker test). A bump is mandatory for Claude Code.
     - Accepted source forms: Codex takes `owner/repo`, git URLs (an `http://`
       URL to a smart-HTTP git server worked) and local paths, and rejected
       `file://` and `git://`; a local path is treated as a local marketplace,
       not a git one. Claude Code takes `owner/repo`, `https://…` and local
       paths, rejected `git://`, and treats an `http(s)://` URL that does not end
       in `.git` as a direct marketplace.json URL.
     - Claude Code 2.1.116 rejects a top-level `description` in
       `marketplace.json` (`claude plugin validate`: unrecognized key), though
       it still installs; smda's manifest uses one, so newer versions accept it.
       Use `metadata.description` or omit it.
- decisions (owner):
  A. Marketplace name. It becomes part of the installed id
     (`engineering@<name>`), and the existing `engineering@local` in Codex is a
     different id, so both would coexist until `codex plugin remove
     engineering@local`.
  B. Drift guard. `name` and `version` would live in two `plugin.json` files.
     Propose a quality-gates row requiring them equal, rather than trusting
     memory (smda keeps both at 0.3.2 by hand).
  C. Landing. Nothing is merged or pushed. Order: `claude/bootloader-cc-alignment`
     -> `claude/release-0-2-5` -> this branch -> `main`; index.md records no
     standing merge grant, so merge and push need the owner's instruction.
- not-verified: a real GitHub remote (nothing pushed); the `owner/repo`
  shorthand; whether either agent auto-updates without the manual steps; and
  that Claude Code loads these skills in a running session (no login in the
  sandbox), only that they install.
- scope: (to be set after the decisions)
- non-goals: fixing the current local install (done under
  `release-0-2-5-local-install`).
- acceptance: (to be set after the decisions)
- verify: (to be set after the decisions)
