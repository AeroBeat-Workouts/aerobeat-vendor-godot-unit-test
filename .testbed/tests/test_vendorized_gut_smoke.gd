extends "res://addons/aerobeat-vendor-godot-unit-test/test.gd"

func test_vendorized_gut_mount_path_is_truthful() -> void:
	assert_file_exists("res://addons/aerobeat-vendor-godot-unit-test/gut_cmdln.gd")
	assert_file_exists("res://addons/aerobeat-vendor-godot-unit-test/plugin.cfg")
	assert_file_does_not_exist("res://addons/gut/gut_cmdln.gd")

func test_vendorized_gut_readme_documents_upstream_divergence() -> void:
	var readme_path := ProjectSettings.globalize_path("res://../README.md")
	assert_true(FileAccess.file_exists(readme_path), "README.md should exist at the repo root")
	var file := FileAccess.open(readme_path, FileAccess.READ)
	assert_true(file != null, "README.md should open cleanly")
	var readme_text := file.get_as_text()
	assert_string_contains(readme_text, "upstream Gut commit `63431875473bec0b573617b92407f019d0e3b957`")
	assert_string_contains(readme_text, "res://addons/aerobeat-vendor-godot-unit-test")
