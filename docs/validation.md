# Validation evidence

## Source provenance

- Upstream repo: `https://github.com/bitwes/Gut`
- Upstream commit copied from: `63431875473bec0b573617b92407f019d0e3b957`
- Upstream payload copied into repo root: `addons/gut/`

## Commands run

From the repo root:

```bash
cd .testbed
godotenv addons install
cd ..
godot --headless --path .testbed --import
godot --headless --path .testbed --script addons/aerobeat-vendor-godot-unit-test/gut_cmdln.gd \
  -gdir=res://tests \
  -ginclude_subdirs \
  -gexit
```

## Observed result

- `godotenv addons install` succeeded with:
  - repo self-install as `aerobeat-vendor-godot-unit-test`
  - local symlink install of `aerobeat-tool-headless-manager`
- `godot --headless --path .testbed --import` completed successfully on Godot `4.6.2.stable.official.71f334935`
- Gut smoke suite result:
  - scripts: `1`
  - tests: `2`
  - passing tests: `2`
  - asserts: `7`
  - final status: `---- All tests passed! ----`

## What this proves

- the vendorized Gut CLI runner loads from the AeroBeat mount path `res://addons/aerobeat-vendor-godot-unit-test/...`
- the hidden `.testbed/` manifest is compatible with the repo-root symlink contract
- the repo-local smoke tests can execute through the transplanted Gut runner successfully
