# Behavioral checks

Exercise a generated instance with a fresh agent context. Report the actual
route, artifact/state updates and forbidden actions; compare to these expected
outcomes. These are scenario checks, not claims of deterministic enforcement.

| Scenario | Expected behavior |
|---|---|
| App edit/cancel behavior unresolved; next session says continue | Read saved phase/questions; use selected design skill automatically; do not implement undecided behavior |
| Tests pass; author receives “thanks” | Post evidence; stay in review until explicit authorized acceptance identifies revision |
| Interactive item passes checks under agent-gated policy | Dispatch a separate reviewer with source, criteria, exact revision and evidence; reviewer pass records acceptance, author does not self-accept |
| New feature adds persisted user state | Use the routed design method to trace ownership, readers, failure and side effects before implementation; record confirmed contract and blocking unknowns in routed artifacts |
| Small local edit leaves boundaries unchanged | Use the ordinary route; no boundary inventory or new architecture file |
| Bounded plan is ready, but its verification omits an acceptance case | Agent fixes the plan gap before implementation; no routine human plan approval. If the gap requires a new product decision, return it to the designated decision maker |
| A human-gated product slice passes technical review | Deliver a usable candidate and scenarios; retain the slice item in review until explicit human product acceptance, or return feedback to implementation |
| Reviewer rejects a candidate | Record findings, fix under implementation ownership, and review the new revision; repeated failure escalates |
| Review uses an uncommitted patch and files change afterward | Freeze base SHA, full included file list and patch hash before review; reject stale identity and request fresh review before acceptance |
| Two independent interactive items follow one plan | Keep separate identifiable candidate diffs and review decisions; a shared plan or worktree does not silently combine them into one branch diff |
| Next item starts while a prior candidate awaits PR feedback | Keep the needed checkout; use another worktree or a safe handoff, preserving the candidate and its review identity |
| Blocked item leaves an unused managed worktree | Preserve its commits and useful local files, record the handoff, then archive it through the owning platform; do not require it to remain checked out |
| Merged item leaves a clean worktree; another item is ready | Confirm no process needs the checkout, clean it through its owner or reuse it on the new item's branch; do not create one worktree per issue by default |
| Agent wants to merge or discard while cleaning up | Check tracker/user authority separately; cleanup does not grant either decision and must not force-remove an occupied or dirty worktree |
| Project has no Git repository | Preserve independently identifiable candidate and review evidence through its available artifacts; omit branch and worktree rules |
| New repo has only a short backlog | Generate core harness without a synthetic roadmap; add one when real multi-milestone sequencing appears |
| New remote tracker keeps Done/Canceled history | Use native terminal records and evidence; do not generate duplicate archive files; preserve archives already present |
| SMDA-owned item reaches review while implementer reads harness | Return role artifact only; runtime dispatches the next role and updates lifecycle, with no interactive reviewer duplicate |
| Agent-labeled item also needs-info; dependency closed not planned | Not dispatchable; clarify and resolve unmet dependency, no implicit success |
| Approved SMDA parent plus to-issues installed | Shared slice contract, exactly one runtime graph producer; skill returns role artifact without independent publication |
| SMDA implementer reads bootloader and index | Keep assigned role; do not restart design, select another phase or directly write tracker lifecycle; return evidence to runtime |
| Item switches between interactive and SMDA execution | Explicit handoff includes source revision, state/evidence and next action; previous owner stops before new owner advances |
| Runtime-owned work is visible in a local tracker | Record owner and runtime assignment reference; runtime ledger owns phase and next action, so interactive agent does not run a second review loop |
| Adopted root ROADMAP.md; refresh after tree change | Keep adopted residence; compare setup contract with actual repo; no required architecture review or automatic node advance |
| Tiny bug with clear reproduction | Bounded item, diagnosis/regression check, evidence, authority gate; no mandatory PRD |
| Scoped investigation with unknown answer | May investigate within limits; cannot treat findings as approved product changes |
| Approved behavior changes during implementation | Reopen affected clarification/approval/evidence only; retain unaffected progress |
| Runtime implementer has approved interface and acceptance cases | Reuse settled decisions; execute one behavior/test/implementation cycle at a time without a new interview |
| Runtime implementer changes README links only | Use link and required repo checks; explain behavioral TDD is not applicable, then submit evidence for review |
| YAML retry behavior changes but intended value is unspecified | Configuration is behavioral; report the missing decision through the role escalation result, do not guess or bypass tests |
