extends RefCounted

var down: Dictionary = {}
var pressed_at: Dictionary = {}

func handle(event):
	if not event is InputEventKey: return
	var code = event.physical_keycode if event.physical_keycode != 0 else event.keycode
	down[code] = event.pressed
	if event.pressed and not event.echo: pressed_at[code] = Time.get_ticks_msec()
	if not event.pressed: pressed_at.erase(code)

func isDown(code):
	return down.get(int(code), false)

func downDuration(code, duration):
	return isDown(code) and Time.get_ticks_msec() - pressed_at.get(int(code), 0) <= duration

func reset():
	down.clear()
	pressed_at.clear()
