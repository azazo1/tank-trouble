extends "res://game/ported/presentation/engine/phasercamera.gd"

const Rectangle = preload("res://game/presentation/bridge/rectangle.gd")
var host: WeakRef
var view = Rectangle.create()
var bounds = Rectangle.create()
var displayObject: WeakRef
var scale
var roundPx = true
var atLimit = {"x": false, "y": false}
var _shake = {"duration": 0, "x": 0, "y": 0, "shakeBounds": true}
var _fxDuration = 0
var world_width = 0.0
var world_height = 0.0
var width:
	get: return view.width
var height:
	get: return view.height

func _init(game = null):
	if game == null: return
	host = weakref(game)
	displayObject = weakref(game.world)
	scale = game.world.scale
	reset()

func resize():
	var game = host.get_ref()
	if view.width == game.width and view.height == game.height: return
	view.width = game.width
	view.height = game.height
	bounds.width = maxf(world_width, width)
	bounds.height = maxf(world_height, height)

func set_world_bounds(horizontal, vertical, horizontal_size, vertical_size):
	resize()
	world_width = horizontal_size
	world_height = vertical_size
	# Phaser.World.setBounds 保证相机边界至少与画布等大.
	bounds.setTo(horizontal, vertical, maxf(horizontal_size, width), maxf(vertical_size, height))

func reset():
	world_width = 0.0
	world_height = 0.0
	resize()
	view.x = 0.0
	view.y = 0.0
	bounds.setTo(0, 0, width, height)
	displayObject.get_ref().position.setTo(0, 0)
