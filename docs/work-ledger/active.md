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

## wording-followups-after-0-3-2
- status: in-progress
- phase: implement
- owner: interactive
- source: `release-0-3-2` reviewer minors and the Claude Code update-timing
  measurement, both deferred to keep accepted identities unchanged; plus a
  read-only refresh-style drift scan of this repo's own harness on 2026-09-30
  (items 7-9), which found small drift and judged a full refresh not worth its
  cost.
- base: c5f58af on `claude/followups-scope-update`, stacked for LEDGER STATE ONLY:
  that branch holds the current ledger and is unmerged; its diff against `main`
  is `docs/work-ledger/` only, so it does not overlap the candidate's files.
  Integration order: that branch lands first.
- branch: claude/release-0-3-3
- checkout: /Users/danny/dev/GitHub/engineering-plugin
- next: apply scope items 1-10, bump both manifests to 0.3.3, freeze the
  candidate and dispatch a same-provider independent reviewer
- updated: 2026-09-30
- scope: (1) README § Update: replace "did not against a local test remote, and
  the cause is not established" with the measured finding, that Claude Code's
  `plugin update` alone updated when the marketplace clone was about 4 min 54 s
  old and did not when it was about 16 s old, against the same remote, with the
  threshold unmeasured; keep "run both steps in order". (2) The § 6 gate title
  "no reach gap" versus its waiver sentence: retitle to "every reach gap has a
  recorded reason" or "no unwaived reach gap". (3) core-templates import-path
  rule: make "as the last rule says" accurate, by adding path resolution to the
  verify rule or dropping the back-reference. (4) Propose's trigger wording:
  note that it now follows the refresh definition of a reach gap. (5) Split the
  long refresh bullet. (6) `docs/harness/index.md` § Artifact Adapters: a pointer
  to quality-gates.md instead of a restated rule and four paths. Both plugin
  manifests bump together.
  From the drift scan, all in this repo's `docs/harness/index.md`: (7)
  Conventions lists a fixed set of active-entry fields, but the 2026-09-30
  ledger work used others. Codify the ones that recur on every item
  (`candidate`, `not-verified`, `minors-deferred`) and decide for each of the
  rest (`accepted` in an active entry, `resolved`, `reviewer-could-not-reproduce`,
  and `finding` in a completed entry) whether to add it or stop using it. (8)
  Task Routing "Completion" names "Codex built-in review" and
  `superpowers:requesting-code-review`, but every review this session ran
  through a general-purpose agent because `superpowers:code-reviewer` became
  unavailable; decided below, to be written into the route. (9) Coexisting Systems: register
  Claude Code and its bundled Engineering plugin, whose ten skills share the
  `engineering:` prefix with this plugin. From the Codex feasibility run
  (see `codex-feasibility-run`): (10) in the § 6 reach gate, state the swap-mode rule
  as an owner policy and not as wording, with its reason: swap mode changes only
  the tracker and its ledger files, so it cannot repair a bootloader; a reach gap
  found during a swap is reported, left unrepaired, and does not block the swap,
  and refresh repairs it. Add a behavioral-checks scenario for it. The outcome is
  the one already shipped in 0.3.2; see the decision at the end of this item.
