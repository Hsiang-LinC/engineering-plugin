<!-- codex-harness: generated 2026-09-28 -->
# Completed Work

Archive — newest first. Entry format: `docs/harness/index.md` § Conventions.

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
