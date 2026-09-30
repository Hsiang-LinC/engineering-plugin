<!-- codex-harness: generated 2026-09-28 -->
# Active Work

Entry format: `docs/harness/index.md` § Conventions.

## harness-base-selection-rule
- status: in-progress
- phase: deliver
- owner: interactive
- source: user decision in this conversation to require dependency-aware branch base selection
- scope: clarify base selection in setup/refresh guidance, generated lifecycle template, Engineering harness and behavioral checks
- non-goals: change merge authority or require one worktree per item
- blocked-by: none
- base: `d098174` (`origin/codex/harness-delivery-lifecycle`); this rule refines its unmerged harness lifecycle change
- branch: `codex/harness-branch-base`
- checkout: `/private/tmp/engineering-harness-branch-base`
- acceptance: an independent item starts from the integration target; a branch based on another feature requires a real dependency and recorded base; existing dirty checkout is preserved
- verify: `git diff --check`; compare generated guidance with Engineering harness; exercise independent and dependent item scenarios
- evidence: `git diff --check` passed; `origin/HEAD` resolves to `origin/main`; independent-B and dependent-B scenarios match the setup skill, generated template and Engineering refresh; SMDA's current harness shows the same missing base-selection sentence and was read-only compared; source/harness patch SHA-256 `c1283d4755552f343cd828d148ea67b408f97dd98bc6b00c04278ed7af624e0d`
- accepted: user reviewed and approved candidate `3acc033ee6a9fb3234373dde4f672af05ef0ed02` in this conversation on 2026-09-30
- delivery: integration into `main` pending after the parent harness branches; retain this item until landed verification and push of `main`
- next: after the parent branches are integrated, merge this candidate into `main`, verify the landed result, push `main`, then archive this item
- updated: 2026-09-30
