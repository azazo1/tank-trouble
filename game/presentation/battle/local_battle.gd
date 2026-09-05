extends "res://game/ported/presentation/battle/uilocalbattlestate.gd"

signal leave_requested
var owned_groups: Array = []

func initialize(host, controller):
	game = host
	original_init(controller)
	JS.module("QualityManager").original_setQuality("high")
	var previous = host.world.children.duplicate()
	original_create()
	for child in host.world.children:
		if not previous.has(child): owned_groups.append(child)
	host.active_state = self

func original__leaveState():
	leave_requested.emit()

func shutdown():
	game.active_state = null
	original_shutdown()
	for group in owned_groups:
		game.world.removeChild(group)
		group.original_destroy()
	owned_groups.clear()
	game.tweens.clear()
	game.time.events.pending.clear()
	game.sound.destroy()
	game.physics.p2.clear()
	game.physics.erase("p2")
	game.reset_input()
	original_destroy()
