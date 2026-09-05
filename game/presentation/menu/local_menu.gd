extends "res://game/ported/presentation/game/uimenustate.gd"

signal players_selected(count)

func initialize(host):
	game = host
	original_create()

func original__addGuests(count):
	players_selected.emit(int(count))

func shutdown():
	original_shutdown()
	for item in [backgroundGroup, onePlayerButton, twoPlayerButton, threePlayerButton]:
		game.world.removeChild(item)
		item.original_destroy()
	game.camera.reset()
	original_destroy()
