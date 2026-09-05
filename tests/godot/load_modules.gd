extends SceneTree

func _initialize():
	call_deferred("_run")

func _run():
	var extension = GDExtensionManager.load_extension("res://game/native/tank_trouble.gdextension")
	if extension != GDExtensionManager.LOAD_STATUS_OK and extension != GDExtensionManager.LOAD_STATUS_ALREADY_LOADED:
		push_error("无法加载原生物理扩展: %s" % extension)
		quit(1)
		return
	var paths = JSON.parse_string(FileAccess.get_file_as_string("res://game/ported/module-index.json"))
	var failed: Array = []
	for module_name in paths:
		var script = load(paths[module_name])
		if script == null or not script.can_instantiate(): failed.append(module_name)
	var output = FileAccess.open("res://.tmp/module-load.json", FileAccess.WRITE)
	output.store_string(JSON.stringify({"total": paths.size(), "failed": failed}))
	quit(0 if failed.is_empty() else 1)
