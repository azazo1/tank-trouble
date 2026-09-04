class_name Pickup
extends RefCounted

const TYPES := ["RAPID", "BOUNCE", "SHOTGUN", "MISSILE", "LASER", "SHIELD"]
const TYPE_COLORS := {
	"RAPID": Color("#64e4ff"),
	"BOUNCE": Color("#ffcf63"),
	"SHOTGUN": Color("#ff8b7b"),
	"MISSILE": Color("#ff6fae"),
	"LASER": Color("#db8cff"),
	"SHIELD": Color("#71ffa3")
}

var position := Vector2.ZERO
var kind := "RAPID"
var phase := 0.0
var alive := true

static func make(at: Vector2, pickup_kind: String, offset: float) -> Pickup:
	var pickup := Pickup.new()
	pickup.position = at
	pickup.kind = pickup_kind
	pickup.phase = offset
	return pickup

func tick(delta: float) -> void:
	phase += delta

func color() -> Color:
	return TYPE_COLORS.get(kind, Color.WHITE)

