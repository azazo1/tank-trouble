extends RefCounted

const Vec = preload("res://game/physics/vector.gd")
const MathTypes = preload("res://game/physics/math.gd")
const Shapes = preload("res://game/physics/shapes.gd")
const Definitions = preload("res://game/physics/definitions.gd")
const World = preload("res://game/physics/world.gd")

static var Common = {"Math": {"b2Vec2": Vec, "b2Mat22": MathTypes.Matrix, "b2Transform": MathTypes.Transform, "b2Math": MathTypes}}
static var Collision = {"Shapes": {"b2PolygonShape": Shapes.Polygon, "b2CircleShape": Shapes.Circle}, "b2WorldManifold": MathTypes.WorldManifold}
static var Dynamics = {"b2World": World, "b2BodyDef": Definitions.body_definition, "b2FixtureDef": Definitions.fixture_definition, "b2FilterData": Definitions.filter_data, "b2Body": {"b2_staticBody": 0, "b2_kinematicBody": 1, "b2_dynamicBody": 2}}

static func original_static_get(key):
	match key:
		"Common": return Common
		"Collision": return Collision
		"Dynamics": return Dynamics
	return null
