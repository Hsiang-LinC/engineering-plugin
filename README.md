# Engineering Plugin

This local Codex plugin bundles engineering workflow skills for Codex,
including the generic development harness those skills read for tracker,
routing, artifact, and quality-gate context.

## Included skills

- `caveman`
- `diagnose`
- `grill-me`
- `grill-with-docs`
- `handoff`
- `improve-codebase-architecture`
- `migrate-to-shoehorn`
- `prototype`
- `scaffold-exercises`
- `setup-codex-development-harness`
- `setup-pre-commit`
- `tdd`
- `to-issues`
- `to-prd`
- `triage`
- `write-a-skill`
- `zoom-out`

## Notes

- Source of truth for the skill contents in this bundle is the copied local skill directories under `skills/`.
- `setup-codex-development-harness` is the primary per-repo setup: it owns tracker identity, triage labels/states, the long-horizon `roadmap.md`, `docs/harness/quality-gates.md`, Work Production routing, Artifact Adapters, and Domain Docs routing.
- Workflow skills are harness-native. `grill-with-docs` → `to-prd` → `to-issues` → `triage` read `docs/harness/index.md` and `docs/harness/tracker.md` instead of per-skill shadow config.
- SMDA automation belongs in the SMDA plugin/runtime. It should consume the Engineering harness contract and own only SMDA-specific runtime setup, role bindings, and scheduler routing.
- This plugin intentionally uses a Codex-native `.codex-plugin/plugin.json` manifest rather than the upstream `.claude-plugin` format.

## Install as a marketplace

Use the marketplace root that contains this plugin:

```bash
codex plugin marketplace add /Users/danny/codex-local-marketplace
```
