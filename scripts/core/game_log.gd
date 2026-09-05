class_name GameLog
extends RefCounted

static var _log_file: FileAccess

static func _write(level: String, message: String) -> void:
	if _log_file == null:
		var user_dir := DirAccess.open("user://")
		if user_dir:
			user_dir.make_dir_recursive("logs")
		_log_file = FileAccess.open("user://logs/game.log", FileAccess.WRITE_READ)
	if _log_file:
		_log_file.seek_end()
		_log_file.store_line("%s [%s] %s" % [Time.get_datetime_string_from_system(), level, message])

static func info(message: String) -> void:
	_write("INFO", message)

static func warn(message: String) -> void:
	_write("WARN", message)
	push_warning("[WARN] %s" % message)
