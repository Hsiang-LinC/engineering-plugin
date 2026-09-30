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

## remote-marketplace-distribution
- status: in-progress
- phase: deliver
- owner: interactive
- source: conversation 2026-09-30 — owner decision that development moves to
  local edit -> push to GitHub -> Codex and Claude Code both update from a
  remote marketplace, replacing the per-machine local marketplace.
- base: c61611c on `claude/release-0-2-5` (stacked: the item text lives only on
  that chain)
- branch: claude/remote-marketplace-clarify
- checkout: /Users/danny/dev/GitHub/engineering-plugin
- blocked-by: none
- next: owner runs the README migration off `engineering@local` on each machine
  and smoke-tests a changed skill in a fresh session of each agent; exercise
  the two-step update for real with the next release (0.3.1, which can carry the
  deferred minors)
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
- decided 2026-09-30 by the owner:
  A. Marketplace name `engineering-plugin`; installed id
     `engineering@engineering-plugin`. The old Codex `engineering@local` is a
     different id and coexists until the owner removes it.
  B. Drift guard: a `docs/harness/quality-gates.md` row requiring both
     `plugin.json` files to carry the same `name` and `version`; no script.
  C. Landing: merge the stacked branches in order and push once, after this
     item is implemented and accepted. Merge and push still need the owner's
     instruction at that moment; index.md records no standing merge grant.
- not-verified: a real GitHub remote (nothing pushed); the `owner/repo`
  shorthand; whether either agent auto-updates without the manual steps; and
  that Claude Code loads these skills in a running session (no login in the
  sandbox), only that they install.
- scope: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` and
  `.agents/plugins/marketplace.json` (plugin at the repo root, `source: "./"`);
  both plugin manifests at `0.3.0` (a new distribution surface, so a minor
  bump); a quality-gates row for the manifest pair; README Installation and
  update sections rewritten around the remote marketplace, replacing the
  local-marketplace rsync procedure and adding the migration off
  `engineering@local`; the `docs/harness/index.md` Delivery row and matching
  quality-gates wording; a superseded note on the follow-up about the broken
  local marketplace.
- non-goals: merging or pushing; renaming the plugin; changing any skill's
  behavior; Claude Code runtime verification of skills; removing the owner's
  `engineering@local` install or `~/codex-local-marketplace` (owner's machine,
  documented as a migration step); any smda change.
- acceptance: both agents install `engineering@engineering-plugin` at the same
  version from a snapshot of the committed tree in isolated homes, with all 18
  skills and no `.git`; `claude plugin validate` passes on the repo root; the
  two plugin manifests agree on name and version; README states the two-step
  update for each agent and that a version bump is required; index.md and
  quality-gates.md name the remote route and no longer route through the local
  marketplace; an independent reviewer accepts the exact candidate.
- verify: JSON-parse all five manifests; compare name and version across the
  pair; `claude plugin validate .`; `git archive` the candidate and install it
  through each agent's local-path marketplace in isolated `CLAUDE_CONFIG_DIR` /
  `CODEX_HOME`; grep the repo for stale `engineering@local` and `local`
  marketplace instructions; `git diff --check`. The real GitHub remote and the
  running-session skill load stay unverified until after push.
- candidate: committed. Head b44d1c0eb1645280ebd516358bea7ca36a0b0cf5 on
  `claude/remote-marketplace-clarify`, compared with 7e75a61; eight files
  (`.agents/plugins/marketplace.json`, `.claude-plugin/{marketplace,plugin}.json`,
  `.codex-plugin/plugin.json`, `README.md`, `docs/harness/{index,quality-gates}.md`,
  `docs/work-ledger/follow-ups.md`); patch sha256
  aeabdf111070898710f257aff03d09182a625cf638c48fc10d1699a32c67860f.
- accepted: independent reviewer agent, ACCEPT, 2026-09-30, on exactly that head
  and patch hash (re-verified by the reviewer). No Critical or Important
  findings. It re-ran the snapshot install in both agents in isolated homes
  (0.3.0, 18 skills, no `.git`), `claude plugin validate`, and checked every
  README command against `--help` (`codex plugin remove` and
  `codex plugin marketplace remove` only read, not run). It confirmed no
  `skills/` change, no other place stating the version, and that GitHub `main`
  is still 3101913. Covers source and docs, not the published result.
- minors-deferred: (1) `docs/harness/index.md` § Artifact Adapters still lists
  only `.codex-plugin/plugin.json` as the manifest although four files now
  carry the distribution surface; (2) README § Installation does not say the
  real GitHub path is unexercised until the first push; (3)
  `.codex-plugin/plugin.json` `interface.longDescription` still says "A local
  Codex plugin" (pre-existing wording). Left out to keep the accepted identity
  unchanged; fix in a follow-up item.
- reviewer-could-not-reproduce: Claude Code's version pinning. The reviewer's
  local test was inconclusive (its dumb-HTTP server cannot serve Claude Code's
  shallow clone). The author's unique-marker test showed it; the README states
  it as fact and the gate makes always-bump the rule, which is harmless if the
  pinning claim were wrong. Re-check on the real remote.
- delivery: merge and push DONE 2026-09-30 on the owner's instruction. `main`
  fast-forwarded 3101913 -> 9a740af through `claude/bootloader-cc-alignment`,
  `claude/release-0-2-5` and `claude/remote-marketplace-clarify` (linear, no
  merge commits) and pushed once; `git ls-remote` and an unauthenticated HTTPS
  `ls-remote` both report 9a740af. The three branches still exist locally.
- post-push verification, RUN against the real remote: in isolated homes
  (`CLAUDE_CONFIG_DIR`, `CODEX_HOME`), each agent added
  `https://github.com/Hsiang-LinC/engineering-plugin.git` and installed
  `engineering@engineering-plugin`; both reported 0.3.0, installed 18 skills and
  contained the bootloader guidance. No real config was touched.
