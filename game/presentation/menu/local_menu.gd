extends "res://game/ported/presentation/game/uimenustate.gd"

signal players_selected(count)
var button_row

func initialize(host):
	game = host
	original_create()
	button_row = host.add.group()
	for button in [onePlayerButton, twoPlayerButton, threePlayerButton]:
		host.world.removeChild(button)
		button_row.addChild(button)
	_fit_buttons()

func original__onSizeChangeHandler():
	super.original__onSizeChangeHandler()
	if button_row != null: _fit_buttons()

func _fit_buttons():
	var bounds = Rect2()
	var first = true
	for button in [onePlayerButton, twoPlayerButton, threePlayerButton]:
		var local = button.getLocalBounds()
		var rect = Rect2(local.x + button.x, local.y + button.y, local.width, local.height)
		bounds = rect if first else bounds.merge(rect)
		first = false
	var available = (Vector2(game.width, game.height) - Vector2(32, 32)).max(Vector2.ONE)
	var fit = minf(1.0, minf(available.x / maxf(bounds.size.x, 1.0), available.y / maxf(bounds.size.y, 1.0)))
	var center = bounds.get_center()
	var half_height = bounds.size.y * fit * 0.5
	var target_y = clampf(center.y, 16 + half_height, game.height - 16 - half_height)
	button_row.scale.setTo(fit)
	button_row.position.setTo(game.width * 0.5 - center.x * fit, target_y - center.y * fit)

func original__addGuests(count):
	players_selected.emit(int(count))

func shutdown():
	original_shutdown()
	for item in [backgroundGroup, button_row]:
		game.world.removeChild(item)
		item.original_destroy()
	game.camera.reset()
	original_destroy()
