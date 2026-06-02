# AeroBeat Vendor Template

This is the official template for creating **vendor adapter** repositories within the current AeroBeat v1 architecture.

It should be read against the locked product direction from `aerobeat-docs`:

- **Current outer-shell provider example:** mod.io
- **Public product-facing manager stays AeroBeat-owned:** product repos consume `aerobeat-tool-api`, not raw provider repos
- **Vendor repo role:** isolate provider transport, DTO mapping, and provider-specific orchestration behind an explicit seam
- **Current concrete example:** `aerobeat-vendor-modio`

## Naming rule: use vendor-specific facade/singleton names

Vendor repos should teach their actual provider identity in code and docs.

After cloning this template, rename any public-facing facade/workbench helpers to the vendor-specific final name for that repo, for example:

- `aerobeat-vendor-modio` → `ModioVendorFacade.gd`
- a future Steam-backed provider repo → `SteamVendorFacade.gd`

Do **not** leave generic names such as `AeroToolManager`, `VendorManager`, or a vendor-agnostic facade as the shipped public teaching surface.

## Recommended seam shape

A vendor repo should keep a clean split between the narrow vendor-local facade seam and the deeper provider implementation details.

```text
aerobeat-vendor-<provider>/
├── src/
│   ├── facade/
│   │   └── <Provider>VendorFacade.gd
│   ├── adapters/
│   │   ├── <provider>_client.gd
│   │   └── <provider>_request_builder.gd
│   ├── models/
│   │   └── provider/
│   └── mapping/
├── .testbed/
│   ├── addons.jsonc
│   ├── fixtures/
│   ├── scenes/
│   └── tests/
├── plugin.cfg
├── LICENSE.md
└── README.md
```

The facade exists for vendor-local composition, smoke tests, and workbench ergonomics. The provider-specific DTOs, auth flows, request building, and error normalization stay behind that seam instead of leaking into product repos.

## GodotEnv development flow

This repo uses the AeroBeat package-repo `.testbed/` workbench pattern.

- Canonical dev/test manifest: `.testbed/addons.jsonc`
- Installed dev/test addons: `.testbed/addons/`
- Hidden workbench project: `.testbed/project.godot`
- Repo-local tests/fixtures: `.testbed/tests/`, `.testbed/fixtures/`, and optional `.testbed/scenes/`

Typical local validation flow from repo root:

```bash
cd .testbed
godotenv addons install
cd ..
godot --headless --path .testbed --import
godot --headless --path .testbed --script addons/gut/gut_cmdln.gd \
  -gdir=res://tests \
  -ginclude_subdirs \
  -gexit
```

## Dependency contract

- `aerobeat-tool-core` is allowed when the provider adapter needs shared tool/workflow contracts.
- Additional dependencies should remain explicit and narrow.
- Product/assembly repos should still consume the AeroBeat-facing manager layer rather than depending on vendor repos as their primary contract.
