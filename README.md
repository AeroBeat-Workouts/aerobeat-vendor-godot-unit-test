# aerobeat-vendor-godot-unit-test

AeroBeat-packaged vendor copy of upstream [Gut](https://github.com/bitwes/Gut) for Godot unit testing.

## What this repo is

This repo vendors the **real Gut addon source used to run tests** at the **repo root** so AeroBeat consumers can mount this package directly with the repo key `aerobeat-vendor-godot-unit-test`.

The source payload was materialized from upstream Gut commit `63431875473bec0b573617b92407f019d0e3b957` (main branch snapshot dated 2026-05-19) by copying `addons/gut/` to this repo root, then applying the smallest AeroBeat-specific packaging adjustments needed for the new manifest contract.

## Consumer manifest contract

Consumers should mount this repo by symlinking or installing the repo root with the truthful AeroBeat package key:

```jsonc
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  "addons": {
    "aerobeat-vendor-godot-unit-test": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-vendor-godot-unit-test.git",
      "checkout": "main",
      "subfolder": "/"
    }
  }
}
```

When a headless AeroBeat workflow also needs the in-engine quit sentinel, add the headless manager package alongside it:

```jsonc
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  "addons": {
    "aerobeat-vendor-godot-unit-test": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-vendor-godot-unit-test.git",
      "checkout": "main",
      "subfolder": "/"
    },
    "aerobeat-tool-headless-manager": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-tool-headless-manager.git",
      "checkout": "main",
      "subfolder": "/"
    }
  }
}
```

## Important upstream divergence

This repo intentionally diverges from upstream Gut in one important packaging detail:

- upstream Gut assumes it is mounted at `res://addons/gut/...`
- AeroBeat consumers mount this repo at `res://addons/aerobeat-vendor-godot-unit-test/...`
- to preserve runner/plugin behavior under the AeroBeat manifest contract, upstream hardcoded `res://addons/gut` references were rewritten to `res://addons/aerobeat-vendor-godot-unit-test`

That path rewrite is the main functional divergence. The goal was to keep the meaningful source/test-running behavior materially aligned with upstream Gut while making the repo truthful for AeroBeat's root-symlink package model.

A secondary packaging divergence is that this repo keeps only the upstream addon payload at repo root plus AeroBeat repo-local docs and hidden `.testbed/` validation scaffolding. It does **not** attempt to mirror every upstream top-level repo artifact outside the addon payload.

For the original upstream README snapshot used for comparison, see `docs/UPSTREAM_GUT_README.md`.

## Repo-local development flow

This repo uses the AeroBeat hidden `.testbed/` workbench pattern.

- Canonical dev/test manifest: `.testbed/addons.jsonc`
- Installed dev/test addons: `.testbed/addons/`
- GodotEnv cache: `.testbed/.addons/`
- Hidden workbench project: `.testbed/project.godot`
- Repo-local smoke tests: `.testbed/tests/`

### Restore dev/test dependencies

From the repo root:

```bash
cd .testbed
godotenv addons install
```

### Import smoke check

From the repo root:

```bash
godot --headless --path .testbed --import
```

### Run the repo-local Gut smoke suite

From the repo root:

```bash
godot --headless --path .testbed --script addons/aerobeat-vendor-godot-unit-test/gut_cmdln.gd \
  -gdir=res://tests \
  -ginclude_subdirs \
  -gexit
```

## Follow-up note

If AeroBeat later needs closer parity with more of upstream Gut's **non-addon** top-level repo content (for example additional docs, example project surface, or broader upstream self-validation assets), that should be tracked as a separate follow-up. The current slice focuses on the addon/plugin/CLI payload actually used to run tests inside consuming projects.
