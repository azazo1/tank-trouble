extends "res://game/presentation/bridge/display_object.gd"

var native_player
var mesh_view = preload("res://game/presentation/animation/spine_mesh.gd").new()
var setup_bounds: Rect2

func _construct_create(host = null, horizontal = null, vertical = null, key = null, _premultiplied = null, flip_x = null, _g = null, _h = null, _i = null, _j = null, _k = null, _l = null, _m = null, _n = null, _o = null, _p = null):
	game = host
	x = horizontal
	y = vertical
	native_player = ClassDB.instantiate("TTOriginalSpine")
	var directory = "res://assets/original/images/%s/" % key
	var resource_name = key + ("@2x" if game.assets.resolution == 2 else "")
	var texture = game.assets.load_texture(directory + resource_name + ".png")
	mesh_view.textures[resource_name + ".png"] = texture
	var images = {resource_name + ".png": {"width": texture.get_width(), "height": texture.get_height()}}
	var atlas = FileAccess.get_file_as_string(directory + resource_name + ".atlas")
	var data = JSON.parse_string(FileAccess.get_file_as_string(directory + key + ".json"))
	assert(native_player.initialize(atlas, data, images, JS.truthy(flip_x)), "Spine 资源加载失败")
	view.add_child(mesh_view)
	mesh_view.geometry = native_player.geometry()
	var first = true
	for item in mesh_view.geometry:
		for index in range(0, item.vertices.size(), 2):
			var point = Vector2(item.vertices[index], -item.vertices[index + 1])
			if first: setup_bounds = Rect2(point, Vector2.ZERO); first = false
			else: setup_bounds = setup_bounds.expand(point)
	return null

func getLocalBounds():
	return {"x": -setup_bounds.size.x * anchor.x, "y": -setup_bounds.size.y * (1.0 - anchor.y), "width": setup_bounds.size.x, "height": setup_bounds.size.y}

func sync_view():
	super.sync_view()
	mesh_view.position = -setup_bounds.position - setup_bounds.size * Vector2(anchor.x, 1.0 - anchor.y)

func setMixByName(from, to, duration, _easing = null):
	native_player.set_mix(from, to, duration)

func setAnimationByName(track, animation, loop = false):
	native_player.set_animation(track, animation, JS.truthy(loop))

func addAnimationByName(track, animation, loop = false, delay = 0.0):
	native_player.add_animation(track, animation, JS.truthy(loop), float(delay))

func clearTrack(track):
	native_player.clear_track(track)

func getCurrentAnimationForTrack(track):
	return native_player.current_animation(track)

func original_update():
	if not exists: return null
	native_player.advance(game.time.elapsed / 1000.0)
	mesh_view.geometry = native_player.geometry()
	mesh_view.queue_redraw()
	return null
