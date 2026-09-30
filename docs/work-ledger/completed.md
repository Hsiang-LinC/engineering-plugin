<!-- codex-harness: generated 2026-09-28 -->
# Completed Work

Archive — newest first. Entry format: `docs/harness/index.md` § Conventions.

## release-0-3-1-exercise-update
- done: 2026-09-30
- summary: released 0.3.1 — both plugin manifests at 0.3.1 and equal, the harness index lists the full distribution manifest surface, and the Codex long description no longer says "local" — and used it as the first real-remote update exercise.
- verified: four manifests parse and the pair is equal; `claude plugin validate .` passes; a `git archive` snapshot installs at 0.3.1 with 18 skills in both agents in isolated homes; no other file states the version; `git diff --check` clean. Post-publish, against baselines installed from the real remote at 0.3.0 BEFORE the push: Codex `marketplace upgrade` then `plugin add` moved 0.3.0 -> 0.3.1 (the 0.3.0 cache was replaced; installed manifest, new description and index line present); running only `plugin add` first left it at 0.3.0. Claude Code reached 0.3.1 after `plugin update` alone; afterwards `marketplace update` and `plugin update` reported already at 0.3.1.
- accepted: independent reviewer agent, ACCEPT, head 833efa263d3154aa004f45ac87884dc7480f40f4, patch sha256 6dd4529335b052d169d9111c34696652795daf048aeb9dc2f0739a0769c68893 (re-verified by the reviewer), no Critical or Important findings, 2026-09-30.
- delivery: merged and pushed on the owner's instruction: `main` fast-forwarded 9a740af -> 28b4801 through `claude/record-remote-delivery` and `claude/release-0-3-1`; `git ls-remote` over SSH and unauthenticated HTTPS both report 28b4801. The 0.3.0 baselines and the update runs were in isolated homes; no real config was touched.
- contradiction found: the README (and this item's acceptance text) said running only the second step leaves the old version in place. That held for Codex in both tests. It did NOT hold for Claude Code against the real remote: `plugin update` alone updated, and the marketplace clone's `lastUpdated` moved within 0.1 s of the plugin's, so `plugin update` refreshed the marketplace itself. An earlier local-remote test, seconds after install, did not refresh. The cause is not established (a staleness window and GitHub-versus-generic-URL handling are both plausible); do not rely on either behaviour.
- follow-ups: readme-update-step-wording (correct the overstated claim); deferred nit: the index manifest list restates a rule that lives in quality-gates.md

## release-0-2-5-local-install
- done: 2026-09-30
- summary: repaired the stale local Codex install — the marketplace entry was a dangling symlink to a path that no longer existed and the installed plugin was 0.1.1 — by bumping the manifest to 0.2.5, replacing the symlink with a seeded real directory and installing `engineering@local`. Superseded as the install route by `remote-marketplace-distribution`.
- verified: manifest parses and its `skills` path resolves; `git diff --check` clean; `codex plugin list` showed `engineering@local installed, enabled 0.2.5`; `diff -qr` of the `git archive` against both the installed path and the marketplace copy was identical; the installed `SKILL.md` carried the bootloader guidance.
- accepted: independent reviewer agent, ACCEPT, head 01afb6d340ef4a740bb75974c0cda6d59b3a96bf, patch sha256 ab601e65167aeccb30673e9723382938c21da17c7a4832703bca5c2e49f646ca (re-verified by the reviewer), no Critical or Important findings, 2026-09-30.
- delivery: installed from b8e615be168eac1e163d6704fdc163a9f3239f41 with the owner's go-ahead. Fresh-session skill smoke test: the owner reported it passing on 2026-09-30 and asked that it be treated as passed; this was reported by the owner and not observed by the agent. The item's two deferred minors (README lacks a symlink warning for `rsync --delete`; bump check against the installed version is manual) are moot because the README procedure was removed in 0.3.0.
- follow-ups: none

## bootloader-import-templates
- done: 2026-09-30
- summary: taught `setup-codex-development-harness` that one residence is not one reader — a bootloader whose agent does not auto-load the residence now gets a pointer that inlines it, an absent bootloader for an agent in use gets created, and refresh detects bootloader reach as drift. The block body still lives in exactly one file.
- verified: first revision REJECTED by an independent reviewer (base 3101913 / patch 72a2a188) for a § 6 gate with no waiver clause, which deadlocked the fallback § 5 itself sanctions, agents that cannot inline, and swap mode; plus setup mode writing no `CLAUDE.md` at all on the recommended default, leaving the original bug intact. Fixes applied across Explore, Propose, § 5, § 6, § 2 Absorb and v1 migration. Second revision frozen at base 3101913, patch sha256 ec669e42d0de54aa0bd1e40b77b502f3464daf4de80e892010bb1ce583bc61df, files `skills/setup-codex-development-harness/{SKILL.md,core-templates.md,behavioral-checks.md}`; `git diff --check` clean.
- accepted: independent reviewer agent, ACCEPT, that exact base and patch sha256 (re-verified by the reviewer), all four prior findings confirmed resolved, review recorded in conversation 2026-09-30, 2026-09-30. Both reviewers independently observed the mechanism working live: the harness reached them through this repo's `CLAUDE.md` + `@AGENTS.md`, which is the one scenario the author could not verify.
- delivery: source change only; no registration or install stage applies.
- follow-ups: bootloader-guidance-consolidation (Minors 1-9: rationale duplicated across five sites, stale "one-line pointer" wording, overloaded "finding", naming mismatch, untested root-relative import claim, undefined "block body" observable)

## claude-code-bootloader-alignment
- done: 2026-09-30
- summary: added a repo-root `CLAUDE.md` that points to `AGENTS.md` and inlines it with `@AGENTS.md`, so Claude Code loads the harness block it previously never saw; `AGENTS.md` stays the single residence of the block body.
- verified: `git diff --check` clean; `grep -c "Hard rules"` gives `AGENTS.md:1`, `CLAUDE.md:0`, so no second block body exists; user confirmed a fresh Claude Code session in this repo has the harness hard rules in context without reading a file.
- accepted: user, accepted, working-tree revision of `CLAUDE.md` plus `docs/work-ledger/active.md` entry, confirmation in conversation 2026-09-30, 2026-09-30
- follow-ups: bootloader-import-templates (generalize into the setup skill)

## harness-base-selection-rule
- done: 2026-09-30
- summary: setup and refresh guidance now starts independent items from the verified integration target and records dependency, exact base and integration order for stacked items.
- verified: five branch-base scenario assertions passed before and after merge; `git diff --check` passed on the candidate and landed merge `f3f1ef25b0cec1dd6f5d22cc7f478ec9b130c0a3`.
- accepted: user approved source candidate `3acc033ee6a9fb3234373dde4f672af05ef0ed02` on 2026-09-30; ledger acceptance committed as `89e8727`.
- delivery: merged into `main` at `f3f1ef25b0cec1dd6f5d22cc7f478ec9b130c0a3`; remote push and branch cleanup follow this archive commit.
- follow-ups: none

## integrate-harness-and-runbook
- done: 2026-09-30
- summary: merged `codex/harness-delivery-lifecycle` and `codex/local-plugin-update-runbook` into `main`, including earlier harness commits; preserved both completion records and updated the harness route to the new README procedure.
- verified: completed-ledger conflict resolved with both entries once; no unmerged files; `git diff --cached --check`, manifest and harness/ledger assertions, and README shell syntax passed on the merged tree; independent integration reviewer PASS; origin/main matched landed commit `ec56f98ddddf759db65db51e6b0af2853085efa8`.
- accepted: user confirmed both branches and their earlier harness commits for main integration on 2026-09-30; independent reviewer PASS on the staged merge resolution and route correction; landed commit `ec56f98ddddf759db65db51e6b0af2853085efa8`.
- delivery: main pushed and remote SHA verified as `ec56f98ddddf759db65db51e6b0af2853085efa8`; local plugin installation remains a separate versioned release step.
- follow-ups: none

## local-plugin-update-runbook
- done: 2026-09-30
- summary: documented a versioned local Engineering marketplace update from a committed source snapshot, target validation, installed-cache verification, and recovery with a newer version; this work branched directly from `main`.
- verified: isolated `CODEX_HOME` rehearsal installed versions 9.9.8 then 9.9.9; `diff -qr` confirmed staged source, marketplace and installed cache trees match; `git diff --check` passed; active Codex installation was untouched.
- accepted: independent reviewer PASS on 2026-09-30 for README patch SHA-256 `a912d350c128db9efd88f6ee7dc40217dfe22124c97638cb3c20a89c6ee4b379`, committed as `30ee1c224337bd764a4dbc0eba018725164f94e5`; tracker move excluded.
- delivery: `codex/local-plugin-update-runbook` pushed to origin and remote SHA verified as `30ee1c224337bd764a4dbc0eba018725164f94e5`; merge and active plugin installation remain separate decisions.
- follow-ups: none

## harness-delivery-lifecycle
- done: 2026-09-30
- summary: setup and refresh now detect repo-specific Git, CI, release/install and recovery paths, ask about consequential unknowns with suggested defaults, and generate stage-specific delivery routing; refreshed this repo's harness without treating push as merge or local installation.
- verified: `git diff --check` and staged whitespace check passed; Engineering refresh has Delivery & Recovery and checkout lifecycle routes, ten tracker sections and no unresolved template braces; matching setup/refresh and nonmatching Q&A scenarios checked; independent reviewer exercised Engineering and SMDA release/CI failure and cleanup cases. SMDA was not refreshed.
- accepted: independent reviewer PASS on 2026-09-30 for source/template/harness patch SHA-256 `166de6a27e2186a10d9a92129146acb9c172893a0750fdfed2e76759b896a1f0`, committed as `ed151d7d12e20e4c9f22a56c628c717b6aafe5e9`; tracker move excluded.
- delivery: `codex/harness-delivery-lifecycle` pushed to origin and remote SHA verified as `ed151d7d12e20e4c9f22a56c628c717b6aafe5e9`; merge and local plugin installation are separate decisions.
- follow-ups: none

## harness-scope-boundaries
- done: 2026-09-30
- summary: completed the generated work-item lifecycle from claim through landed verification and cleanup; fenced scope discovered during implementation; clarified Goal-mode and SMDA ownership of one shared project contract; raised Engineering to 0.2.4.
- verified: a fresh baseline agent applied the existing branch boundary but identified missing scope-crossing clarity; independent scenario review exercised adjacent, blocking, concurrent, sequential, stacked and runtime-owned work; manifest and lifecycle assertions plus `git diff --check` passed.
- accepted: independent reviewer APPROVE on 2026-09-30 after dependency-resume, stacked-base, tracker-deduplication and SMDA runtime-lifecycle findings were resolved; reviewed the final 0.2.4 candidate.
- follow-ups: none

## harness-work-item-lifecycle-guidance
- done: 2026-09-30
- summary: added Git-aware work-item candidate, worktree reuse, handoff, and cleanup guidance to the generic harness setup skill and raised Engineering to 0.2.3.
- verified: manifest parse and lifecycle scenario assertions passed; `git diff --check` passed. The generic validator could not run because PyYAML is unavailable locally and offline dependency resolution has no cached PyYAML.
- accepted: independent reviewer APPROVE on 2026-09-30 for the 0.2.3 candidate after correcting template placement and the non-Git route; reviewed source hashes recorded in the work session; archive move excluded.
- follow-ups: none

## pre-implementation-plan-self-check
- done: 2026-09-29
- summary: setup template now requires an agent plan self-check before implementation; added a behavioral scenario for plan gaps and new product decisions.
- verified: Python scenario assertions passed against template, Engineering harness, and SMDA harness; `git diff --check` passed; no executable script or manifest checks applied. Generated consumers need refresh to receive the new guidance.
- accepted: independent reviewer PASS on 2026-09-29 for base `168a258a8dad06d05905ac8261cdcd3e55ef38c1`, three-file patch SHA-256 `21438794c8d71c73e8070ce87fca3cc130c0162b633667202885369f6bf8d9ad`; archive move excluded.
- follow-ups: none

## track-ds-store-ignore
- done: 2026-09-29
- summary: tracked the existing `.gitignore` containing the `.DS_Store` pattern.
- verified: `git check-ignore -v` matched root and nested `.DS_Store`; tracked plugin files were not ignored; `git diff --check` and new-file whitespace check passed.
- accepted: independent reviewer PASS on 2026-09-29 for the `.gitignore` content and tracker scope; archive move excluded.
- follow-ups: none

## engineering-plugin-0-2-2-local-upgrade
- done: 2026-09-29
- summary: bumped Engineering to 0.2.2, pushed Engineering and SMDA changes, refreshed the local Engineering marketplace, and installed the new plugin version.
- verified: Engineering origin/main `a71f0fe` and SMDA origin/main `fdfb1a0` checked with `git ls-remote`; source, marketplace, and installed cache matched for six plugin files; installed version 0.2.2 enabled; manifest parse and `git diff --check` passed. SMDA release workflow is manual and was not triggered by the docs-only push.
- accepted: independent reviewer PASS on 2026-09-29 for source HEAD `a71f0fe` and installed Engineering 0.2.2; tracker archive move excluded.
- follow-ups: none

## product-boundary-and-slice-acceptance-guidance
- done: 2026-09-29
- summary: added conditional boundary discovery to grill-with-docs and setup templates; distinguished technical review from human acceptance of user-facing slices.
- verified: matching and nonmatching route checks passed; Engineering and SMDA harness policies compared; git diff --check passed in both repos.
- accepted: independent reviewer PASS on 2026-09-29 for source patch SHA-256 `98ec2bdeacf61b812b77619abdbcaac67f868641c325d5dd6ffffcc71f1b736b`; tracker archive move excluded.
- follow-ups: none

## adopt-engineering-plugin-harness
- done: 2026-09-28
- summary: installed a repo-local development harness with stage and skill routing, independent review, quality gates, and a durable work ledger; preserved existing plugin files and unrelated `.gitignore`.
- verified: required paths and ten tracker sections present; route checked against installed skill files and setup behavioral scenarios; whitespace check passed; no repository-wide test suite detected.
- accepted: independent reviewer PASS on 2026-09-28 after correcting the glossary route; reviewed core harness artifact hash SHA-256 `e9b5ddbe1eeb0c41a5ffa6a5f6c98139d11d34ae250259c4b337ecf3a2833095`; archive move excluded.
- follow-ups: none

## engineering-plugin-0-2-1
- done: 2026-09-28
- summary: released Engineering plugin 0.2.1 with a simplified harness contract
- verified: backfilled from Git commit `bd8a7f4`; no current test rerun inferred
- accepted: unknown; historical backfill
- follow-ups: none

## engineering-plugin-0-2-0
- done: 2026-09-19
- summary: released Engineering plugin 0.2.0 with shared harness acceptance contracts
- verified: backfilled from Git commit `e2fa424`; no current test rerun inferred
- accepted: unknown; historical backfill
- follow-ups: none
