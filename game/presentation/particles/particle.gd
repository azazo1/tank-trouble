extends "res://game/presentation/bridge/image.gd"

var lifespan = 0.0

func pre_update(milliseconds):
	if not exists or game.physics.arcade.isPaused: return
	if lifespan > 0:
		lifespan -= milliseconds
		if lifespan <= 0:
			original_kill()
			return
	if body != null: body.advance(milliseconds / 1000.0)
	super.pre_update(milliseconds)

func original_onEmit(): pass
