extends "res://game/presentation/bridge/group.gd"

func _position_x(): return fields.get("emitX", 0)
func _position_y(): return fields.get("emitY", 0)
func _set_position_x(value): fields["emitX"] = value
func _set_position_y(value): fields["emitY"] = value
func _display_width(): return fields.area.width if fields.has("area") else 1
func _display_height(): return fields.area.height if fields.has("area") else 1
func _set_width(value): fields.area.width = value
func _set_height(value): fields.area.height = value

func _get(key):
	if key == "gravity": return fields.get("_gravity")
	if key == "left": return fields.emitX - width / 2.0
	if key == "right": return fields.emitX + width / 2.0
	if key == "top": return fields.emitY - height / 2.0
	if key == "bottom": return fields.emitY + height / 2.0
	return super._get(key)

func _set(key, value):
	if key == "gravity":
		fields._gravity.y = value
		return true
	return super._set(key, value)

func original_kill():
	fields["on"] = false
	return super.original_kill()
