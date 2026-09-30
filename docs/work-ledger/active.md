<!-- codex-harness: generated 2026-09-28 -->
# Active Work

Entry format: `docs/harness/index.md` § Conventions.

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
- next: owner runs the README migration off `engineering@local` on each machine
  and smoke-tests a changed skill in a fresh session of each agent
- updated: 2026-09-30
- not-verified: the `owner/repo` shorthand; auto-update; Claude Code loading these
  skills in a running session; the owner's migration off `engineering@local`; a
  fresh-session smoke test of `engineering@engineering-plugin` in either agent;
  and Claude Code's version-pin claim, which rests on one local-remote test that
  the reviewer could not reproduce and was never exercised on the real remote.
  Verified since the first pass, see notes: the two-step update against the real
  remote.
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
- delivery: merge and push DONE 2026-09-30 on the owner's instruction. `main`
  fast-forwarded 3101913 -> 9a740af through `claude/bootloader-cc-alignment`,
  `claude/release-0-2-5` and `claude/remote-marketplace-clarify` (linear, no
  merge commits) and pushed once; `git ls-remote` and an unauthenticated HTTPS
  `ls-remote` both report 9a740af. The three branches still exist locally.
- notes:
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
  - reviewer-could-not-reproduce: Claude Code's version pinning. The reviewer's
    local test was inconclusive (its dumb-HTTP server cannot serve Claude Code's
    shallow clone). The author's unique-marker test showed it; the README states
    it as fact and the gate makes always-bump the rule, which is harmless if the
    pinning claim were wrong. Re-check on the real remote.
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
  - update-verified 2026-09-30 (via `release-0-3-1-exercise-update`, now archived):
    the two-step update was exercised against the real remote from baselines
    installed before the push. Codex: `marketplace upgrade` then `plugin add`,
    0.3.0 -> 0.3.1, and `plugin add` alone left 0.3.0. Claude Code: reached 0.3.1,
    but through `plugin update` alone, contradicting the README; see the archived
    entry and `readme-update-step-wording`.
  - update-timing-found 2026-09-30 (via `release-0-3-2`, archived): against the
    SAME real remote, Claude Code's `plugin update` alone did not update when the
    marketplace clone was about 16 s old and did update, refreshing the clone, when
    it was about 4 min 54 s old. That supports a staleness window and rules out
    GitHub-specific handling as the explanation of the 0.3.1 contradiction. The
    threshold lies between those two ages and is not measured. Codex never
    refreshed on `plugin add` alone, in any test.
