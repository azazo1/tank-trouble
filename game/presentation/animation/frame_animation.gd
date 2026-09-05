extends RefCounted

var actor: WeakRef
var entries: Dictionary = {}
var currentAnim
var frame_index = 0
var elapsed = 0.0

func _init(sprite):
	actor = weakref(sprite)

func add(name, frames, rate = 60, loop = false):
	var entry = {"name": name, "frames": frames, "frameRate": rate, "loop": loop, "isPlaying": false, "onComplete": preload("res://game/presentation/bridge/event_signal.gd").new()}
	entries[name] = entry
	return entry

func play(name, rate = null, loop = null):
	if currentAnim != null and currentAnim.name == name and currentAnim.isPlaying: return currentAnim
	if currentAnim != null: currentAnim.isPlaying = false
	currentAnim = entries[name]
	if rate != null: currentAnim.frameRate = rate
	if loop != null: currentAnim.loop = loop
	currentAnim.isPlaying = true
	frame_index = 0
	elapsed = 0.0
	actor.get_ref().frameName = currentAnim.frames[0]
	return currentAnim

func stop(_name = null, reset_frame = false):
	if currentAnim == null: return
	currentAnim.isPlaying = false
	if reset_frame: actor.get_ref().frameName = currentAnim.frames[0]

func advance(milliseconds):
	if currentAnim == null or not currentAnim.isPlaying: return
	elapsed += milliseconds
	var interval = 1000.0 / currentAnim.frameRate
	if elapsed < interval: return
	var count = int(floor(elapsed / interval))
	elapsed -= count * interval
	frame_index += count
	if frame_index >= currentAnim.frames.size():
		if currentAnim.loop: frame_index %= currentAnim.frames.size()
		else:
			frame_index = currentAnim.frames.size() - 1
			currentAnim.isPlaying = false
			actor.get_ref().frameName = currentAnim.frames[frame_index]
			currentAnim.onComplete.dispatch([actor.get_ref(), currentAnim])
			return
	actor.get_ref().frameName = currentAnim.frames[frame_index]

func clear():
	for entry in entries.values(): entry.onComplete.removeAll()
	entries.clear()
	currentAnim = null
