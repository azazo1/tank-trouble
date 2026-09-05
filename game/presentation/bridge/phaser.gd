extends RefCounted

static func original_static_get(key):
	match key:
		"Easing":
			return {"Back": {"Out": "Back.Out"}, "Linear": {"None": "Linear.None"}, "Quadratic": {"InOut": "Quadratic.InOut"}}
		"Keyboard": return {"ESC": KEY_ESCAPE}
	return null
