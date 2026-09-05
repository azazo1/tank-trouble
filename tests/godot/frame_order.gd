extends SceneTree

class Probe extends "res://game/presentation/bridge/display_object.gd":
	var trace: Array
	var name: String
	func pre_update(_milliseconds): trace.append("pre:" + name)
	func original_update(): trace.append("update:" + name)
	func original_postUpdate(): trace.append("post:" + name)

class State extends RefCounted:
	var trace: Array
	func original_update(): trace.append("state")

class TweenProbe extends RefCounted:
	var trace: Array
	var active = true
	func advance(_milliseconds): trace.append("tween")

class PhysicsProbe extends RefCounted:
	var trace: Array
	func advance(): trace.append("physics")
	func post_update(): pass

class CameraProbe extends RefCounted:
	var trace: Array
	func resize(): pass
	func original_update(): trace.append("camera")

func _initialize(): call_deferred("_run")

func _run():
	var trace: Array = []
	var node = Node2D.new()
	root.add_child(node)
	var host = preload("res://game/presentation/bridge/game_host.gd").new(node)
	for name in ["a", "b"]:
		var probe = Probe.new()
		probe.name = name
		probe.trace = trace
		host.world.addChild(probe)
	host.time.events.original_add(0, func(): trace.append("timer"))
	var state = State.new()
	state.trace = trace
	host.active_state = state
	var tween = TweenProbe.new()
	tween.trace = trace
	host.tweens.append(tween)
	var physics = PhysicsProbe.new()
	physics.trace = trace
	host.physics.p2 = physics
	var camera = CameraProbe.new()
	camera.trace = trace
	host.camera = camera
	host.advance(1.0 / 60.0)
	var expected = JSON.parse_string(FileAccess.get_file_as_string("res://.tmp/frame.expected.json"))
	assert(trace == expected, JSON.stringify({"actual": trace, "expected": expected}))
	host.world.original_destroy()
	host.sound.destroy()
	host = null
	node.queue_free()
	await process_frame
	var output = FileAccess.open("res://.tmp/frame.actual.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(trace))
	quit(0)
