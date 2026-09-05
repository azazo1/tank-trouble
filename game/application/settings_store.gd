extends RefCounted

const Migration = preload("res://game/application/settings_migration.gd")
const PATH := "user://tank-trouble-settings.json"

var path: String
var values: Dictionary = Migration.DEFAULTS.duplicate(true)
var writable := true
var log = preload("res://game/runtime/original_log.gd").create("Settings")

func _init(storage_path: String = PATH):
	path = storage_path

func load_settings():
	values = Migration.DEFAULTS.duplicate(true)
	writable = true
	if not FileAccess.file_exists(path):
		log.info("使用默认离线设置")
		return values
	var parser = JSON.new()
	var status = parser.parse(FileAccess.get_file_as_string(path))
	var parsed = parser.data
	if status != OK or not parsed is Dictionary:
		writable = false
		log.warn("设置格式损坏, 保留原文件并使用默认值")
		return values
	var result = Migration.migrate(parsed)
	if not result.ok:
		writable = false
		log.warn("无法加载设置版本, 保留原文件并使用默认值", {"reason": result.reason})
		return values
	values = result.values
	if result.from != result.to: log.info("迁移离线设置", {"from": result.from, "to": result.to})
	log.info("加载离线设置", values)
	return values

func save_settings():
	if not writable: return false
	values = Migration.normalize(values)
	var payload = {"schema_version": Migration.CURRENT_VERSION, "values": values.duplicate(true)}
	var temporary_path = path + ".tmp"
	var file = FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		log.error("无法保存离线设置")
		return false
	file.store_string(JSON.stringify(payload) + "\n")
	file.flush()
	var status = file.get_error()
	file.close()
	if status != OK or DirAccess.rename_absolute(temporary_path, path) != OK:
		log.error("无法替换离线设置文件")
		return false
	log.info("保存离线设置", values)
	return true

func set_volume(value):
	values.volume = Migration.normalize({"volume": value}).volume

func set_quality(value):
	values.quality = Migration.normalize({"quality": value}).quality

func set_assignments(value):
	values.assignments = Migration.normalize({"assignments": value}).assignments
