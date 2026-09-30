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
- status: planned
- phase: implement
- owner: unassigned
- source: conversation 2026-09-30 — the installed `engineering@local` is 0.1.1
  while the repo manifest is 0.2.4, and the marketplace entry is a dangling
  symlink (`docs/work-ledger/follow-ups.md` § codex-local-marketplace-unusable).
  Skill content changed since 0.2.4 (bootloader inlining), and README forbids
  reusing a version for changed contents.
- base: e1cc172 on `claude/bootloader-cc-alignment` (stacked)
- branch: not yet created
- checkout: /Users/danny/dev/GitHub/engineering-plugin
- blocked-by: none. Stacked, not blocked: this item depends on the unmerged
  bootloader commits caf2daa and e1cc172, because the version being released
  must carry that content. Integration order: that branch lands first; refresh
  this item's base and verification afterwards.
- next: create the candidate branch from the base above, bump
  `.codex-plugin/plugin.json` to `0.2.5`, freeze the candidate, dispatch an
  independent reviewer
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

## remote-marketplace-distribution
- status: planned
- phase: clarify
- owner: unassigned
- source: conversation 2026-09-30 — owner decision that development moves to
  local edit -> push to GitHub -> Codex and Claude Code both update from a
  remote marketplace, replacing the per-machine local marketplace.
- blocked-by: none
- next: settle the open questions below with the owner before any manifest is
  written
- updated: 2026-09-30
- open questions:
  1. Name collision in Claude Code. Its bundled `engineering` plugin occupies
     the `engineering:` prefix and contains none of these skills. The owner
     reversed the rename (`abandoned.md`), so decide: accept the collision for
     Claude Code, use a different name only in the Claude Code manifest, or
     revisit the rename. Tested 2026-09-30 on Claude Code 2.1.116 in an
     isolated `CLAUDE_CONFIG_DIR`: a marketplace entry named `eng-cc` over a
     `plugin.json` named `engineering` validates, adds and installs as
     `eng-cc@testmkt`. But the skill prefix comes from the loaded plugin's
     name, which the loader takes from `plugin.json` (`name:f.name` in the
     plugin loader), not from the marketplace entry. So renaming only the
     entry does NOT avoid the `engineering:` prefix. Renaming only for
     Claude Code needs a separate `.claude-plugin/plugin.json` with a
     different `name`, next to the unchanged `.codex-plugin/plugin.json`.
     Basis is a real install plus static reading of the installed binary; no
     session could run (not logged in), so the prefix itself is unobserved,
     and later Claude Code versions may differ. Remaining cost: routing in
     `docs/harness/index.md` would name a different prefix per agent.
     RESOLVED 2026-09-30 by the owner: keep the name `engineering` and accept
     the collision with Claude Code's bundled plugin; no rename and no second
     `.claude-plugin` name. The owner also uninstalls the `skills` app plugin
     (`skills@inline`, which duplicated `tdd`, `grill-me`, `write-a-skill` and
     others) and keeps the bundled Engineering plugin. Latent risk to keep in
     view: the two `engineering` plugins have no overlapping skill names today
     (bundled: architecture, code-review, debug, deploy-checklist,
     documentation, incident-response, standup, system-design, tech-debt,
     testing-strategy), but adding a same-named skill here later would collide
     silently. Which one wins is untested.
  2. Layout. Claude Code reads `.claude-plugin/plugin.json` and
     `.claude-plugin/marketplace.json`; Codex reads `.codex-plugin/plugin.json`
     and a marketplace manifest. Confirm both can share one repo root, and
     whether a Codex git-source marketplace can point at this repo directly.
     Precedent: `[marketplaces.smda]` uses `source_type = "git"`.
  3. Repository visibility on GitHub, and whether each machine already has
     access. A private repo needs credentials on every host.
  4. Versioning. Both agents cache per version, so a release discipline
     (bump on every content change, tag) must be stated once, in the README.
  5. Routing prefixes in `docs/harness/index.md` and the roughly 15 references
     across smda depend on the final name.
- scope: (to be set after clarification)
- non-goals: fixing the current local install (`release-0-2-5-local-install`).
- acceptance: (to be set after clarification)
- verify: (to be set after clarification)
