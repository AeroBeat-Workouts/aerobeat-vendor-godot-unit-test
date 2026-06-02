# Upstream Gut divergence notes

## Source basis

- Upstream repo: `https://github.com/bitwes/Gut`
- Upstream commit used for this vendor materialization: `63431875473bec0b573617b92407f019d0e3b957`
- Upstream payload copied into repo root: `addons/gut/`

## Intentional AeroBeat-specific changes

1. Rebased addon payload from upstream `addons/gut/` to this repo root.
2. Rewrote hardcoded `res://addons/gut/...` paths to `res://addons/aerobeat-vendor-godot-unit-test/...` so the plugin and CLI runner work when consumers install this repo under the truthful AeroBeat package key.
3. Replaced the template-era hidden `.testbed/` manifest with a repo-self symlink manifest and added `aerobeat-tool-headless-manager` in canonical local symlink form.
4. Replaced template smoke tests with package-contract smoke coverage for the new mount path and documented provenance.

## Known remaining gap vs full upstream repo parity

This repo intentionally does not carry every non-addon top-level file from upstream Gut. The current slice focuses on the addon/plugin/CLI source actually used to run tests in consuming AeroBeat projects.
