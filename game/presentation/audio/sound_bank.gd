extends RefCounted

var parent: WeakRef
var streams: Dictionary = {}
var paths: Dictionary = {}
var log = preload("res://game/runtime/original_log.gd").create("Audio")

func _init(node = null):
	if node != null: parent = weakref(node)
	var manifest = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/audio-manifest.json"))
	for item in manifest.files:
		var name = str(item.path).get_file().get_basename()
		var key = name.substr(0, 1).to_lower() + name.substr(1)
		if key.length() > 2 and key.right(2).is_valid_int(): key = key.left(-2) + str(int(key.right(2)))
		paths[key] = "res://" + item.path

func original_play(key, volume = 1.0, loop = false):
	assert(paths.has(key), "音频资源不存在: " + str(key))
	if not streams.has(key): streams[key] = AudioStreamWAV.load_from_file(paths[key])
	var player = AudioStreamPlayer.new()
	player.stream = streams[key]
	player.volume_linear = volume
	parent.get_ref().add_child(player)
	if not loop: player.finished.connect(player.queue_free)
	player.play()
	log.debug("播放原版音效", {"sound": key})
	return player
