extends RefCounted

const Vec = preload("res://game/physics/vector.gd")

static func filter_data():
	return {"categoryBits": 1, "maskBits": 65535, "groupIndex": 0}

static func fixture_definition():
	return {"shape": null, "userData": null, "friction": 0.2, "restitution": 0.0, "density": 0.0, "isSensor": false, "filter": filter_data()}

static func body_definition():
	return {"type": 0, "position": Vec.Make(), "angle": 0.0, "linearVelocity": Vec.Make(), "angularVelocity": 0.0, "linearDamping": 0.0, "angularDamping": 0.0, "allowSleep": true, "awake": true, "fixedRotation": false, "bullet": false, "active": true, "userData": null}
