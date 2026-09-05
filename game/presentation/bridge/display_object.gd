extends "res://game/runtime/original_object.gd"

const JS = preload("res://game/runtime/js_support.gd")
const Point = preload("res://game/presentation/bridge/point.gd")

var view = Node2D.new()
var fields: Dictionary = {}
var children: Array = []
var game_reference: WeakRef
var position = Point.new()
var scale = Point.new(null, "", Vector2.ONE)
var anchor = Point.new()
var exists = true
var visible = true
var alive = true
var alpha = 1.0
var rotation = 0.0
var intrinsic_size = Vector2.ZERO
var game:
	get: return game_reference.get_ref() if game_reference else null
	set(value): game_reference = weakref(value) if value != null else null
var x:
	get: return position.x
	set(value): position.x = value
var y:
	get: return position.y
	set(value): position.y = value
var width:
	get: return getLocalBounds().width * abs(scale.x)
var height:
	get: return getLocalBounds().height * abs(scale.y)

func _get(key):
	return JS.dereference(fields.get(key))

func _set(key, value):
	fields[key] = JS.weak(value) if key in ["context", "parent", "gameController"] else value
	return true

func addChild(child):
	if child.view.get_parent() != null:
		child.view.get_parent().remove_child(child.view)
	if not children.has(child): children.append(child)
	view.add_child(child.view)
	child.fields["parent"] = weakref(self)
	return child

func original_add(child, _silent = null, _index = null):
	return addChild(child)

func removeChild(child):
	children.erase(child)
	if child.view.get_parent() == view: view.remove_child(child.view)
	child.fields.erase("parent")
	return child

func getLocalBounds():
	var bounds = Rect2(-anchor.value() * intrinsic_size, intrinsic_size)
	var populated = intrinsic_size != Vector2.ZERO
	for child in children:
		var local = child.getLocalBounds()
		var source = Rect2(local.x, local.y, local.width, local.height)
		var transform = Transform2D(child.rotation, child.scale.value(), 0.0, child.position.value())
		var rect = transform * source
		bounds = bounds.merge(rect) if populated else rect
		populated = true
	return {"x": bounds.position.x, "y": bounds.position.y, "width": bounds.size.x, "height": bounds.size.y}

func sync_view():
	view.position = position.value()
	view.scale = scale.value()
	view.rotation = float(rotation)
	view.visible = visible and exists
	view.modulate.a = float(alpha)
	for child in children: child.sync_view()

func original_update():
	if not exists: return null
	for child in children.duplicate():
		if child.exists: JS.invoke_method(child, "update", [])
	return null

func pre_update(milliseconds):
	for child in children:
		if child.exists: child.pre_update(milliseconds)

func original_postUpdate():
	return null

func toLocal(point):
	var local = view.to_local(Vector2(point.x, point.y))
	return Point.create(local.x, local.y)

func original_kill():
	exists = false
	alive = false
	visible = false
	return self

func original_revive():
	exists = true
	alive = true
	visible = true
	return self

func original_destroy(_children = null):
	for child in children.duplicate(): child.original_destroy()
	children.clear()
	fields.clear()
	if is_instance_valid(view): view.queue_free()
	return null
