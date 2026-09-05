extends RefCounted

var parent: WeakRef
var streams: Dictionary = {}
var paths: Dictionary = {}
var sounds: Array = []
var one_shots: Array[WeakRef] = []
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
	if not streams.has(key): streams[key] = load(paths[key])
	var player = AudioStreamPlayer.new()
	player.stream = streams[key]
	if loop:
		player.stream = player.stream.duplicate()
		player.stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		player.stream.loop_end = int(player.stream.get_length() * player.stream.mix_rate)
	player.volume_linear = volume
	parent.get_ref().add_child(player)
	one_shots.append(weakref(player))
	if not loop: player.finished.connect(player.queue_free)
	player.play()
	log.debug("播放原版音效", {"sound": key})
	return player

func stream(key):
	assert(paths.has(key), "音频资源不存在: " + str(key))
	if not streams.has(key): streams[key] = load(paths[key])
	return streams[key]

func create(key, volume = 1.0, loop = false):
	var sound = preload("res://game/presentation/audio/original_sound.gd").new(self, key, volume, loop)
	sounds.append(sound)
	return sound

func stopAll():
	for sound in sounds: sound.stop()
	_clear_one_shots()

func _clear_one_shots():
	for reference in one_shots:
		var player = reference.get_ref()
		if player == null: continue
		player.stop()
		player.stream = null
		player.queue_free()
	one_shots.clear()

func destroy():
	for sound in sounds: sound.destroy()
	sounds.clear()
	_clear_one_shots()
	streams.clear()
