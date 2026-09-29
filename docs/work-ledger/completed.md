<!-- codex-harness: generated 2026-09-28 -->
# Completed Work

Archive — newest first. Entry format: `docs/harness/index.md` § Conventions.

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
