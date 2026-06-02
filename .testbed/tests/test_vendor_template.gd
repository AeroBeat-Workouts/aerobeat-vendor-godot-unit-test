extends GutTest

const README_PATH := "../README.md"
const PLUGIN_CFG_PATH := "../plugin.cfg"
const ADDONS_MANIFEST_PATH := "addons.jsonc"
const EXPECTED_PLUGIN_DESCRIPTION := "Template for AeroBeat vendor adapter repos. Teach vendor-specific facade naming and keep provider details behind an explicit seam."

func _read_repo_file(relative_path: String) -> String:
	var absolute_path := ProjectSettings.globalize_path("res://%s" % relative_path)
	assert_true(FileAccess.file_exists(absolute_path), "Expected repo file to exist: %s" % absolute_path)
	var file := FileAccess.open(absolute_path, FileAccess.READ)
	assert_true(file != null, "Expected repo file to open: %s" % absolute_path)
	return file.get_as_text()

func test_readme_keeps_vendor_facade_guidance() -> void:
	var readme_text := _read_repo_file(README_PATH)
	assert_true(readme_text.contains("vendor adapter"), "README should describe the repo as a vendor adapter template")
	assert_true(readme_text.contains("aerobeat-vendor-modio"), "README should mention the current concrete mod.io vendor repo")
	assert_true(readme_text.contains("ModioVendorFacade.gd"), "README should teach vendor-specific facade naming")
	assert_true(readme_text.contains("Do **not** leave generic names such as `AeroToolManager`"), "README should explicitly reject generic shipped naming")
	assert_true(readme_text.contains(".testbed/"), "README should preserve the vendor workbench/testbed story")

func test_plugin_cfg_description_stays_vendor_specific() -> void:
	var config := ConfigFile.new()
	var error := config.load(ProjectSettings.globalize_path("res://%s" % PLUGIN_CFG_PATH))
	assert_eq(error, OK, "plugin.cfg should parse cleanly")
	assert_eq(config.get_value("plugin", "name", ""), "AeroBeat Vendor Template", "plugin.cfg name should stay stable")
	assert_eq(
		config.get_value("plugin", "description", ""),
		EXPECTED_PLUGIN_DESCRIPTION,
		"plugin.cfg description should remain aligned with the vendor adapter template contract"
	)

func test_addons_manifest_keeps_expected_dependencies_only() -> void:
	var manifest_text := _read_repo_file(ADDONS_MANIFEST_PATH)
	assert_true(manifest_text.contains('"aerobeat-tool-core"'), "addons manifest should pin aerobeat-tool-core when vendor repos need shared tool/workflow contracts")
	assert_true(manifest_text.contains('"gut"'), "addons manifest should pin gut for repo-local tests")
	assert_false(manifest_text.contains('"aerobeat-core"'), "addons manifest should not reintroduce stale aerobeat-core drift")
