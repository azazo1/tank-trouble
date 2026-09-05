extends RefCounted

var milliseconds: float

func _init(value = null):
	if value == null:
		var injected = load("res://game/runtime/js_support.gd").clock_milliseconds
		milliseconds = injected if injected != null else Time.get_unix_time_from_system() * 1000.0
	elif value is int or value is float: milliseconds = value
	else: milliseconds = Time.get_unix_time_from_datetime_string(str(value)) * 1000.0
	milliseconds = float(int(milliseconds))

func getTime():
	return milliseconds

func setUTCFullYear(year = 1970):
	var date := Time.get_datetime_dict_from_unix_time(int(milliseconds / 1000.0))
	date["year"] = int(year)
	milliseconds = Time.get_unix_time_from_datetime_dict(date) * 1000.0
	return milliseconds
