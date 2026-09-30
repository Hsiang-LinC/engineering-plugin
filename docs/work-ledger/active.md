<!-- codex-harness: generated 2026-09-28 -->
# Active Work

Entry format: `docs/harness/index.md` § Conventions.

## harness-delivery-lifecycle
- status: in-progress
- phase: deliver
- owner: interactive
- source: user-approved delivery and recovery design in this conversation; based on `ec40fd8`
- scope: teach setup and refresh to detect repo-specific delivery, ask about consequential unknowns with suggestions, generate lifecycle routing and evidence, then refresh this repo's harness
- non-goals: create a universal CI/release engine or change SMDA's product workflow
- base: `ec40fd8` (`codex/harness-scope-boundaries`)
- branch: `codex/harness-delivery-lifecycle`
- checkout: `/Users/danny/Developer/GitHub/engineering-plugin`
- acceptance: setup/refresh routes applicable Git, CI, release/install, failure and cleanup stages; unknown authority is clarified; Engineering and SMDA scenarios stay distinct; this repo's harness is refreshed, independently reviewed, committed and pushed
- verify: exercise matching and nonmatching setup/refresh scenarios against Engineering and SMDA; verify generated paths and tracker rules; `git diff --check`; independent review of exact candidate
- accepted: independent reviewer PASS on 2026-09-30 for source/template/harness patch `166de6a27e2186a10d9a92129146acb9c172893a0750fdfed2e76759b896a1f0`; tracker entry excluded
- delivery: source accepted; commit and branch push pending; local plugin installation is a separate decision
- evidence: `git diff --check` passed; Engineering refresh has Delivery & Recovery and checkout lifecycle routes, ten tracker sections and no unresolved template braces; matching setup/refresh and nonmatching Q&A scenarios checked; independent reviewer exercised Engineering and SMDA release/CI failure and cleanup cases; SMDA refresh not run
- next: commit the accepted candidate, push this branch and verify its remote SHA
- updated: 2026-09-30