- finding: Codex's installed copy includes the whole marketplace clone,
  including `.git` (404K of 792K, 70 commits, origin URL, not shallow), because
  the plugin is the repo root. Claude Code's copy has no `.git` (388K). Harmless
  in function; a nested `plugins/engineering/` layout, as smda uses, would avoid
  it at the cost of restructuring. Not addressed.
- still NOT verified: the two-step update against the real remote (needs a new
  published version); the `owner/repo` shorthand; auto-update; Claude Code
  loading these skills in a running session; the owner's migration and a
  fresh-session smoke test in either agent.

## release-0-3-1-exercise-update
- status: in-progress
- phase: implement
- owner: interactive
- source: conversation 2026-09-30 — `remote-marketplace-distribution` shipped
  0.3.0 but left three reviewer Minors unaddressed and the two-step update
  unverified against the real remote; a real release is the only way to
  exercise it. Minors and non-reproducible pin claim are recorded in that item.
- base: 1b6eaa2 on `claude/record-remote-delivery`, stacked for LEDGER STATE
  ONLY: that branch is the only place the current ledger lives and is not yet
  merged. The candidate's code files do not overlap it (its diff against `main`
  is `docs/work-ledger/` only). Integration order: that branch lands first.
- branch: claude/release-0-3-1
- checkout: /Users/danny/dev/GitHub/engineering-plugin
- blocked-by: none
- next: apply the scope, bump both manifests, commit, freeze the candidate and
  dispatch an independent reviewer
- updated: 2026-09-30
- scope: (1) `docs/harness/index.md` § Artifact Adapters names every
  distribution manifest (`.codex-plugin/plugin.json`,
  `.claude-plugin/plugin.json`, both marketplace manifests) or points to the
  quality-gates row, instead of only the Codex one; (2) the stale "A local Codex
  plugin" opening of `.codex-plugin/plugin.json` `interface.longDescription`;
  (3) both plugin manifests to `0.3.1`, equal per the drift-guard gate; (4) the
  post-publish update exercise below. Reviewer Minor 2 (README lacking a note
  that the real GitHub path was unexercised) is dropped: installing from the
  real remote in both agents was done after the 0.3.0 push, and the update path
  stays covered by README § Release step 4.
- non-goals: skill behavior; restructuring to a nested `plugins/engineering/`
  layout to avoid the `.git` carried into Codex's installed copy; the
  `bootloader-guidance-consolidation` wording pass (separate item; if it is
  accepted first it simply rides in this release); Claude Code invocation
  syntax in README § Usage, which is Codex-only and unverified for Claude Code;
  any smda change.
- acceptance: both plugin manifests read `0.3.1` with equal name and version;
  the index names the full manifest surface; the description no longer says
  "local"; after the owner merges and pushes, in isolated homes that hold
  0.3.0 from the real GitHub remote, Codex reports 0.3.1 after
  `codex plugin marketplace upgrade` then `codex plugin add`, and Claude Code
  reports 0.3.1 after `claude plugin marketplace update` then
  `claude plugin update`, with `codex`/`claude` showing 0.3.0 when only the
  second step is run; an independent reviewer accepts the exact candidate.
- verify: JSON-parse the four manifests and compare the pair; `claude plugin
  validate .`; `git archive` the candidate and install it in isolated homes for
  both agents; `git diff --check`; grep that no other file states the version.
  After push: install 0.3.0 from the remote in fresh isolated homes first
  (before pushing, so the starting point is real), then run the two-step update
  and record the reported versions. Merge and push need the owner's instruction;
  index.md records no standing grant.
- open for the owner: `docs/harness/index.md` § Task Routing "Completion" still
  names "Codex built-in review" and `superpowers:requesting-code-review`, but
  the `superpowers:code-reviewer` agent type was unavailable mid-session and the
  reviews here ran through a general-purpose agent. Decide whether to correct
  that route in this release or leave it.
