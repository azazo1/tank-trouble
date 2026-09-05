extends RefCounted

var target: String
static var debug_enabled := false

static func create(name = ""):
	var instance = load("res://game/runtime/original_log.gd").new()
	instance.target = str(name)
	return instance

func debug(message = "", data = null):
	if debug_enabled:
		_write("debug", message, data)

func warn(message = "", data = null):
	_write("warn", message, data)

func error(message = "", data = null):
	_write("error", message, data)
	push_error("[%s] %s" % [target, message])

func info(message = "", data = null):
	_write("info", message, data)

func _write(level: String, message, data):
	var record := {"time": Time.get_datetime_string_from_system(true), "level": level, "target": target, "message": str(message)}
	if data != null:
		record["data"] = data
	var path := "user://tank-trouble.jsonl"
	var file := FileAccess.open(path, FileAccess.READ_WRITE if FileAccess.file_exists(path) else FileAccess.WRITE)
	if file:
		file.seek_end()
		file.store_line(JSON.stringify(record))
