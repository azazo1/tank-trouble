extends RefCounted

var bank: WeakRef
var key
var player: AudioStreamPlayer
var fade_tween: Tween
var loop = false
var volume = 1.0:
	set(value):
		volume = value
		if is_instance_valid(player): player.volume_linear = value
var isPlaying:
	get: return is_instance_valid(player) and player.playing
var onStop = preload("res://game/presentation/bridge/event_signal.gd").new()

func _init(owner, sound_key, initial_volume = 1.0, looping = false):
	bank = weakref(owner)
	key = sound_key
	volume = initial_volume
	loop = looping

func play(_marker = "", position = 0.0, loudness = null, looping = null, force_restart = true):
	if isPlaying and not force_restart: return self
	_cancel_fade()
	if loudness != null: volume = loudness
	if looping != null: loop = looping
	if not is_instance_valid(player):
		player = AudioStreamPlayer.new()
		bank.get_ref().parent.get_ref().add_child(player)
		player.finished.connect(_finished)
	var stream = bank.get_ref().stream(key)
	if loop:
		stream = stream.duplicate()
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		stream.loop_end = int(stream.get_length() * stream.mix_rate)
	player.stream = stream
	player.volume_linear = volume
	player.play(position)
	return self

func stop():
	_cancel_fade()
	if is_instance_valid(player): player.stop()
	onStop.dispatch([self])
	return self

func _finished():
	onStop.dispatch([self])

func fadeOut(milliseconds):
	_cancel_fade()
	if isPlaying:
		fade_tween = player.create_tween()
		fade_tween.tween_property(player, "volume_linear", 0.0, milliseconds / 1000.0)
		fade_tween.tween_callback(stop)
	return self

func _cancel_fade():
	if fade_tween != null: fade_tween.kill()
	fade_tween = null

func destroy():
	_cancel_fade()
	onStop.removeAll()
	if is_instance_valid(player):
		player.stop()
		player.stream = null
		player.finished.disconnect(_finished)
		player.queue_free()
	player = null
