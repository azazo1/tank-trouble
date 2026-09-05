extends RefCounted

static func original_static_get(key):
	match key:
		"Easing":
			return {"Back": {"Out": "Back.Out"}, "Linear": {"None": "Linear.None"}, "Quadratic": {"InOut": "Quadratic.InOut", "Out": "Quadratic.Out"}, "Cubic": {"Out": "Cubic.Out"}}
		"blendModes": return {"NORMAL": 0, "ADD": 1}
		"EMITTER": return 11
		"GROUP": return 7
		"Keyboard": return {"ESC": KEY_ESCAPE, "ENTER": KEY_ENTER, "W": KEY_W, "A": KEY_A, "S": KEY_S, "D": KEY_D, "Q": KEY_Q, "UP": KEY_UP, "DOWN": KEY_DOWN, "LEFT": KEY_LEFT, "RIGHT": KEY_RIGHT, "SPACEBAR": KEY_SPACE}
		"Point": return load("res://game/presentation/bridge/point.gd")
		"Image", "Sprite": return load("res://game/presentation/bridge/image.gd")
		"Rectangle": return load("res://game/presentation/bridge/rectangle.gd")
		"Physics": return {"P2": {"Body": load("res://game/presentation/physics/p2_body.gd")}}
		"Math": return {"angleBetween": func(x1, y1, x2, y2): return atan2(y2 - y1, x2 - x1)}
	return null
