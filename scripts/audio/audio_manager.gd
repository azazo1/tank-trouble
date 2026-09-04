class_name AudioManager
extends Node

var players: Array[AudioStreamPlayer] = []
var enabled := true

func _ready() -> void:
	for index in 6:
		var player := AudioStreamPlayer.new()
		var generator := AudioStreamGenerator.new()
		generator.mix_rate = 22050.0
		generator.buffer_length = 0.35
		player.stream = generator
		player.bus = &"Master"
		add_child(player)
		players.append(player)

func play_event(event_name: String) -> void:
	if not enabled:
		return
	var tones := {
		"fire": [210.0, 0.08, 0.16],
		"bounce": [720.0, 0.045, 0.12],
		"hit": [92.0, 0.16, 0.25],
		"pickup": [540.0, 0.12, 0.16],
		"shield": [340.0, 0.18, 0.13],
		"countdown": [440.0, 0.1, 0.12],
		"win": [660.0, 0.35, 0.16]
	}
	if not tones.has(event_name):
		return
	var tone: Array = tones[event_name]
	var player: AudioStreamPlayer = players[Time.get_ticks_msec() % players.size()]
	player.play()
	var playback := player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return
	var frames := int(22050.0 * float(tone[1]))
	var buffer := PackedVector2Array()
	buffer.resize(frames)
	for index in frames:
		var progress := float(index) / float(frames)
		var envelope := (1.0 - progress) * (1.0 - progress)
		var sample := sin(TAU * float(tone[0]) * progress) * envelope * float(tone[2])
		buffer[index] = Vector2(sample, sample)
	playback.push_buffer(buffer)

