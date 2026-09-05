class_name GameAudio
extends Node

var streams: Dictionary = {}

func _ready() -> void:
	var names := ["countdown", "fire_bullet", "bounce", "fire_laser", "fire_shotgun", "fire_mine", "shield", "explosion", "winner"]
	var files := ["CountDown00.wav", "FireBullet00.wav", "BulletBounce00.wav", "FireLaser.wav", "FireShotgun.wav", "FireMine.wav", "ShieldActivate.wav", "TankExplosion00.wav", "WinnerCelebration.wav"]
	for i in range(names.size()):
		streams[names[i]] = load("res://assets/audio/%s" % files[i])

func play(effect_name: String, volume_db: float = 0.0) -> void:
	if not streams.has(effect_name) or streams[effect_name] == null:
		return
	var player := AudioStreamPlayer.new()
	player.stream = streams[effect_name]
	player.volume_db = volume_db
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