- non-goals: changing any mandate or gate outcome of the skill, except that
  item 10 records an owner policy whose outcome shipped in 0.3.2 and is kept; the `.git`
  carried into Codex's installed copy; measuring the Claude Code refresh
  threshold; replacing this repo's `AGENTS.md` block with the current template
  text (it is a deliberate repo-specific condensation and its substance matches;
  the template's runtime-worker clauses do not apply here); a full refresh-mode
  run; any smda change (its bootloader is a bare pointer with no `@AGENTS.md`,
  so Claude Code never loads its hard rules, and its harness dates from
  2026-06-17; that refresh belongs in smda's own session under its own tracker
  and needs the owner to put smda in scope).
- acceptance: for item 10, the gate text labels the swap-mode rule as a policy
  and gives its reason, its outcome equals the one shipped in 0.3.2, a
  behavioral check covers it, and the reviewer judges it as an owner policy
  rather than as a wording change; for the rest of the skill text, no mandate
  or gate outcome changes, shown by
  the same mandate-by-mandate comparison the 0.3.2 reviewer used; README states
  the timing finding without claiming a cause it did not measure; for items 7-9,
  `docs/harness/index.md` changes only in Conventions, the Completion route and
  the review paragraph beside it, Coexisting Systems and Artifact Adapters,
  every field Conventions lists is actually used and every
  field in use is listed or deliberately retired, and the Completion route
  describes how reviews are really dispatched; both manifests equal; an
  independent reviewer accepts the exact candidate.
- verify: re-read the changed files; `claude plugin validate .`; parse and
  compare the manifest pair; `git archive` snapshot install in both agents;
  `git diff --check`; for item 7, grep the active and completed ledgers for each
  field name in Conventions and for any field in use that it omits. Merge and
  push need the owner's instruction.
  For item 8: re-read the route against the feasibility-run facts in notes; the
  candidate for this item is reviewed by the default route, which no longer
  depends on Codex being available.
- candidate: committed. Head c24c3416b5ae3c184ff374c0a74e06f6680cd040 on
  `claude/release-0-3-3`, compared with 0a6ee83; eight files
  (`.claude-plugin/plugin.json`, `.codex-plugin/plugin.json`, `README.md`,
  `docs/harness/index.md`, `docs/work-ledger/active.md`, and under
  `skills/setup-codex-development-harness/`: `SKILL.md`, `behavioral-checks.md`,
  `core-templates.md`); patch sha256
  3f95e3bbab844a3b1657dee10adb182b692bfe9eb13730b1c8bf888e45626049.
- accepted: independent reviewer, 2026-09-30, a general-purpose agent in a fresh
  context (same provider, therefore the same model family as the author, per the
  default route), ACCEPT on exactly that head and patch hash (re-verified by the
  reviewer). Scope items 1-10 all PASS, item 5 only narrowly as a source-line
  reflow; no Critical or Important findings. Independently verified: fenced
  templates byte-identical (10 blocks); AGENTS.md and CLAUDE.md unchanged; no
  other skill changed; a mandate-by-mandate comparison with the only behavioural
  delta being item 10, whose outcome equals the shipped one; ledger evidence
  preserved except the two deliberate merges; the ten bundled skill names match
  the app's Engineering plugin and overlap none of this repo's 18; both
  manifests 0.3.3; `claude plugin validate .` passes; a `git archive` snapshot
  installs at 0.3.3 with 18 skills in both agents. Covers source only.
- minors-deferred: (1) scope item 5 was done as a line-break reflow, not a
  structural split into sub-bullets; (4) Swap Mode step 5 says "all setup gates"
  while the swap policy lives only in the § 6 gate, so a pointer such as "a reach
  gap is reported, not repaired, per the § 6 policy" would be safer; (6) the new
  swap behavioral check does not say the user runs Claude Code, although a reach
  gap exists only for an agent in use; nits: the README phrase "the same real
  remote" has no clear antecedent after the Codex clause, and "a different model
  family (Codex)" reads Claude-centric. Not changed, to keep the accepted
  identity. Minors 2, 3 and 5 were ledger hygiene, fixed in the acceptance
  record. Scope item 4 needed no edit: Propose already says "reach gap (§ 5)", a
  pointer to the single definition, and restating it would break one fact, one
  residence.
- not-verified: the new swap behavioral check was confirmed to yield the stated
  outcome by reading, not run against a generated instance; the install of 0.3.3
  from the real remote until after the push; Claude Code's refresh threshold,
  between about 16 s and 5 min, stays unmeasured; which plugin wins a same-name
  skill collision with Claude Code's bundled Engineering plugin is untested; the
  `.git` carried into Codex's installed copy is unchanged.
- delivery: not started. Nothing is merged or pushed; GitHub `main` is ac864dd.
  The stack is linear: `main` -> `claude/followups-scope-update` ->
  `claude/release-0-3-3`. Owner instruction is required for merge and push.
  After the push, update the existing 0.3.2 baseline homes (Claude home A and
  the Codex home) by the two-step route and install 0.3.3 fresh from the real
  remote in both agents.
- notes:
  - decided 2026-09-30 by the owner, item 8. This SUPERSEDES an earlier decision
    the same day that made a Codex review the default in a Claude Code session; the
    owner reversed it after the feasibility run below. The default reviewer stays
    an independent agent of the same provider in a fresh context: it has no access
    to the author's conversation, which is the independence the harness needs. A
    different model family (Codex) is used only when one is actually required, for
    review or for implementation, not by default. The independence rule is
    unchanged: the reviewer is not the author and reviews the exact frozen
    candidate (commit SHA, or base SHA plus file list plus patch hash), and the
    acceptance record names the reviewer and its model family.
  - item 8 route text to write (implementation; ships with the next release):
    (a) Completion: dispatch an independent reviewer agent in a fresh context with
    the frozen identity, using `superpowers:requesting-code-review` when its
    reviewer agent type is available and otherwise a general-purpose agent given
    the same brief; in a Codex session built-in review stays the first choice.
    (b) Brief hygiene: the brief holds only evidence that existed at the freeze,
    and every reviewer of one candidate gets the same brief. (c) When a different
    model family is required, a short recipe: from the repo root
    `codex exec -s read-only -o <file> "<prompt>" < /dev/null`, where the
    `< /dev/null` is mandatory; a review document carrying `git diff <base> <head>`
    plus an instruction to read content with `git show` and not the working tree;
    have Codex compute and report the head SHA and patch hash; do not use the
    `codex-review:code` skill's auto-fix loop on a frozen candidate; stop only a
    process this review started; the diff leaves the machine and a session file is
    written under `~/.codex/sessions/`; and the route binds this repo only, not
    private consumers.
  - item 8 placement: the recipe is about eight lines and matters only when Codex
    is used, so it goes in `docs/harness/index.md` beside the Completion route, not
    in a skill. `codex-review:code` and `codex-dispatch` are app-managed
    third-party plugins that an update overwrites, and this repo's own skills never
    invoke Codex. Every recipe line must trace to a numbered fact in
    `codex-feasibility-run`.
  - codex-feasibility-run 2026-09-30, at the owner's instruction, on the already
    public 0.3.2 candidate (`35f15fc..8746995`, 15.5 KB review document). Answers
    to item 8 constraint 2:
    1. Runs non-interactively and is logged in: `codex login status` reports a
       ChatGPT login; `codex exec -s read-only -o <file>` ran to completion, model
       `gpt-5.6-terra` (Codex default, reasoning medium, approval never), about
       4 min 3 s, 78,262 tokens, a 1.6 KB answer and a 167 KB progress log.
    2. The `codex-review:code` skill reviews only the WORKING-TREE diff (`git diff`
       plus `git diff --cached`), not a committed range. A frozen candidate
       works if the review document carries `git diff <base> <head>` and the
       prompt tells Codex to read old and new content with `git show`.
    3. Findings can be tied to the frozen identity: Codex computed the head SHA
       and the patch sha256 itself and they matched the frozen values.
    4. It kept to the constraints it was given. Its commands were three
       `git show`, two `git diff`, one `git rev-parse` and a read of the review
       document; nothing outside the repo was read and the repo was unchanged.
    5. A hang that cost ten minutes: `codex exec` given a prompt argument waits on
       stdin when stdin is open ("Reading additional input from stdin...") and
       never starts. Always pass `< /dev/null`. The skill does not say so.
    6. Before stopping a stuck Codex, check whose process it is: the ChatGPT app
       runs its own long-lived `codex exec-server` processes. Only the process this
       review started (identified by its command line and parent) may be stopped.
    7. Side effects: the run persists a session under `~/.codex/sessions/`
       containing the reviewed diff, and the diff left the machine. The skill's
       Step 6 auto-fix loop edits code between rounds, which would change the
       candidate under review; the route must either not use it or re-freeze each
       round. The skill's default prompt is a generic bug/security/performance
       checklist; the route needs the harness brief instead.
    8. The brief must hold only evidence that existed at the freeze, and the same
       evidence the same-family reviewer gets. In this run the author's brief
       included a measurement made after the candidate was pushed, so one of
       Codex's two findings was an artefact of the brief (it re-found follow-up
       (1)).
  - codex-vs-same-family, one sample, not a general claim: same-family reviewer
    ACCEPT with four minors; Codex REVISE with two WARNINGs. Codex flagged the
    swap clause and, given the brief's post-freeze measurement, the README; it did
    not flag the "no reach gap" title tension the other reviewer raised. Different
    coverage; the two are complementary.
  - decided 2026-09-30 by the owner, item 10: KEEP the swap-mode clause and state
    it as a deliberate policy. Swap mode may complete with an unrepaired reach gap:
    it reports the gap, does not repair it, and is not blocked by it, because swap
    mode changes only the tracker and its ledger files and a bootloader is outside
    that. This settles the disagreement between two independent reviewers by an
    owner decision rather than by reading the pre-change wording, which supported
    both readings and stays ambiguous as history. Nothing needs reverting: the
    text shipped in 0.3.2 already behaves this way. This release only relabels it
    as policy with its reason and adds the check. A behavioral check to add: a
    tracker-swap request in a repo whose `CLAUDE.md` is a bare pointer completes,
    the report lists the reach gap and tells the user to run refresh, and no
    bootloader is edited.
