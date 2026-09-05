extends RefCounted

static var physics_fields: Dictionary = {}

static func original_static_get(key):
	return physics_fields.get(key)

static func original_mpx(value):
	return value * load("res://game/runtime/js_support.gd").module("Constants").original_static_get("PIXELS_PER_METER")

static func original_pxm(value):
	return value * load("res://game/runtime/js_support.gd").module("Constants").original_static_get("METERS_PER_PIXEL")

static func original_easingCubicBezier(a, b, c, d):
	return func(k): return a * (1 - k) * (1 - k) * (1 - k) + b * 3 * k * (1 - k) * (1 - k) + c * 3 * k * k * (1 - k) + d * k * k * k

static func original_initUIGamePhysics(game):
	game.physics.p2 = load("res://game/presentation/physics/p2_world.gd").new(game)
	for key in ["wall", "tank", "fragment", "crate", "puff", "ray", "shield", "spawn"]:
		physics_fields[key + "CollisionGroup"] = game.physics.p2.createCollisionGroup()
	for key in ["wall", "tank", "fragment", "puff"]:
		physics_fields[key + "Material"] = game.physics.p2.createMaterial(key)
	var puff = game.physics.p2.createContactMaterial(physics_fields.wallMaterial, physics_fields.puffMaterial)
	for key in {"restitution": 0, "friction": 1, "relaxation": 10}: game.physics.p2.set_native(puff, key, {"restitution": 0, "friction": 1, "relaxation": 10}[key])
	physics_fields.wallPuffContactMaterial = puff
	var fragment = game.physics.p2.createContactMaterial(physics_fields.wallMaterial, physics_fields.fragmentMaterial)
	game.physics.p2.set_native(fragment, "restitution", 0)
	game.physics.p2.set_native(fragment, "friction", 0)
	physics_fields.wallFragmentContactMaterial = fragment
	for key in ["gameFloor", "trophyFragment"]:
		physics_fields[key + "CollisionGroup"] = game.physics.p2.createCollisionGroup()
		physics_fields[key + "Material"] = game.physics.p2.createMaterial(key)
	var trophy = game.physics.p2.createContactMaterial(physics_fields.gameFloorMaterial, physics_fields.trophyFragmentMaterial)
	game.physics.p2.set_native(trophy, "restitution", 0.35)
	game.physics.p2.set_native(trophy, "friction", 1)
	physics_fields.floorTrophyFragmentContactMaterial = trophy

static func original_getLoadedAssetResolutionScale(pixel_ratio):
	return 2.0 if pixel_ratio > 1.0 else 1.0

static func original_computeButtonTextY(_size, _font_baseline):
	var constants = load("res://game/runtime/js_support.gd").module("UIConstants")
	return (constants.original_static_get("BUTTON_SHADOW_HEIGHT_TOP") - constants.original_static_get("BUTTON_SHADOW_HEIGHT_BOTTOM")) / 2.0

static func original_addButton(button, pressed, released, clicked, context):
	button.on_pressed = pressed
	button.on_released = released
	button.on_clicked = clicked
	button.callback_context = weakref(context)
