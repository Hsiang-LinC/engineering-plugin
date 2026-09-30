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
