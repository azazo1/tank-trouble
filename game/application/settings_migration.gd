extends RefCounted

const CURRENT_VERSION := 1
const DEFAULTS := {"volume": 1.0, "quality": "high", "assignments": ["WASDKeys"]}
const QUALITIES := ["auto", "high", "low"]
const INPUT_SETS := ["WASDKeys", "arrowKeys", "mouse"]

static func normalize(source: Dictionary) -> Dictionary:
	var result = DEFAULTS.duplicate(true)
	var volume = source.get("volume")
	if (volume is float or volume is int) and is_finite(float(volume)):
		result.volume = clampf(float(volume), 0.0, 1.0)
	if source.get("quality") is String and source.quality.to_lower() in QUALITIES:
		result.quality = source.quality.to_lower()
	var assignments = source.get("assignments")
	if assignments is Array:
		var valid: Array = []
		for id in assignments:
			if id in INPUT_SETS and not valid.has(id): valid.append(id)
		if not valid.is_empty(): result.assignments = valid
	return result

static func migrate(payload: Dictionary) -> Dictionary:
	var version = payload.get("schema_version", 0)
	if not (version is int or version is float) or not is_finite(float(version)) or float(version) != floor(float(version)):
		return {"ok": false, "reason": "invalid_version"}
	if version < 0 or version > CURRENT_VERSION:
		return {"ok": false, "reason": "unsupported_version"}
	var migrated = payload.duplicate(true)
	if version == 0:
		migrated = {"schema_version": 1, "values": payload.get("values", payload)}
	if not migrated.get("values") is Dictionary:
		return {"ok": false, "reason": "invalid_values"}
	return {"ok": true, "from": version, "to": CURRENT_VERSION, "values": normalize(migrated.values)}
