# Engineering Plugin

This local Codex plugin bundles the Matt Pocock-derived skills that are already installed in this environment and were selected from `mattpocock/skills`.

## Included skills

- `caveman`
- `diagnose`
- `git-guardrails-claude-code`
- `grill-me`
- `grill-with-docs`
- `handoff`
- `improve-codebase-architecture`
- `migrate-to-shoehorn`
- `prototype`
- `scaffold-exercises`
- `setup-matt-pocock-skills`
- `setup-pre-commit`
- `tdd`
- `to-issues`
- `to-prd`
- `triage`
- `write-a-skill`
- `zoom-out`

## Notes

- Source of truth for the skill contents in this bundle is the copied local skill directories under `skills/`.
- This plugin intentionally uses a Codex-native `.codex-plugin/plugin.json` manifest rather than the upstream `.claude-plugin` format.
- `git-guardrails-claude-code` is included as-is even though parts of it reference Claude-specific settings paths.

## Install as a marketplace

Use the marketplace root one level above this plugin:

```bash
codex plugin marketplace add /Users/danny/Documents/Codex/2026-06-05/codex-cli-slash-command/outputs/engineering-marketplace
```
