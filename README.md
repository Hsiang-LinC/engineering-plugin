# Engineering Plugin

I maintain this plugin as a personal collection of development skills I have gathered, adapted, and curated through day-to-day software work. It captures the workflows I want available across repositories: establishing durable project context, challenging designs, diagnosing failures, shaping work, and implementing changes behind explicit quality gates.

The collection is intentionally practical. Each skill handles a recognizable task, while the development harness gives workflow-oriented skills a shared understanding of the repository.

## Workflow

I start by running `setup-codex-development-harness` when adopting a new or existing repository. It establishes a durable repository contract for project direction, tracker rules, documentation and artifact routes, and quality gates. This keeps agents from rediscovering the same context in every session and gives later skills a consistent foundation.

From there, I use focused skills as the work requires:

| Skill | Purpose |
| --- | --- |
| `setup-codex-development-harness` | Bootstrap or refresh the repository context that the workflow relies on. |
| `grill-me`, `grill-with-docs` | Pressure-test a plan, resolve ambiguous decisions, and align terminology with domain documentation. |
| `zoom-out`, `improve-codebase-architecture` | Map unfamiliar code or identify focused opportunities to deepen module boundaries. |
| `diagnose`, `tdd` | Reproduce difficult failures, identify root causes, and leave regression coverage through red-green-refactor. |
| `prototype` | Build a deliberately throwaway implementation when a state model or UI direction needs evidence. |
| `to-prd`, `to-issues`, `triage` | Turn an understood problem into durable product context, vertical-slice work items, and tracker-ready work. |
| `swift-dev-guideline` | Apply modern Swift, SwiftUI, SwiftData, concurrency, and Xcode verification conventions. |
| `handoff` | Preserve enough context for another agent or session to continue cleanly. |

## Usage

Set up the repository contract first:

```text
$setup-codex-development-harness Set up this repository around its existing tracker and documentation. Show me the proposed harness before writing it.
```

Shape a feature into executable work:

```text
$grill-with-docs Stress-test this feature against the current domain model.
$to-prd Turn our decisions into a PRD.
$to-issues Break the PRD into tracer-bullet issues.
```

Diagnose and fix a regression:

```text
$diagnose Reproduce this failure, isolate the root cause, and fix it with $tdd.
```

Apply the Swift conventions:

```text
$swift-dev-guideline Review this SwiftUI change and replace legacy APIs without changing behavior.
```

## Additional skills

The plugin also includes focused utilities for communication, repository setup, course authoring, test-data migration, and skill creation:

- `caveman`
- `migrate-to-shoehorn`
- `scaffold-exercises`
- `setup-pre-commit`
- `write-a-skill`

## Installation

Add the local marketplace that contains this plugin:

```bash
codex plugin marketplace add /path/to/codex-local-marketplace
```

### Update the local Engineering plugin

After the desired source changes are integrated, check `codex plugin list` and
the marketplace manifest, then bump `.codex-plugin/plugin.json` to a version
newer than both the installed and marketplace versions. Commit it and run the
following from that commit in this repository. Find the configured `local`
marketplace root with `codex plugin marketplace list`; set `marketplace_root`
to that path.
The `rsync --delete` target is the dedicated `plugins/engineering/` directory,
not the marketplace root.

```bash
set -euo pipefail
marketplace_root="/path/to/codex-local-marketplace"
stage_dir="$(mktemp -d)"
git archive HEAD | tar -x -C "$stage_dir"
python3 - "$marketplace_root" "$stage_dir" <<'PY'
import json
from pathlib import Path
import sys

root, stage = map(Path, sys.argv[1:])
market = json.loads((root / ".agents/plugins/marketplace.json").read_text())
assert market["name"] == "local"
assert any(p["name"] == "engineering" and
           p["source"] == {"source": "local", "path": "./plugins/engineering"}
           for p in market["plugins"])
for plugin in (root / "plugins/engineering", stage):
    assert json.loads((plugin / ".codex-plugin/plugin.json").read_text())["name"] == "engineering"
def version(plugin):
    value = json.loads((plugin / ".codex-plugin/plugin.json").read_text())["version"]
    return tuple(map(int, value.split(".")))
assert version(stage) > version(root / "plugins/engineering")
PY
rsync -a --delete "$stage_dir/" "$marketplace_root/plugins/engineering/"
diff -qr "$stage_dir" "$marketplace_root/plugins/engineering"
codex plugin add engineering@local --json
codex plugin list
```

Check that `codex plugin add` reports the new version and installed path.
Compare the complete staged snapshot with that path using
`diff -qr "$stage_dir" "/reported/installedPath"`, then exercise a changed
skill in a fresh Codex session. Keep the prior source revision or release tag:
if verification fails, restore its contents in a new commit with a still newer
version, then follow this procedure again. Do not reuse a
version number for changed plugin contents: Codex installs a versioned cache
copy. This procedure was rehearsed with an isolated `CODEX_HOME` and temporary
marketplace; it did not update the active installation.
